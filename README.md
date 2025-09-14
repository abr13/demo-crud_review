# CRUD Review App

A full-stack application for searching and reviewing businesses using Google Places API, built with Flutter frontend and Node.js backend.

## 📁 Project Structure

```
/
├── app/                    # Flutter mobile application
├── api/                    # Node.js backend API (Edge BFF)
├── ops/                    # Infrastructure scripts, CI, Postman collections
│   ├── .github/workflows/  # CI/CD pipeline
│   └── postman/           # API testing collections
└── docs/                   # Essential documentation
    ├── architecture.md     # System architecture and design
    ├── decisions.md        # Architecture Decision Records
    └── api.md             # Complete API documentation
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** (v18.x or v20.x)
- **Flutter** (v3.24.0 or later)
- **Google Places API Key**
- **Redis instance** (Upstash or local)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd crud-review-app
   ```

2. **Complete setup with one command**
   ```bash
   make setup
   ```

3. **Configure environment variables**
   ```bash
   cp api/env.example api/.env
   # Edit api/.env with your actual values
   ```

4. **Start development servers**
   ```bash
   make dev
   ```

## 🛠️ Development

### Available Commands

Use the Makefile for convenient development commands:

```bash
# Show all available commands
make help

# Development
make dev              # Start both API and app development
make dev-api          # Start API server only
make run-app          # Run Flutter app

# Testing
make test             # Run all tests
make test-api         # Run API tests only
make test-app         # Run Flutter tests only

# Code Quality
make lint             # Lint all code
make format           # Format all code

# Building
make build            # Build all projects
make build-api        # Build API only
make build-app        # Build Flutter app only
```

### Manual Commands

#### API Development
```bash
cd api
npm install           # Install dependencies
npm run dev          # Start development server
npm test             # Run tests
npm run lint         # Lint code
```

#### Flutter App Development
```bash
cd app
flutter pub get      # Install dependencies
flutter run          # Run on device/emulator
flutter test         # Run tests
flutter analyze      # Analyze code
```

## 🧪 Testing

### API Testing
- **Unit Tests**: Jest framework
- **Integration Tests**: Supertest for API endpoints
- **Coverage**: Built-in coverage reports

```bash
cd api
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:ci            # CI mode
```

### Flutter Testing
- **Unit Tests**: Built-in Flutter testing framework
- **Widget Tests**: Component testing
- **Integration Tests**: End-to-end testing

```bash
cd app
flutter test               # Run all tests
flutter test --coverage    # With coverage
```

## 📚 Documentation

### Essential Documentation
- **[Architecture](docs/architecture.md)**: System architecture and design patterns
- **[Decisions](docs/decisions.md)**: Architecture Decision Records (ADRs)
- **[API Documentation](docs/api.md)**: Complete API reference and examples

### Interactive Documentation
- **Swagger UI**: Available at `http://localhost:3000/api-docs`
- **Postman Collection**: Located in `ops/postman/`

## 🚀 Deployment

### Staging Deployment
```bash
make deploy
```

### Production Deployment
```bash
make deploy-prod
```

### CI/CD Pipeline
- **Trigger**: Push to `main` or `develop` branches
- **Stages**: Lint → Test → Build → Deploy
- **Staging**: Auto-deploy from `develop` branch
- **Production**: Auto-deploy from `main` branch

## 🔧 Configuration

### Environment Variables

Key configuration options in `api/.env`:

```bash
# Google Places API
GOOGLE_PLACES_API_KEY=your_api_key_here

# Redis Configuration
REDIS_URL=your_redis_url_here

# Server Configuration
PORT=3000
NODE_ENV=development

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Cache TTL (seconds)
SEARCH_CACHE_TTL=300
PLACE_CACHE_TTL=3600
```

### Feature Flags
```bash
ENABLE_CACHE=true
ENABLE_RATE_LIMITING=true
ENABLE_LOGGING=true
ENABLE_SWAGGER=true
```

## 🐛 Troubleshooting

### Common Issues

#### API Server Won't Start
```bash
# Check if port is in use
lsof -i :3000

# Check environment variables
cat api/.env

# Check logs
cd api && npm run dev
```

#### Flutter App Build Issues
```bash
# Clean and rebuild
cd app
flutter clean
flutter pub get
flutter run
```

#### Redis Connection Issues
```bash
# Test Redis connection
redis-cli ping

# Check Redis URL in .env
echo $REDIS_URL
```

#### Google Places API Issues
- Verify API key is valid
- Check API quotas and billing
- Ensure Places API is enabled in Google Cloud Console

### Performance Issues

#### Slow API Responses
- Check Redis connection
- Verify cache TTL settings
- Monitor rate limiting

#### Flutter App Performance
- Use `flutter analyze` to check for issues
- Profile with `flutter run --profile`
- Check for memory leaks

### Debug Mode

#### API Debug
```bash
cd api
DEBUG=* npm run dev
```

#### Flutter Debug
```bash
cd app
flutter run --debug
```

## 📊 Monitoring

### Health Checks
```bash
make health              # Check API health
curl http://localhost:3000/health
```

### Metrics
- **API Metrics**: Available at `http://localhost:9090/metrics`
- **Logs**: Structured logging with configurable levels
- **Performance**: Request timing and error tracking

## 🤝 Contributing

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Run tests**: `make test`
5. **Commit changes**: `git commit -m 'Add amazing feature'`
6. **Push to branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Code Standards
- **API**: ESLint + Prettier
- **Flutter**: Dart analyzer + dart format
- **Commits**: Conventional commit messages
- **Tests**: Minimum 80% coverage

## 📄 License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check the `docs/` folder
- **Issues**: Create a GitHub issue
- **API Docs**: Visit `http://localhost:3000/api-docs`
- **Postman**: Import collection from `ops/postman/`

## 🔄 Updates

### Recent Changes
- Restructured project layout for better organization
- Added comprehensive CI/CD pipeline
- Enhanced development workflow with Makefile
- Improved documentation and troubleshooting guides

### Upcoming Features
- [ ] User authentication
- [ ] Review management
- [ ] Offline support
- [ ] Push notifications
- [ ] Advanced search filters
