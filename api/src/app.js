const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');

const config = require('./config/environment');
const { errorHandler } = require('./middleware/error.middleware');
const { requestLogger } = require('./middleware/logger.middleware');
const { validateAuth } = require('./middleware/auth.middleware');

// Import routes
const searchRoutes = require('./routes/search.routes');
const placeRoutes = require('./routes/place.routes');
const healthRoutes = require('./routes/health.routes');

const app = express();

// Swagger configuration
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'CRUD App API',
      version: config.apiVersion,
      description: 'Backend for Frontend API for CRUD app - Google Reviews wrapper',
    },
    servers: [
      {
        url: `http://localhost:${config.port}`,
        description: 'Development server',
      },
    ],
  },
  apis: ['./src/routes/*.js', './src/controllers/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);

// Middleware
app.use(helmet());
app.use(cors({
  origin: config.corsOrigin,
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use(requestLogger);

// Authorization middleware (optional for anonymous reads)
app.use('/v1', validateAuth);

// Rate limiting
const limiter = rateLimit({
  windowMs: config.rateLimitWindowMs,
  max: config.rateLimitMaxRequests,
  message: { 
    error: { 
      code: 'RATE_LIMITED', 
      message: 'Too many requests from this IP, please try again later.' 
    } 
  },
  standardHeaders: true,
  legacyHeaders: false,
});
app.use('/v1', limiter);

// API Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Routes
app.use('/v1/search', searchRoutes);
app.use('/v1/place', placeRoutes);
app.use('/v1/health', healthRoutes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'CRUD App API',
    version: config.apiVersion,
    docs: '/api-docs',
    health: '/v1/health'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: {
      code: 'NOT_FOUND',
      message: 'Endpoint not found',
      traceId: req.headers['x-trace-id'] || 'unknown'
    }
  });
});

// Error handling middleware (must be last)
app.use(errorHandler);

module.exports = app;
