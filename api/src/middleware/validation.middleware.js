const Joi = require('joi');

/**
 * Validation middleware factory
 * @param {Object} schema - Joi validation schema
 * @param {string} property - Request property to validate ('body', 'query', 'params')
 * @returns {Function} Express middleware function
 */
const validate = (schema, property = 'body') => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req[property], {
      abortEarly: false,
      stripUnknown: true
    });

    if (error) {
      const errorMessage = error.details.map(detail => detail.message).join(', ');
      return res.status(400).json({
        error: {
          code: 'BAD_REQUEST',
          message: errorMessage,
          traceId: req.headers['x-trace-id'] || 'unknown'
        }
      });
    }

    // Replace the request property with the validated and sanitized value
    req[property] = value;
    next();
  };
};

// Search validation schema
const searchSchema = Joi.object({
  q: Joi.string().max(120).required().messages({
    'string.empty': 'Search query is required',
    'string.max': 'Search query must be 120 characters or less'
  }),
  lat: Joi.number().min(-90).max(90).required().messages({
    'number.base': 'Latitude must be a number',
    'number.min': 'Latitude must be between -90 and 90',
    'number.max': 'Latitude must be between -90 and 90'
  }),
  lng: Joi.number().min(-180).max(180).required().messages({
    'number.base': 'Longitude must be a number',
    'number.min': 'Longitude must be between -180 and 180',
    'number.max': 'Longitude must be between -180 and 180'
  }),
  radius: Joi.number().min(1).max(5000).default(1500).messages({
    'number.base': 'Radius must be a number',
    'number.min': 'Radius must be at least 1 meter',
    'number.max': 'Radius must be at most 5000 meters'
  }),
  limit: Joi.number().min(1).max(20).default(10).messages({
    'number.base': 'Limit must be a number',
    'number.min': 'Limit must be at least 1',
    'number.max': 'Limit must be at most 20'
  })
});

// Place ID validation schema
const placeIdSchema = Joi.object({
  placeId: Joi.string().required().messages({
    'string.empty': 'Place ID is required'
  })
});

module.exports = {
  validate,
  searchSchema,
  placeIdSchema
};

