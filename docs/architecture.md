# System Architecture - CRUD App

## Overview
This document outlines the system architecture for the CRUD app - a lean MVP that wraps Google Reviews with a familiar Google-like UX. The system consists of a Flutter mobile app and a Node.js edge BFF, designed for speed and simplicity.

## High-Level Architecture

### System Components (MVP)
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Edge BFF      │    │  Google Places  │
│   (Mobile)      │◄──►│   (Node.js)     │◄──►│      API        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │
         │                       │
         │                       ▼
         │              ┌─────────────────┐
         │              │   Redis Cache   │
         │              │   (Short TTL)   │
         │              └─────────────────┘
         │
         ▼
┌─────────────────┐
│   Google Maps   │
│   (External)    │
└─────────────────┘
```

## Frontend Architecture (Flutter + BLoC)

### MVP Scope - 3 Screens Only
1. **Search Screen**: Sticky search bar with debounce (300-400ms)
2. **Results List**: Business cards with essential info
3. **Business Detail**: Header + filters + reviews (max 5)

### Architecture Layers
1. **Presentation Layer**: UI components, pages, widgets
2. **Business Logic Layer**: BLoC components, events, states
3. **Data Layer**: API repository, models

### Key Patterns
- **BLoC Pattern**: Consistent state management
- **Repository Pattern**: Single API client abstraction
- **Material 3 Design**: Google-like familiar UX
- **Performance Focus**: List virtualization, skeleton loaders

## Backend Architecture (Node.js Edge BFF)

### Architecture Layers
1. **Controller Layer**: Request/response handling
2. **Service Layer**: Google Places API integration
3. **Cache Layer**: Short-term response caching
4. **Proxy Layer**: Google Places API proxy

### Key Patterns
- **BFF Pattern**: Backend for Frontend proxy
- **Proxy Pattern**: Google Places API integration
- **Cache-First**: Short-term TTL caching
- **Stateless Design**: No persistent storage

### MVP Features
- Google Places API proxy
- Short-term caching (2-5 min search, 15-60 min details)
- Rate limiting and input validation
- Health monitoring

## Data Architecture (No Persistent Database)

### Caching Layer (Redis/Upstash)
- **Search Results**: 2-5 minutes TTL
- **Place Summaries**: 15-60 minutes TTL
- **Cache Keys**: Hash-based for search queries, place_id for details
- **Never Persist**: Google review texts beyond TTL

### Data Policy
- **Persist Indefinitely**: place_id references, derived metrics
- **Cache Short-term**: Search results, place summaries
- **Never Store**: Full review texts, bulk Google content

## Security Architecture

### API Security
- **No Scraping**: Only official Google Places APIs
- **API Keys**: Never exposed in Flutter app
- **Input Validation**: Bounds on radius, limit, query length
- **Rate Limiting**: Per IP/user with fair limits
- **CORS**: Locked to app origins

### Data Protection
- **Secrets Management**: Platform secrets, not in code
- **PII Protection**: Don't log personal information
- **Error Handling**: User-safe messages with trace IDs
- **Input Sanitization**: Validation and sanitization

## Performance Architecture

### Performance Targets (MVP)
- **Backend Latency**: 
  - `/v1/search` ≤ 300-400 ms (in-region)
  - `/v1/place/:id` ≤ 400-500 ms (in-region)
- **Cache Hit Rate**: ≥ 60% on repeated queries
- **Client UX**: End-to-end search to results ≤ 1.0-1.5s
- **Availability**: ≥ 99.5% during demo

### Frontend Optimization
- **List Virtualization**: Smooth scrolling performance
- **Skeleton Loaders**: Perceived performance
- **Debounced Search**: 300-400ms debounce
- **Material 3**: Google-like familiar UX

### Backend Optimization
- **Response Caching**: Short-term TTL caching
- **Field Masks**: Request only needed Google Places fields
- **Local Filtering**: Apply filters on returned payload
- **Edge Deployment**: Cloudflare Workers or GCP Cloud Run

## Monitoring & Observability (Minimal)

### Application Monitoring
- **Health Endpoint**: `/v1/health` with uptime tracking
- **Simple Logging**: Request/response logging
- **Error Tracking**: Trace IDs for debugging
- **Performance Monitoring**: Response time tracking

### Logging Strategy
- **Structured Logging**: JSON-formatted logs
- **Log Levels**: Info, warn, error
- **No PII Logging**: Don't log personal information
- **Trace IDs**: For error correlation

## Deployment Architecture

### Development Environment
- **Local Development**: Node.js with TypeScript
- **Version Control**: Git with feature branches
- **Code Quality**: ESLint, TypeScript
- **CI/CD**: Minimal (lint + build + deploy)

### Production Environment
- **Option 1**: Cloudflare Workers (recommended)
- **Option 2**: GCP Cloud Run
- **Auto-scaling**: Platform-managed
- **Global Distribution**: Edge deployment

## Technology Decisions

### Frontend (Flutter)
- **State Management**: BLoC for consistency
- **Network**: Dio for HTTP communication
- **UI**: Material 3 for Google-like design

### Backend (Node.js)
- **Framework**: Express.js for API development
- **Caching**: Redis/Upstash for short-term caching
- **External API**: Google Places API integration
- **Deployment**: Cloudflare Workers or GCP Cloud Run

### Infrastructure
- **Caching**: Upstash Redis for edge caching
- **API Proxy**: Google Places API
- **Monitoring**: Simple health checks
- **Security**: Rate limiting and input validation

## Conclusion

This MVP architecture provides a lean, fast foundation for the CRUD app that wraps Google Reviews. The design emphasizes speed, simplicity, and familiar UX patterns to ensure frictionless user adoption.

The architecture is intentionally minimal to avoid overengineering while maintaining the ability to scale. The focus on caching, performance targets, and Google-like UX ensures the app delivers on its core promise of providing a fast, familiar interface to Google Reviews.

