const googlePlacesService = require('../services/google-places.service');
const cacheService = require('../services/cache.service');
const config = require('../config/environment');

/**
 * Place controller for handling place details requests
 */
class PlaceController {
  /**
   * Get place details by place ID
   * @param {Object} req - Express request object
   * @param {Object} res - Express response object
   * @param {Function} next - Express next function
   */
  async getPlaceDetails(req, res, next) {
    try {
      const { placeId } = req.params;

      // Generate cache key
      const cacheKey = cacheService.generatePlaceKey(placeId);

      // Check cache first
      const cachedResult = await cacheService.get(cacheKey);
      if (cachedResult) {
        console.log('Cache hit for place details:', cacheKey);
        return res.json(cachedResult);
      }

      console.log('Cache miss for place details:', cacheKey);

      // Call Google Places API
      const googleResponse = await googlePlacesService.placeDetails(placeId);

      // Transform the response
      const placeDetails = googlePlacesService.transformPlaceDetails(googleResponse);

      // Cache the response
      await cacheService.set(cacheKey, placeDetails, config.placeCacheTtl);

      res.json(placeDetails);
    } catch (error) {
      next(error);
    }
  }

}

module.exports = new PlaceController();
