const express = require('express');
const placeController = require('../controllers/place.controller');
const { validate, placeIdSchema } = require('../middleware/validation.middleware');

const router = express.Router();

/**
 * @swagger
 * /v1/place/{placeId}:
 *   get:
 *     summary: Get place details
 *     description: Get detailed information about a place including reviews
 *     tags: [Place]
 *     parameters:
 *       - in: path
 *         name: placeId
 *         required: true
 *         schema:
 *           type: string
 *         description: Google Place ID
 *         example: "ChIJ123..."
 *     responses:
 *       200:
 *         description: Place details
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 placeId:
 *                   type: string
 *                   example: "ChIJ123..."
 *                 name:
 *                   type: string
 *                   example: "Mamma Mia Trattoria"
 *                 rating:
 *                   type: number
 *                   example: 4.6
 *                 userRatingsTotal:
 *                   type: number
 *                   example: 312
 *                 category:
 *                   type: string
 *                   example: "Italian restaurant"
 *                 locality:
 *                   type: string
 *                   example: "Indiranagar, Bengaluru"
 *                 openingHours:
 *                   type: object
 *                   properties:
 *                     isOpenNow:
 *                       type: boolean
 *                       example: true
 *                 reviews:
 *                   type: array
 *                   maxItems: 5
 *                   items:
 *                     type: object
 *                     properties:
 *                       rating:
 *                         type: number
 *                         example: 5
 *                       author:
 *                         type: string
 *                         example: "Priya S."
 *                       relativeTime:
 *                         type: string
 *                         example: "2 weeks ago"
 *                       text:
 *                         type: string
 *                         example: "Pesto pasta was outstanding."
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: Place not found
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
router.get('/:placeId', validate(placeIdSchema, 'params'), placeController.getPlaceDetails);


module.exports = router;
