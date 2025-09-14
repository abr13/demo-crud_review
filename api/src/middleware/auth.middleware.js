/**
 * Authorization middleware for Bearer token validation
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
const validateAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  // Authorization is optional for anonymous reads
  if (!authHeader) {
    return next();
  }
  
  // Check if it's a Bearer token
  if (!authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      error: {
        code: 'UNAUTHORIZED',
        message: 'Invalid authorization header format. Expected: Bearer <token>',
        traceId: req.headers['x-trace-id'] || 'unknown'
      }
    });
  }
  
  const token = authHeader.substring(7); // Remove 'Bearer ' prefix
  
  // For MVP, we'll just validate the token format
  // In production, you would validate against your auth service
  if (token.length < 10) {
    return res.status(401).json({
      error: {
        code: 'UNAUTHORIZED',
        message: 'Invalid token format',
        traceId: req.headers['x-trace-id'] || 'unknown'
      }
    });
  }
  
  // Add user info to request (for future use)
  req.user = {
    token: token,
    // In production, you would decode the JWT and add user details
  };
  
  next();
};

module.exports = { validateAuth };


