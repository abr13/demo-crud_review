const cacheService = require('../services/cache.service');
const googlePlacesService = require('../services/google-places.service');
const config = require('../config/environment');

// Module-level start time
const startTime = Date.now();

/**
 * Health controller for monitoring and health checks
 */
class HealthController {

  /**
   * Basic health check endpoint
   * @param {Object} req - Express request object
   * @param {Object} res - Express response object
   * @param {Function} next - Express next function
   */
  async healthCheck(req, res, next) {
    try {
      const uptimeSec = Math.floor((Date.now() - startTime) / 1000);
      const cacheStats = await cacheService.getStats();

      res.json({
        ok: true,
        version: config.apiVersion,
        uptimeSec,
        timestamp: new Date().toISOString(),
        environment: config.nodeEnv,
        cache: {
          connected: cacheService.isConnected,
          stats: cacheStats
        }
      });
    } catch (error) {
      next(error);
    }
  }

}

module.exports = new HealthController();
