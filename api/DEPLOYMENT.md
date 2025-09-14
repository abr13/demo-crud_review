# Deployment Guide

This guide covers deployment options for the CRUD App Backend.

## Option 1: Cloudflare Workers (Recommended)

### Prerequisites
- Cloudflare account
- Wrangler CLI installed

### Setup
```bash
# Install Wrangler CLI
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Install Workers dependencies
npm install --package-lock-only --package-lock=package-workers.json
```

### Configuration
1. Update `wrangler.toml` with your settings
2. Set up KV namespace for caching:
   ```bash
   wrangler kv:namespace create "CACHE"
   wrangler kv:namespace create "CACHE" --preview
   ```
3. Update the KV namespace IDs in `wrangler.toml`

### Secrets
Set your secrets using Wrangler:
```bash
# Google Places API Key
wrangler secret put GOOGLE_PLACES_API_KEY

# Redis URL (if using external Redis)
wrangler secret put REDIS_URL

# CORS Origin
wrangler secret put CORS_ORIGIN
```

### Deployment
```bash
# Deploy to staging
npm run deploy:staging

# Deploy to production
npm run deploy:prod
```

### Monitoring
```bash
# View logs
npm run tail

# View analytics in Cloudflare Dashboard
```

## Option 2: GCP Cloud Run

### Prerequisites
- Google Cloud account
- gcloud CLI installed
- Docker installed

### Setup
1. Create a Dockerfile:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

2. Build and deploy:
```bash
# Build image
gcloud builds submit --tag gcr.io/PROJECT_ID/crud-app-backend

# Deploy to Cloud Run
gcloud run deploy crud-app-backend \
  --image gcr.io/PROJECT_ID/crud-app-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars NODE_ENV=production
```

### Environment Variables
Set in Cloud Run console or via CLI:
```bash
gcloud run services update crud-app-backend \
  --set-env-vars GOOGLE_PLACES_API_KEY=your_key \
  --set-env-vars REDIS_URL=your_redis_url
```

## Option 3: Traditional VPS/Server

### Prerequisites
- Ubuntu/CentOS server
- Node.js 18+
- Redis server
- PM2 for process management

### Setup
```bash
# Install dependencies
sudo apt update
sudo apt install nodejs npm redis-server

# Clone and setup
git clone your-repo
cd crud-app-backend
npm install

# Setup environment
cp env.example .env
# Edit .env with your values

# Install PM2
npm install -g pm2

# Start application
pm2 start server.js --name crud-app-backend
pm2 startup
pm2 save
```

### Nginx Configuration
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Environment Variables

### Required
- `GOOGLE_PLACES_API_KEY` - Your Google Places API key
- `REDIS_URL` - Redis connection URL

### Optional
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Environment (development/production)
- `CORS_ORIGIN` - Allowed CORS origins
- `RATE_LIMIT_WINDOW_MS` - Rate limit window (default: 900000)
- `RATE_LIMIT_MAX_REQUESTS` - Max requests per window (default: 100)

## Performance Optimization

### Cloudflare Workers
- Use KV for caching instead of external Redis
- Enable Cloudflare caching for static responses
- Use Cloudflare Analytics for monitoring

### Cloud Run
- Set appropriate CPU and memory limits
- Use Cloud SQL for persistent data if needed
- Enable Cloud Logging and Monitoring

### VPS
- Use Redis for caching
- Set up monitoring with PM2
- Use Nginx for load balancing and SSL

## Monitoring

### Health Checks
- Basic: `GET /v1/health`
- Detailed: `GET /v1/health/detailed`
- Metrics: `GET /v1/health/metrics`

### Logging
- Structured JSON logs
- Trace IDs for request correlation
- Error tracking and alerting

### Metrics to Monitor
- Response times
- Cache hit rates
- Error rates
- API usage
- Memory usage

## Security

### API Security
- Rate limiting enabled
- CORS properly configured
- Input validation
- Error handling without data leakage

### Secrets Management
- Never commit API keys
- Use platform secret management
- Rotate keys regularly
- Monitor API usage

## Troubleshooting

### Common Issues
1. **Redis Connection Failed**
   - Check Redis URL
   - Verify network connectivity
   - Check Redis server status

2. **Google Places API Errors**
   - Verify API key
   - Check quota limits
   - Validate request parameters

3. **Rate Limiting Issues**
   - Check rate limit configuration
   - Monitor request patterns
   - Adjust limits if needed

### Debug Mode
Set `NODE_ENV=development` for detailed error messages and logging.

## Scaling

### Horizontal Scaling
- Use load balancer for multiple instances
- Ensure Redis is shared across instances
- Monitor resource usage

### Vertical Scaling
- Increase CPU/memory based on usage
- Optimize database queries
- Implement connection pooling

## Backup and Recovery

### Data Backup
- Redis data (if persistent)
- Environment configuration
- Application logs

### Recovery Procedures
- Document rollback procedures
- Test disaster recovery
- Monitor system health


