# PetGo 🐾

A SwiftUI iOS application that helps pet owners discover pet-friendly places around the world using interactive maps and location-based services.

## Overview

PetGo is designed to make it easier for pet owners to find suitable places for their furry companions. The app features a comprehensive map interface with global coverage, allowing users to discover parks, cafes, veterinary clinics, and pet stores that welcome pets.

## Features

### 🗺️ Interactive Map
- **Global Coverage**: Explore pet-friendly places across major cities worldwide
- **Category Filtering**: Filter locations by type (Parks, Cafes, Veterinary, Pet Stores)
- **Real-time Search**: Search for specific places or areas
- **Custom Pins**: Visual markers for different categories of pet-friendly locations

### ⭐ Favorites System
- **Save Places**: Mark locations as favorites for quick access
- **Persistent Storage**: Favorites are saved using Core Data
- **Easy Management**: View, search, and remove favorites
- **Detailed Information**: Access complete place details from favorites

### 📍 Place Details
- **Comprehensive Information**: View ratings, reviews, contact details, and hours
- **Amenities**: See available pet-friendly amenities
- **Distance & Directions**: Get location and distance information
- **Contact Integration**: Direct access to phone numbers and addresses

### ⚙️ Customizable Settings
- **Category Preferences**: Enable/disable specific place categories
- **Dark Mode Support**: Toggle between light and dark themes
- **Personalized Experience**: Customize the app to your preferences

## Screenshots

*Screenshots would be displayed here showing the main map view, place details, favorites list, and settings screen.*

## Requirements

- **iOS**: 15.0 or later
- **Xcode**: 13.0 or later
- **Swift**: 5.5 or later
- **Device**: iPhone or iPad

## Installation

### From Source
1. Clone or download this repository
2. Open `PetGo.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project (⌘+R)

### Dependencies
This project uses only native iOS frameworks:
- SwiftUI for the user interface
- MapKit for map functionality
- Core Data for local data persistence

## Usage

1. **Launch the App**: Open PetGo to see the main map view
2. **Explore Locations**: Browse the map to discover pet-friendly places
3. **Filter by Category**: Use the category buttons to filter specific types of places
4. **Search**: Use the search bar to find specific locations
5. **View Details**: Tap on any pin to see detailed information
6. **Save Favorites**: Tap the heart icon to save places to your favorites
7. **Manage Favorites**: Access your saved places from the favorites tab
8. **Customize Settings**: Adjust preferences in the settings tab

## App Structure

```
PetGo/
├── PetGoApp.swift          # App entry point
├── ContentView.swift       # Main UI components and views
├── Persistence.swift       # Core Data stack and model
└── Assets.xcassets/        # App icons and images
```

## Developer Information

- **Developer**: N.D.C.Minsandi
- **Development Date**: November 15, 2025
- **Platform**: iOS (SwiftUI)
- **Architecture**: MVVM with SwiftUI

## Contributing

This project is part of a mobile app development portfolio. If you'd like to contribute or have suggestions:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is developed as part of an educational/portfolio project. Please contact the developer for usage rights and licensing information.

## Support

For questions, issues, or feature requests, please contact the developer or create an issue in the project repository.

---

**PetGo** - Making the world more pet-friendly, one location at a time! 🐕🐱
