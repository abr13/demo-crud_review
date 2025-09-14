# API Documentation - CRUD App

## Overview
This document describes the REST API for the CRUD app backend. The API provides endpoints for searching places, retrieving place details, generating deep links, and health monitoring.

## Base Configuration
- **Base URL**: `https://your-api-domain.com/v1`
- **Content Type**: `application/json`
- **Authentication**: Optional (Bearer token)
- **Rate Limiting**: 100 requests per 15 minutes per IP

## Endpoints

### 1. Search Places

Search for businesses and places using text query and location.

**Endpoint**: `GET /v1/search`

**Query Parameters**:
- `q` (string, required): Search query text
- `lat` (number, required): Latitude coordinate
- `lng` (number, required): Longitude coordinate
- `radius` (number, optional): Search radius in meters (default: 1500, max: 5000)
- `limit` (number, optional): Maximum results to return (default: 10, max: 20)

**Example Request**:
```http
GET /v1/search?q=italian restaurant&lat=12.9716&lng=77.5946&radius=2000&limit=10
```

**Response 200**:
```json
{
  "results": [
    {
      "placeId": "ChIJ1234567890",
      "name": "Mamma Mia Trattoria",
      "rating": 4.6,
      "userRatingsTotal": 312,
      "category": "Italian restaurant",
      "locality": "Indiranagar, Bengaluru",
      "distanceMeters": 540
    },
    {
      "placeId": "ChIJ0987654321",
      "name": "Bella Vista Pizzeria",
      "rating": 4.3,
      "userRatingsTotal": 89,
      "category": "Pizza restaurant",
      "locality": "Koramangala, Bengaluru",
      "distanceMeters": 1200
    }
  ],
  "nextPageToken": null
}
```

**Validation Rules**:
- `q`: Required, max 120 characters
- `lat`: Required, between -90 and 90
- `lng`: Required, between -180 and 180
- `radius`: Optional, between 1 and 5000 meters
- `limit`: Optional, between 1 and 20

---

### 2. Place Details

Get detailed information about a specific place including reviews.

**Endpoint**: `GET /v1/place/:placeId`

**Path Parameters**:
- `placeId` (string, required): Google Places place ID

**Example Request**:
```http
GET /v1/place/ChIJ1234567890
```

**Response 200**:
```json
{
  "placeId": "ChIJ1234567890",
  "name": "Mamma Mia Trattoria",
  "rating": 4.6,
  "userRatingsTotal": 312,
  "category": "Italian restaurant",
  "locality": "Indiranagar, Bengaluru",
  "openingHours": {
    "isOpenNow": true
  },
  "reviews": [
    {
      "rating": 5,
      "author": "Priya S.",
      "relativeTime": "2 weeks ago",
      "text": "Pesto pasta was outstanding. Great ambiance and friendly staff."
    },
    {
      "rating": 4,
      "author": "Raj K.",
      "relativeTime": "1 month ago",
      "text": "Good food, reasonable prices. Would recommend the lasagna."
    },
    {
      "rating": 5,
      "author": "Anita M.",
      "relativeTime": "1 month ago",
      "text": "Authentic Italian flavors. The tiramisu is a must-try!"
    }
  ]
}
```

**Notes**:
- Maximum 5 reviews returned
- Missing fields are omitted from response
- Reviews are sorted by relevance (not chronological)

---

### 3. Deep Link Generation

Generate a Google Maps deep link for a specific place.

**Endpoint**: `GET /v1/deeplink/:placeId`

**Path Parameters**:
- `placeId` (string, required): Google Places place ID

**Example Request**:
```http
GET /v1/deeplink/ChIJ1234567890
```

**Response 200**:
```json
{
  "url": "https://www.google.com/maps/place/?q=place_id:ChIJ1234567890"
}
```

**Usage**:
- Use this URL to open the place in Google Maps app
- Works on both mobile and web platforms
- Redirects to appropriate Google Maps interface

---

### 4. Health Check

Check the health and status of the API service.

**Endpoint**: `GET /v1/health`

**Example Request**:
```http
GET /v1/health
```

**Response 200**:
```json
{
  "ok": true,
  "version": "1.0.0",
  "uptimeSec": 12345,
  "timestamp": "2024-09-14T10:30:00Z"
}
```

**Response Fields**:
- `ok`: Service health status (boolean)
- `version`: API version (string)
- `uptimeSec`: Service uptime in seconds (number)
- `timestamp`: Current server timestamp (ISO 8601)

---

## Error Responses

All error responses follow a consistent format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "traceId": "abc123def456"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `BAD_REQUEST` | 400 | Invalid request parameters |
| `UNAUTHORIZED` | 401 | Authentication required |
| `NOT_FOUND` | 404 | Resource not found |
| `RATE_LIMITED` | 429 | Too many requests |
| `UPSTREAM_ERROR` | 502 | Google Places API error |
| `INTERNAL_ERROR` | 500 | Internal server error |

### Example Error Responses

**400 Bad Request**:
```json
{
  "error": {
    "code": "BAD_REQUEST",
    "message": "Invalid latitude value. Must be between -90 and 90.",
    "traceId": "abc123def456"
  }
}
```

**429 Rate Limited**:
```json
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests. Please try again later.",
    "traceId": "abc123def456"
  }
}
```

**500 Internal Error**:
```json
{
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "An unexpected error occurred. Please try again.",
    "traceId": "abc123def456"
  }
}
```

---

## Rate Limiting

- **Limit**: 100 requests per 15 minutes per IP address
- **Headers**: Rate limit information included in response headers
- **Exceeded**: Returns 429 status with retry-after header

**Rate Limit Headers**:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1631692800
Retry-After: 900
```

---

## Caching

The API implements intelligent caching to improve performance:

- **Search Results**: Cached for 2-5 minutes
- **Place Details**: Cached for 15-60 minutes
- **Cache Keys**: Based on query parameters and place IDs
- **Cache Headers**: Standard HTTP cache headers included

**Cache Headers**:
```
Cache-Control: public, max-age=300
ETag: "abc123def456"
Last-Modified: Wed, 14 Sep 2024 10:30:00 GMT
```

---

## Data Models

### SearchResult
```typescript
interface SearchResult {
  placeId: string;           // Google Places place ID
  name: string;              // Business name
  rating: number;            // Average rating (1-5)
  userRatingsTotal: number;  // Total number of reviews
  category: string;          // Primary business category
  locality: string;          // Location/neighborhood
  distanceMeters: number;    // Distance from search location
}
```

### PlaceDetails
```typescript
interface PlaceDetails {
  placeId: string;
  name: string;
  rating: number;
  userRatingsTotal: number;
  category: string;
  locality: string;
  openingHours?: {
    isOpenNow: boolean;
  };
  reviews: Review[];
}

interface Review {
  rating: number;            // Review rating (1-5)
  author: string;            // Reviewer name (anonymized)
  relativeTime: string;      // Time since review (e.g., "2 weeks ago")
  text: string;              // Review text content
}
```

### DeepLink
```typescript
interface DeepLink {
  url: string;               // Google Maps URL
}
```

### HealthStatus
```typescript
interface HealthStatus {
  ok: boolean;               // Service health status
  version: string;           // API version
  uptimeSec: number;         // Service uptime in seconds
  timestamp: string;         // Current timestamp (ISO 8601)
}
```

---

## SDKs and Libraries

### Flutter/Dart
```dart
// Example usage with Dio
final response = await dio.get('/v1/search', queryParameters: {
  'q': 'italian restaurant',
  'lat': 12.9716,
  'lng': 77.5946,
  'radius': 2000,
  'limit': 10,
});
```

### JavaScript/Node.js
```javascript
// Example usage with axios
const response = await axios.get('/v1/search', {
  params: {
    q: 'italian restaurant',
    lat: 12.9716,
    lng: 77.5946,
    radius: 2000,
    limit: 10
  }
});
```

### cURL Examples
```bash
# Search for places
curl "https://api.example.com/v1/search?q=restaurant&lat=12.9716&lng=77.5946"

# Get place details
curl "https://api.example.com/v1/place/ChIJ1234567890"

# Generate deep link
curl "https://api.example.com/v1/deeplink/ChIJ1234567890"

# Health check
curl "https://api.example.com/v1/health"
```

---

## Postman Collection

A complete Postman collection is available in `ops/postman/crud-api.json` with:
- All endpoint examples
- Environment variables
- Test scripts
- Pre-request scripts

Import the collection to test the API endpoints easily.

---

## Changelog

### v1.0.0 (2024-09-14)
- Initial API release
- Search, place details, deep link, and health endpoints
- Rate limiting and caching implementation
- Comprehensive error handling

