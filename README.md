# CoinRanking-iOS

CoinRanking iOS application

A modern iOS application built with UIKit and SwiftUI, featuring real-time cryptocurrency data, featuring price charts, filtering, and favorites management. This project leverage clean architecture with MVVM principles and adhering to SOLID design patterns for maintainability and scalability.

### Key Features
- Real-time cryptocurrency data fetching
- Filtering and sorting capabilities
- Favorite coin management
- Price chart visualization
- Error handling and offline state management

### Demo
### Fetch data with pagination
<img src="https://github.com/ashishkarna7/CoinRanking-iOS/blob/main/CoinRanking/CoinRanking/Resources/fetch.gif" alt="Fetch" width="300" />

### Filter
<img src="https://github.com/ashishkarna7/CoinRanking-iOS/blob/main/CoinRanking/CoinRanking/Resources/filter.gif" alt="Filter" width="300" />

### Favorite with state management
<img src="https://github.com/ashishkarna7/CoinRanking-iOS/blob/main/CoinRanking/CoinRanking/Resources/favorite.gif" alt="Favorite" width="300" />

### Price charts
<img src="https://github.com/ashishkarna7/CoinRanking-iOS/blob/main/CoinRanking/CoinRanking/Resources/chart.gif" alt="Chart" width="300" />


## Prerequisites
- Xcode 15.0 or later
- iOS 16.6 or later
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
- The app fetches cryptocurrency data using the CoinRanking API.
- Environment variables are managed through `.xcconfig` files:
  - `Dev.xconfig` for the development environment (`CoinRanking-Dev.xscheme`)
  - `Prod.xconfig` for the production environment (`CoinRanking.xscheme`)
- Select the appropriate scheme based on your environment before building the project.
- For testing, use the `CoinRankingTests.xscheme`.

## Documentation  
- To view the code documentation in Xcode, follow these steps:  
  - Open the project in **Xcode**.  
  - Navigate to **Product** > **Build Documentation** (or press `Shift + Command + Option + D`).  
  - After the build completes, open **Xcode's Documentation Browser** by going to **Window** > **Developer Documentation**.  


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

3. **UI/UX Decisions:**
   - Prioritized real-time data updates over battery optimization
   - Used system colors and styling for consistent iOS look & feel
   - Implemented pull-to-refresh for manual data updates

4. **Testing Approach:**
   - Focused on business logic and data layer testing
   - Used mock data that represents real-world scenarios
   - Implemented protocol-based mocking for better test isolation

5. Architecture Choices  
   - Adopted **MVVM + Combine**, with **UIKit** as the primary framework and **limited use of SwiftUI** (especially for the chart view).  
   - Leveraged **protocols** extensively to facilitate future modifications.  
   - Ensured **separation of concerns** for independent module testing.  

6. Limitations  
   - Offline mode is not implemented.
