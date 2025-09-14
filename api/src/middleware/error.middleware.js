const config = require('../config/environment');

/**
 * Centralized error handling middleware
 * @param {Error} err - Error object
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  // Log error
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
    traceId: req.headers['x-trace-id'] || 'unknown'
  });

  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    const message = 'Resource not found';
    error = { message, statusCode: 404 };
  }

  // Mongoose duplicate key
  if (err.code === 11000) {
    const message = 'Duplicate field value entered';
    error = { message, statusCode: 400 };
  }

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors).map(val => val.message).join(', ');
    error = { message, statusCode: 400 };
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    const message = 'Invalid token';
    error = { message, statusCode: 401 };
  }

  if (err.name === 'TokenExpiredError') {
    const message = 'Token expired';
    error = { message, statusCode: 401 };
  }

  // Axios errors (Google Places API)
  if (err.isAxiosError) {
    if (err.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      const statusCode = err.response.status;
      let message = 'External API error';
      
      if (statusCode === 400) {
        message = 'Invalid request to external service';
      } else if (statusCode === 403) {
        message = 'External service access denied';
      } else if (statusCode === 404) {
        message = 'External service resource not found';
      } else if (statusCode >= 500) {
        message = 'External service unavailable';
      }
      
      error = { message, statusCode };
    } else if (err.request) {
      // The request was made but no response was received
      error = { message: 'External service timeout', statusCode: 504 };
    } else {
      // Something happened in setting up the request that triggered an Error
      error = { message: 'External service configuration error', statusCode: 500 };
    }
  }

  // Redis errors
  if (err.code === 'ECONNREFUSED' && err.syscall === 'connect') {
    error = { message: 'Cache service unavailable', statusCode: 503 };
  }

  const statusCode = error.statusCode || 500;
  const message = error.message || 'Internal Server Error';

  // Don't leak error details in production
  const errorResponse = {
    error: {
      code: getErrorCode(statusCode),
      message: config.nodeEnv === 'production' && statusCode === 500 
        ? 'Internal Server Error' 
        : message,
      traceId: req.headers['x-trace-id'] || 'unknown'
    }
  };

  res.status(statusCode).json(errorResponse);
};

/**
 * Map HTTP status codes to error codes
 * @param {number} statusCode - HTTP status code
 * @returns {string} Error code
 */
const getErrorCode = (statusCode) => {
  const errorCodes = {
    400: 'BAD_REQUEST',
    401: 'UNAUTHORIZED',
    403: 'FORBIDDEN',
    404: 'NOT_FOUND',
    409: 'CONFLICT',
    422: 'UNPROCESSABLE_ENTITY',
    429: 'RATE_LIMITED',
    500: 'INTERNAL_ERROR',
    502: 'BAD_GATEWAY',
    503: 'SERVICE_UNAVAILABLE',
    504: 'GATEWAY_TIMEOUT'
  };
  
  return errorCodes[statusCode] || 'INTERNAL_ERROR';
};

module.exports = {
  errorHandler
};


