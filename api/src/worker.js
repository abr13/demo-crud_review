/**
 * Cloudflare Workers entry point for CRUD App Backend
 * This is a simplified version for Cloudflare Workers deployment
 */

import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { logger } from 'hono/logger';
import { rateLimiter } from 'hono/rate-limiter';

// Import our services (adapted for Workers)
import { GooglePlacesService } from './services/google-places.service.js';
import { CacheService } from './services/cache.service.js';

const app = new Hono();

// Middleware
app.use('*', logger());
app.use('*', cors({
  origin: (origin) => {
    const allowedOrigins = [
      'http://localhost:3000',
      'https://your-flutter-app.com'
    ];
    return allowedOrigins.includes(origin) ? origin : 'https://your-flutter-app.com';
  }
}));

// Rate limiting
app.use('*', rateLimiter({
  windowMs: 15 * 60 * 1000, // 15 minutes
  limit: 100, // limit each IP to 100 requests per windowMs
  standardHeaders: 'draft-6',
  keyGenerator: (c) => c.req.header('cf-connecting-ip') || 'unknown'
}));

// Initialize services
const googlePlacesService = new GooglePlacesService();
const cacheService = new CacheService();

// Health check
app.get('/v1/health', (c) => {
  return c.json({
    ok: true,
    version: '1.0.0',
    uptimeSec: Math.floor((Date.now() - startTime) / 1000),
    timestamp: new Date().toISOString(),
    environment: 'production'
  });
});

// Search endpoint
app.get('/v1/search', async (c) => {
  try {
    const { q, lat, lng, radius = 1500, limit = 10 } = c.req.query();
    
    // Validation
    if (!q || !lat || !lng) {
      return c.json({
        error: {
          code: 'BAD_REQUEST',
          message: 'Missing required parameters: q, lat, lng',
          traceId: c.req.header('cf-ray') || 'unknown'
        }
      }, 400);
    }

    // Generate cache key
    const cacheKey = `search:${Buffer.from(`${q}:${lat}:${lng}:${radius}:${limit}`).toString('base64')}`;

    // Check cache
    const cachedResult = await cacheService.get(cacheKey);
    if (cachedResult) {
      return c.json(cachedResult);
    }

    // Call Google Places API
    const location = `${lat},${lng}`;
    const googleResponse = await googlePlacesService.textSearch(q, location, parseInt(radius));

    // Transform results
    const results = googleResponse.results
      .slice(0, parseInt(limit))
      .map(place => ({
        placeId: place.place_id,
        name: place.name,
        rating: place.rating || 0,
        userRatingsTotal: place.user_ratings_total || 0,
        category: place.types?.[0] || 'Business',
        locality: place.vicinity || 'Unknown location',
        distanceMeters: calculateDistance(
          parseFloat(lat),
          parseFloat(lng),
          place.geometry.location.lat,
          place.geometry.location.lng
        )
      }));

    const response = { results, nextPageToken: googleResponse.next_page_token || null };

    // Cache the response
    await cacheService.set(cacheKey, response, 180); // 3 minutes

    return c.json(response);
  } catch (error) {
    return c.json({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Internal server error',
        traceId: c.req.header('cf-ray') || 'unknown'
      }
    }, 500);
  }
});

// Place details endpoint
app.get('/v1/place/:placeId', async (c) => {
  try {
    const placeId = c.req.param('placeId');
    
    if (!placeId) {
      return c.json({
        error: {
          code: 'BAD_REQUEST',
          message: 'Place ID is required',
          traceId: c.req.header('cf-ray') || 'unknown'
        }
      }, 400);
    }

    // Generate cache key
    const cacheKey = `place:${placeId}`;

    // Check cache
    const cachedResult = await cacheService.get(cacheKey);
    if (cachedResult) {
      return c.json(cachedResult);
    }

    // Call Google Places API
    const googleResponse = await googlePlacesService.placeDetails(placeId);
    const result = googleResponse.result;

    // Transform the response
    const placeDetails = {
      placeId: result.place_id,
      name: result.name,
      rating: result.rating || 0,
      userRatingsTotal: result.user_ratings_total || 0,
      category: result.types && result.types.length > 0 ? result.types[0] : 'Business',
      locality: result.formatted_address || 'Unknown location',
      openingHours: result.opening_hours ? {
        isOpenNow: result.opening_hours.open_now
      } : null,
      reviews: result.reviews ? result.reviews.slice(0, 5).map(review => ({
        rating: review.rating,
        author: review.author_name,
        relativeTime: review.relative_time_description,
        text: review.text
      })) : []
    };

    // Cache the response
    await cacheService.set(cacheKey, placeDetails, 3600); // 1 hour

    return c.json(placeDetails);
  } catch (error) {
    return c.json({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Internal server error',
        traceId: c.req.header('cf-ray') || 'unknown'
      }
    }, 500);
  }
});

// Deeplink endpoint
app.get('/v1/deeplink/:placeId', async (c) => {
  try {
    const placeId = c.req.param('placeId');
    
    if (!placeId) {
      return c.json({
        error: {
          code: 'BAD_REQUEST',
          message: 'Place ID is required',
          traceId: c.req.header('cf-ray') || 'unknown'
        }
      }, 400);
    }

    // Generate cache key
    const cacheKey = `deeplink:${placeId}`;

    // Check cache
    const cachedResult = await cacheService.get(cacheKey);
    if (cachedResult) {
      return c.json(cachedResult);
    }

    // Generate Google Maps URL
    const mapsUrl = `https://www.google.com/maps/place/?q=place_id:${placeId}`;
    const response = { url: mapsUrl };

    // Cache the response
    await cacheService.set(cacheKey, response, 3600); // 1 hour

    return c.json(response);
  } catch (error) {
    return c.json({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Internal server error',
        traceId: c.req.header('cf-ray') || 'unknown'
      }
    }, 500);
  }
});

// Helper function to calculate distance
function calculateDistance(lat1, lng1, lat2, lng2) {
  const R = 6371e3; // Earth's radius in meters
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lng2 - lng1) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return Math.round(R * c);
}

const startTime = Date.now();

export default app;
