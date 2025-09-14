const googlePlacesService = require('../services/google-places.service');
const cacheService = require('../services/cache.service');
const config = require('../config/environment');

/**
 * Search controller for handling business search requests
 */
class SearchController {
  /**
   * Search for businesses using Google Places API
   * @param {Object} req - Express request object
   * @param {Object} res - Express response object
   * @param {Function} next - Express next function
   */
  async search(req, res, next) {
    try {
      const { q, lat, lng, radius = config.defaultRadius, limit = config.defaultLimit } = req.query;
      
      // Generate cache key
      const cacheKey = cacheService.generateSearchKey(q, lat, lng, radius, limit);

      // Check cache first
      const cachedResult = await cacheService.get(cacheKey);
      if (cachedResult) {
        console.log('Cache hit for search:', cacheKey);
        return res.json(cachedResult);
      }

      console.log('Cache miss for search:', cacheKey);

      // Call Google Places API
      const location = `${lat},${lng}`;
      const googleResponse = await googlePlacesService.textSearch(q, location, radius);

      // Transform and filter results
      const results = googleResponse.results
        .slice(0, limit)
        .map(place => googlePlacesService.transformSearchResult(place, lat, lng))
        .filter(place => {
          // Filter out places with very low ratings
          if (place.rating < 2.0) return false;
          
          // Filter out places with very few reviews
          if (place.userRatingsTotal < 5) return false;
          
          return true;
        });

      const response = {
        results,
        nextPageToken: googleResponse.next_page_token || null
      };

      // Cache the response
      await cacheService.set(cacheKey, response, config.searchCacheTtl);

      res.json(response);
    } catch (error) {
      next(error);
    }
  }


}

module.exports = new SearchController();
