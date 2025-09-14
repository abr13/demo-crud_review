# CRUD App Backend

A Node.js backend API that wraps Google Places API for the CRUD app - a Google Reviews wrapper with familiar UX.

## Features

- **Google Places Integration**: Text search and place details via Google Places API
- **Redis Caching**: Short-term caching for improved performance
- **Rate Limiting**: Protection against abuse
- **Input Validation**: Comprehensive request validation
- **Error Handling**: Centralized error handling with trace IDs
- **Health Monitoring**: Health checks and metrics endpoints
- **API Documentation**: Swagger/OpenAPI documentation

## API Endpoints

### Search
- `GET /v1/search` - Search for businesses
- `GET /v1/search/suggestions` - Get search suggestions (placeholder)

### Place Details
- `GET /v1/place/:placeId` - Get place details with reviews
- `GET /v1/place/:placeId/reviews` - Get place reviews
- `GET /v1/place/:placeId/hours` - Get place opening hours

### Deeplinks
- `GET /v1/deeplink/:placeId` - Generate Google Maps URL
- `POST /v1/deeplink/bulk` - Generate multiple deeplinks
- `GET /v1/deeplink/:placeId/validate` - Validate place ID

### Health
- `GET /v1/health` - Basic health check
- `GET /v1/health/detailed` - Detailed health check
- `GET /v1/health/metrics` - System metrics
- `GET /v1/health/ready` - Readiness probe
- `GET /v1/health/live` - Liveness probe

## Quick Start

### Prerequisites

- Node.js 18+
- Redis instance (Upstash recommended)
- Google Places API key

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Copy environment file:
   ```bash
   cp env.example .env
   ```

4. Configure environment variables in `.env`:
   ```env
   GOOGLE_PLACES_API_KEY=your_google_places_api_key
   REDIS_URL=your_redis_url
   PORT=3000
   NODE_ENV=development
   ```

### Running the Application

#### Development
```bash
npm run dev
```

#### Production
```bash
npm start
```

The API will be available at `http://localhost:3000`

### API Documentation

Visit `http://localhost:3000/api-docs` for interactive API documentation.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `GOOGLE_PLACES_API_KEY` | Google Places API key | Required |
| `REDIS_URL` | Redis connection URL | Required |
| `PORT` | Server port | 3000 |
| `NODE_ENV` | Environment | development |
| `RATE_LIMIT_WINDOW_MS` | Rate limit window | 900000 (15 min) |
| `RATE_LIMIT_MAX_REQUESTS` | Max requests per window | 100 |
| `CORS_ORIGIN` | CORS origin | * |
| `SEARCH_CACHE_TTL` | Search cache TTL (seconds) | 180 (3 min) |
| `PLACE_CACHE_TTL` | Place cache TTL (seconds) | 3600 (1 hour) |

## Performance Targets

- `/v1/search` ≤ 300-400 ms (in-region)
- `/v1/place/:id` ≤ 400-500 ms (in-region)
- Cache hit rate ≥ 60% on repeated queries
- Availability ≥ 99.5%

## Caching Strategy

- **Search Results**: 2-5 minutes TTL
- **Place Summaries**: 15-60 minutes TTL
- **Never Persist**: Google review texts beyond TTL
- **Cache Keys**: Hash-based for search, place_id for details

## Error Handling

All errors follow a consistent format:

```json
{
  "error": {
    "code": "BAD_REQUEST",
    "message": "Error description",
    "traceId": "abc123"
  }
}
```

Error codes: `BAD_REQUEST`, `UNAUTHORIZED`, `NOT_FOUND`, `RATE_LIMITED`, `UPSTREAM_ERROR`, `INTERNAL_ERROR`

## Security

- No API keys exposed to frontend
- Input validation and sanitization
- Rate limiting per IP
- CORS configuration
- Security headers with Helmet

## Deployment

### Cloudflare Workers (Recommended)
```bash
npm install -g wrangler
wrangler login
wrangler deploy
```

### GCP Cloud Run
```bash
gcloud run deploy crud-app-backend --source .
```

## Development

### Project Structure
```
src/
├── config/          # Configuration files
├── middleware/      # Express middleware
├── services/        # Business logic services
├── controllers/     # Request handlers
├── routes/          # API routes
├── utils/           # Utility functions
├── types/           # Type definitions
└── docs/            # Documentation
```

### Adding New Endpoints

1. Create controller in `src/controllers/`
2. Create routes in `src/routes/`
3. Add validation middleware
4. Update Swagger documentation
5. Add to main app in `src/app.js`

## Testing

```bash
# Run tests (when implemented)
npm test

# Test with Postman collection
# Import postman/crud-api.json
```

## Monitoring

- Health checks: `/v1/health`
- Metrics: `/v1/health/metrics`
- Logging: Structured JSON logs
- Trace IDs: For request correlation

## License

ISC


