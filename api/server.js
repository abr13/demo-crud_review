// Load environment variables first
require('dotenv').config();

const app = require('./src/app');
const config = require('./src/config/environment');
const cacheService = require('./src/services/cache.service');

const startServer = async () => {
  try {
    // Initialize cache service
    console.log('🔄 Initializing cache service...');
    await cacheService.connect();
    
    const server = app.listen(config.port, () => {
      console.log(`🚀 CRUD App API server running on port ${config.port}`);
      console.log(`📚 API Documentation: http://localhost:${config.port}/api-docs`);
      console.log(`🏥 Health Check: http://localhost:${config.port}/v1/health`);
      console.log(`🌍 Environment: ${config.nodeEnv}`);
      console.log(`💾 Cache Status: ${cacheService.isConnected ? 'Connected' : 'Disconnected'}`);
    });

    // Graceful shutdown
    process.on('SIGTERM', () => {
      console.log('SIGTERM received, shutting down gracefully');
      server.close(async () => {
        console.log('Disconnecting cache service...');
        await cacheService.disconnect();
        console.log('Process terminated');
        process.exit(0);
      });
    });

    process.on('SIGINT', () => {
      console.log('SIGINT received, shutting down gracefully');
      server.close(async () => {
        console.log('Disconnecting cache service...');
        await cacheService.disconnect();
        console.log('Process terminated');
        process.exit(0);
      });
    });

  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
};

startServer();
