# Mobile App Dev Guide

## Building

### Models
The app model is based on three main structures:

**GiftCard**
- Handles basic information (vendor, brand, image)
- Implements Identifiable and Codable protocols
- Custom decoder for position field (Int/String)
- Support for denominations and custom denominations
- HTML content handling (terms and importantContent)

**Denomination**
- Decimal price handling (Double)
- Product stock status tracking
- Multi-currency support

**CustomDenomination**
- Customizable price range handling
- Optional min and max values support

### Network Layer
Network implementation uses:
- Base URL: zip.co
- Gift cards endpoint: /giftcards/api/giftcards
- HTTP Method: GET
- Standard JSON headers

### Clean Architecture
The app is structured in layers:
- ViewModel for UI state management
- UseCase for business logic
- Repository for data abstraction
- DataSource for API calls
- Network Service for HTTP requests

### Third-party Libraries
The app uses the following libraries:
- SwiftInject for dependency injection

## Testing
The tests were conducted using XCTest
- Unit tests for models and business logic
- UI tests for view

## Additional Information

### Known Issues
1. Position field requires flexible handling (String/Int)
2. Prices need decimal support
3. CustomDenominations can be null
4. HTML parsing in terms and importantContent fields

### API Configuration
API details:
- Base URL: https://zip.co/giftcards/api
- Endpoint: GET /giftcards
- Response format: JSON

### Debug Tips
Debugging suggestions:
- Enable network request logging
- Verify JSON response format
- Monitor memory usage
- Check HTML parsing

### Best Practices
1. Use async/await for network calls
2. Implement comprehensive error handling
3. Use dependency injection
4. Follow Clean Architecture principles
5. Maintain separation of concerns
