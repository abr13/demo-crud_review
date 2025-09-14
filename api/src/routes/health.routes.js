const express = require('express');
const healthController = require('../controllers/health.controller');

const router = express.Router();

/**
 * @swagger
 * /v1/health:
 *   get:
 *     summary: Basic health check
 *     description: Simple health check endpoint
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: Service is healthy
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 ok:
 *                   type: boolean
 *                   example: true
 *                 version:
 *                   type: string
 *                   example: "1.0.0"
 *                 uptimeSec:
 *                   type: number
 *                   example: 12345
 *                 timestamp:
 *                   type: string
 *                   format: date-time
 *                   example: "2023-12-01T10:30:00.000Z"
 *                 environment:
 *                   type: string
 *                   example: "development"
 *       500:
 *         description: Service is unhealthy
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/', healthController.healthCheck);


module.exports = router;
