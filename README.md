# CoinRanking-iOS

CoinRanking iOS application

## Prerequisites
- Xcode 14.0 or later
- iOS 16.0 or later
- Swift Package Manager (SPM) for dependency management

## Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ashishkarna7/CoinRanking-iOS.git
   ```

2. **Open the project:**
   - Navigate to the project directory
   - Double-click on `CoinRanking.xcodeproj` to open in Xcode

3. **Dependencies:**
   The project uses Swift Package Manager (SPM) for dependency management. Dependencies will be resolved automatically when the project is opened in Xcode. The main dependencies include:
   - **SDWebImage**: For efficient image loading and caching
   - **Charts**: For cryptocurrency price chart visualization

4. **Build and Run:**
   - Select your target device/simulator in Xcode
   - Press `Cmd + R` or click the Play button to build and run the application

## Configuration
- The app uses the CoinRanking API for fetching cryptocurrency data.
- Environment variables are managed through `.xcconfig` files:
  - `Dev.xconfig` for the development environment
  - `Prod.xconfig` for the production environment
- Select the appropriate scheme based on your environment before building.

## Troubleshooting
If you encounter build issues:
- Clean the build folder (`Cmd + Shift + K`)
- Clean the build cache (`Cmd + Option + Shift + K`)
- Reset Package Caches (`File > Packages > Reset Package Caches`)
- Verify the correct scheme selection

## Technical Details

### Architecture & Implementation
- MVVM architecture with Combine for reactive programming
- Repository pattern for data access
- Protocol-oriented design for better testability
- Comprehensive unit test coverage
- UI optimized for both iPhone and iPad

### Key Features
- Real-time cryptocurrency data fetching
- Filtering and sorting capabilities
- Favorite coin management
- Price chart visualization
- Error handling and offline state management

### Technical Challenges & Solutions

1. **Data Management:**
   - Implemented an efficient caching system for coin data
   - Used dictionaries for type-safe data storage
   - Separate stores for list and detail data

2. **State Management:**
   - Combine publishers for reactive state updates
   - Dedicated tracking for fetch and pagination states
   - Centralized favorite management system

3. **Performance:**
   - Pagination with configurable page size
   - Efficient memory management
   - Image caching with SDWebImage

4. **Error Handling:**
   - Comprehensive error mapping
   - User-friendly error messages
   - Graceful degradation on network failures

## Requirements
- Active internet connection required
- iOS 16.0+ device or simulator
- Xcode 14.0+ for development

## Assumptions & Design Decisions

1. **Data Layer:**
   - Used in-memory caching over persistence for simplicity
   - Assumed data freshness is critical, so the cache invalidates on app restart
   - Implemented the repository pattern anticipating future persistence needs

2. **Network Layer:**
   - Assumed unstable network conditions, implemented robust error handling
   - Used URLSession for networking as third-party libraries weren't required
   - Implemented retry logic for transient failures

3. **UI/UX Decisions:**
   - Prioritized real-time data updates over battery optimization
   - Used system colors and styling for consistent iOS look & feel
   - Implemented pull-to-refresh for manual data updates

4. **Testing Approach:**
   - Focused on business logic and data layer testing
   - Used mock data that represents real-world scenarios
   - Implemented protocol-based mocking for better test isolation

5. **Architecture Choices:**
   - Chose MVVM + Combine over UIKit and SwiftUI (especially for the chart view)
   - Used protocols extensively to enable future modifications
   - Separated concerns to allow independent module testing

6. **Limitations:**
   - No offline mode implementation
   - Basic error retry mechanism
   - Limited historical data caching