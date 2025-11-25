# PetGo - Technical Documentation 🛠️

## Architecture Overview

PetGo is built using SwiftUI with a clean, modular architecture that separates concerns and maintains code readability. The app follows MVVM (Model-View-ViewModel) patterns where appropriate and leverages SwiftUI's declarative nature.

## Project Structure

```
PetGo/
├── PetGo/
│   ├── PetGoApp.swift          # App entry point and configuration
│   ├── ContentView.swift       # Main UI components and business logic
│   ├── Persistence.swift       # Core Data stack and model definitions
│   ├── Assets.xcassets/        # App resources (icons, images, colors)
│   └── Preview Content/        # SwiftUI preview assets
├── PetGoTests/                 # Unit tests
├── PetGoUITests/              # UI tests
└── PetGo.xcodeproj/           # Xcode project configuration
```

## Core Components

### 1. App Entry Point (`PetGoApp.swift`)
- **Purpose**: SwiftUI application entry point
- **Responsibilities**: 
  - App lifecycle management
  - Initial view setup
  - Window group configuration

### 2. Main Interface (`ContentView.swift`)
The main file containing all UI components and business logic:

#### Models
- **`Place`**: Core data model representing a pet-friendly location
  - Properties: id, title, category, rating, coordinates, address, etc.
  - Identifiable for SwiftUI list rendering

- **`PlacePin`**: MapKit annotation wrapper for Place objects
  - Conforms to `Identifiable` and `ObservableObject`
  - Handles map pin representation

- **`Amenity`**: Represents available services at locations
  - Simple struct with name and icon properties

#### Views
- **`MapHomeView`**: Primary map interface
  - MapKit integration with custom annotations
  - Category filtering system
  - Search functionality
  - Global sample data generation

- **`PlaceDetailsView`**: Detailed place information
  - Rating display with star system
  - Amenities listing
  - Favorite toggle with Core Data integration
  - Contact information display

- **`FavoritesView`**: Saved places management
  - Core Data fetch requests
  - Search and filter capabilities
  - Swipe-to-delete functionality
  - Navigation to place details

- **`SettingsView`**: App configuration
  - Category filter toggles
  - Dark mode preference
  - Settings persistence

#### State Management
- **`SettingsStore`**: ObservableObject for app-wide settings
  - Category visibility toggles
  - Dark mode preference
  - UserDefaults integration for persistence

### 3. Data Persistence (`Persistence.swift`)
- **`PersistenceController`**: Singleton Core Data stack
- **Programmatic Model Creation**: NSManagedObjectModel built in code
- **Entity Definition**: FavoritePlace with comprehensive attributes
- **Merge Policy**: Configured for conflict resolution

## Technical Implementation Details

### MapKit Integration
```swift
Map(coordinateRegion: $region, annotationItems: filteredPins) { pin in
    MapAnnotation(coordinate: pin.place.coordinate) {
        // Custom pin UI
    }
}
```

### Core Data Operations
- **Favorites Management**: CRUD operations for saved places
- **Fetch Requests**: Dynamic filtering and searching
- **Context Management**: Proper save/rollback handling

### Sample Data Generation
The app includes comprehensive sample data covering:
- **Global Coverage**: Major cities across continents
- **Multiple Categories**: Parks, cafes, veterinary clinics, pet stores
- **Realistic Data**: Ratings, reviews, addresses, amenities

### State Synchronization
- SwiftUI's `@State`, `@StateObject`, and `@ObservedObject` for reactive UI
- Proper data flow between views
- Settings persistence across app launches

## Development Guidelines

### Code Style
- **SwiftUI Best Practices**: Declarative UI patterns
- **Separation of Concerns**: Models, views, and business logic clearly separated
- **Naming Conventions**: Clear, descriptive variable and function names
- **Documentation**: Comprehensive header comments for all files

### Performance Considerations
- **Lazy Loading**: Efficient map pin rendering
- **Memory Management**: Proper object lifecycle handling
- **Core Data Optimization**: Efficient fetch requests and batch operations

### Testing Strategy
- **Unit Tests**: Model and business logic validation
- **UI Tests**: User interaction flow verification
- **Preview Support**: SwiftUI preview configurations for development

## Build Configuration

### Minimum Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

### Dependencies
- **Native Frameworks Only**:
  - SwiftUI (UI framework)
  - MapKit (mapping functionality)
  - CoreData (local persistence)
  - Foundation (core utilities)

### Build Settings
- Standard iOS app configuration
- No external dependencies or package managers required
- Compatible with both device and simulator builds

## Data Model Schema

### FavoritePlace Entity
```
FavoritePlace {
    id: UUID (Primary Key)
    title: String
    category: String
    address: String?
    rating: Double
    reviewsCount: Int32
    latitude: Double
    longitude: Double
    phone: String?
    hoursText: String?
    distanceText: String?
}
```

## Future Enhancement Opportunities

### Technical Improvements
- **Networking Layer**: Real API integration for live data
- **Location Services**: User location and proximity features
- **Push Notifications**: Nearby place alerts
- **Offline Support**: Enhanced Core Data caching
- **Performance**: Lazy loading and pagination for large datasets

### Feature Additions
- **User Reviews**: Community-driven content
- **Photo Upload**: User-generated place images
- **Social Features**: Sharing and recommendations
- **Advanced Filtering**: Price range, distance, ratings
- **Route Planning**: Integration with Maps app for directions

## Debugging and Troubleshooting

### Common Issues
- **Core Data**: Check merge policies and context management
- **MapKit**: Verify coordinate validity and region settings
- **SwiftUI**: Ensure proper state management and view updates

### Development Tools
- Xcode Instruments for performance profiling
- Core Data debugging with SQLite inspection
- SwiftUI preview debugging for UI issues

---

**Developer**: N.D.C.Minsandi  
**Last Updated**: November 15, 2025  
**Version**: 1.0
