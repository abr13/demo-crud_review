const express = require('express');
const searchController = require('../controllers/search.controller');
const { validate, searchSchema } = require('../middleware/validation.middleware');

const router = express.Router();

/**
 * @swagger
 * /v1/search:
 *   get:
 *     summary: Search for businesses
 *     description: Search for businesses using Google Places API with caching
 *     tags: [Search]
 *     parameters:
 *       - in: query
 *         name: q
 *         required: true
 *         schema:
 *           type: string
 *           maxLength: 120
 *         description: Search query
 *         example: "restaurants near me"
 *       - in: query
 *         name: lat
 *         required: true
 *         schema:
 *           type: number
 *           minimum: -90
 *           maximum: 90
 *         description: Latitude
 *         example: 12.9716
 *       - in: query
 *         name: lng
 *         required: true
 *         schema:
 *           type: number
 *           minimum: -180
 *           maximum: 180
 *         description: Longitude
 *         example: 77.5946
 *       - in: query
 *         name: radius
 *         required: false
 *         schema:
 *           type: number
 *           minimum: 1
 *           maximum: 5000
 *           default: 1500
 *         description: Search radius in meters
 *         example: 1500
 *       - in: query
 *         name: limit
 *         required: false
 *         schema:
 *           type: number
 *           minimum: 1
 *           maximum: 20
 *           default: 10
 *         description: Maximum number of results
 *         example: 10
 *     responses:
 *       200:
 *         description: Search results
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 results:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       placeId:
 *                         type: string
 *                         example: "ChIJ123..."
 *                       name:
 *                         type: string
 *                         example: "Mamma Mia Trattoria"
 *                       rating:
 *                         type: number
 *                         example: 4.6
 *                       userRatingsTotal:
 *                         type: number
 *                         example: 312
 *                       category:
 *                         type: string
 *                         example: "Italian restaurant"
 *                       locality:
 *                         type: string
 *                         example: "Indiranagar, Bengaluru"
 *                       distanceMeters:
 *                         type: number
 *                         example: 540
 *                 nextPageToken:
 *                   type: string
 *                   nullable: true
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       429:
 *         description: Rate limit exceeded
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/', validate(searchSchema, 'query'), searchController.search);


module.exports = router;
