const config = {
  // Server Configuration
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  
  // Google Places API
  googlePlacesApiKey: process.env.GOOGLE_PLACES_API_KEY,
  googlePlacesBaseUrl: 'https://maps.googleapis.com/maps/api/place',
  
  // Redis Configuration
  redisUrl: process.env.REDIS_URL,
  
  // Rate Limiting
  rateLimitWindowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 900000, // 15 minutes
  rateLimitMaxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  
  // CORS
  corsOrigin: process.env.CORS_ORIGIN || '*',
  
  // Cache TTL (in seconds)
  searchCacheTtl: parseInt(process.env.SEARCH_CACHE_TTL) || 300, // 5 minutes (2-5 minutes range)
  placeCacheTtl: parseInt(process.env.PLACE_CACHE_TTL) || 3600, // 1 hour (15-60 minutes range)
  
  // API Version
  apiVersion: process.env.API_VERSION || '1.0.0',
  
  // Validation Rules
  maxQueryLength: 120,
  maxRadius: 5000,
  maxLimit: 20,
  defaultRadius: 1500,
  defaultLimit: 10,
  
  // Rate Limiting Rules
  rateLimitDefault: 10,
  rateLimitMax: 20,
  radiusDefault: 1500,
  radiusMax: 5000
};

// Validate required environment variables
const requiredEnvVars = ['GOOGLE_PLACES_API_KEY', 'REDIS_URL'];

for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    console.error(`Missing required environment variable: ${envVar}`);
    process.exit(1);
  }
}

module.exports = config;
