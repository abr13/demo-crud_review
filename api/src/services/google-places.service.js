const axios = require('axios');
const config = require('../config/environment');

class GooglePlacesService {
  constructor() {
    this.apiKey = config.googlePlacesApiKey;
    this.baseUrl = config.googlePlacesBaseUrl;
    this.timeout = 10000; // 10 seconds timeout
  }

  /**
   * Perform text search using Google Places API
   * @param {string} query - Search query
   * @param {string} location - Location in "lat,lng" format
   * @param {number} radius - Search radius in meters
   * @returns {Promise<Object>} Google Places API response
   */
  async textSearch(query, location, radius) {
    try {
      const response = await axios.get(`${this.baseUrl}/textsearch/json`, {
        params: {
          query: query,
          location: location,
          radius: radius,
          key: this.apiKey,
          fields: 'place_id,name,rating,user_ratings_total,types,vicinity,formatted_address,geometry'
        },
        timeout: this.timeout
      });

      if (response.data.status !== 'OK' && response.data.status !== 'ZERO_RESULTS') {
        throw new Error(`Google Places API error: ${response.data.status} - ${response.data.error_message || 'Unknown error'}`);
      }

      return response.data;
    } catch (error) {
      if (error.response) {
        // Google Places API returned an error response
        const status = error.response.status;
        const errorMessage = error.response.data?.error_message || 'Google Places API error';
        
        if (status === 400) {
          throw new Error(`Invalid request to Google Places API: ${errorMessage}`);
        } else if (status === 403) {
          throw new Error(`Google Places API access denied: ${errorMessage}`);
        } else if (status === 404) {
          throw new Error(`Google Places API endpoint not found`);
        } else {
          throw new Error(`Google Places API error (${status}): ${errorMessage}`);
        }
      } else if (error.request) {
        // Request was made but no response received
        throw new Error('Google Places API timeout - no response received');
      } else {
        // Something else happened
        throw new Error(`Google Places API request failed: ${error.message}`);
      }
    }
  }

  /**
   * Get place details using Google Places API
   * @param {string} placeId - Google Place ID
   * @returns {Promise<Object>} Google Places API response
   */
  async placeDetails(placeId) {
    try {
      const response = await axios.get(`${this.baseUrl}/details/json`, {
        params: {
          place_id: placeId,
          key: this.apiKey,
          fields: 'place_id,name,rating,user_ratings_total,types,formatted_address,opening_hours,reviews'
        },
        timeout: this.timeout
      });

      if (response.data.status !== 'OK') {
        throw new Error(`Google Places API error: ${response.data.status} - ${response.data.error_message || 'Unknown error'}`);
      }

      return response.data;
    } catch (error) {
      if (error.response) {
        // Google Places API returned an error response
        const status = error.response.status;
        const errorMessage = error.response.data?.error_message || 'Google Places API error';
        
        if (status === 400) {
          throw new Error(`Invalid request to Google Places API: ${errorMessage}`);
        } else if (status === 403) {
          throw new Error(`Google Places API access denied: ${errorMessage}`);
        } else if (status === 404) {
          throw new Error(`Google Places API endpoint not found`);
        } else {
          throw new Error(`Google Places API error (${status}): ${errorMessage}`);
        }
      } else if (error.request) {
        // Request was made but no response received
        throw new Error('Google Places API timeout - no response received');
      } else {
        // Something else happened
        throw new Error(`Google Places API request failed: ${error.message}`);
      }
    }
  }

  /**
   * Transform Google Places search result to our API format
   * @param {Object} place - Google Places result
   * @param {number} userLat - User latitude
   * @param {number} userLng - User longitude
   * @returns {Object} Transformed place data
   */
  transformSearchResult(place, userLat, userLng) {
    return {
      placeId: place.place_id,
      name: place.name,
      rating: place.rating || 0,
      userRatingsTotal: place.user_ratings_total || 0,
      category: place.types && place.types.length > 0 ? place.types[0] : 'Business',
      locality: place.vicinity || place.formatted_address || 'Location not available',
      distanceMeters: place.geometry && place.geometry.location ? 
        this.calculateDistance(
          userLat,
          userLng,
          place.geometry.location.lat,
          place.geometry.location.lng
        ) : 0
    };
  }

  /**
   * Transform Google Places details result to our API format
   * @param {Object} place - Google Places details result
   * @returns {Object} Transformed place data
   */
  transformPlaceDetails(place) {
    const result = place.result;
    
    return {
      placeId: result.place_id,
      name: result.name,
      rating: result.rating || 0,
      userRatingsTotal: result.user_ratings_total || 0,
      category: result.types && result.types.length > 0 ? result.types[0] : 'Business',
      locality: result.formatted_address || 'Location not available',
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
  }

  /**
   * Calculate distance between two coordinates using Haversine formula
   * @param {number} lat1 - First latitude
   * @param {number} lng1 - First longitude
   * @param {number} lat2 - Second latitude
   * @param {number} lng2 - Second longitude
   * @returns {number} Distance in meters
   */
  calculateDistance(lat1, lng1, lat2, lng2) {
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

}

// Create singleton instance
const googlePlacesService = new GooglePlacesService();

module.exports = googlePlacesService;
