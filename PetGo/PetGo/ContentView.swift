//
// File: ContentView.swift
// App: PetGo
// Purpose: Defines the primary SwiftUI views and app UI flow for the PetGo app.
// Description: Contains models and views for the app, including:
// - MapHomeView with MapKit global pins, category filters, and search field
// - PlaceDetailsView with category images and favorite toggle (Core Data-backed)
// - FavoritesView listing saved places with search and delete, navigates to details
// - SettingsStore and SettingsView for category filters and dark mode
// - Sample data generation for global pins and supporting types (Place, PlacePin, Amenity)
// Developer: N.D.C.Minsandi
// Date: 15/11/2025
//

import SwiftUI
import MapKit
import CoreData
 
// MARK: - Models & Store (moved up for visibility)

// Model describing a place shown in map, details, and favorites
struct Place: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let rating: Double
    let reviewsCount: Int
    let coordinate: CLLocationCoordinate2D
    let address: String
    let distanceText: String
    let hoursText: String
    let phone: String
    let amenities: [Amenity]
    let imageURL: URL?
}

private extension MapHomeView {
    // Generates global sample pins for each category used to populate the map
    func makeSamplePins() -> [PlacePin] {
        // Global sample coordinates across major cities/regions.
        let parks: [(String, CLLocationCoordinate2D)] = [
            ("Central Park", .init(latitude: 40.7829, longitude: -73.9654)),
            ("Hyde Park", .init(latitude: 51.5073, longitude: -0.1657)),
            ("Ueno Park", .init(latitude: 35.7156, longitude: 139.7745)),
            ("Tiergarten", .init(latitude: 52.5145, longitude: 13.3501)),
            ("Stanley Park", .init(latitude: 49.3043, longitude: -123.1443)),
            ("Ibirapuera Park", .init(latitude: -23.5874, longitude: -46.6576))
        ]
        let cafes: [(String, CLLocationCoordinate2D)] = [
            ("Paris Café", .init(latitude: 48.8566, longitude: 2.3522)),
            ("Melbourne Brew", .init(latitude: -37.8136, longitude: 144.9631)),
            ("Seattle Roasters", .init(latitude: 47.6062, longitude: -122.3321)),
            ("Seoul Beans", .init(latitude: 37.5665, longitude: 126.9780)),
            ("Rome Espresso", .init(latitude: 41.9028, longitude: 12.4964)),
            ("Cape Town Coffee", .init(latitude: -33.9249, longitude: 18.4241))
        ]
        let hotels: [(String, CLLocationCoordinate2D)] = [
            ("Dubai Marina Hotel", .init(latitude: 25.0800, longitude: 55.1400)),
            ("Singapore Bay Hotel", .init(latitude: 1.2869, longitude: 103.8546)),
            ("NYC Skyline Hotel", .init(latitude: 40.7580, longitude: -73.9855)),
            ("Tokyo Central Hotel", .init(latitude: 35.6812, longitude: 139.7671)),
            ("London River Hotel", .init(latitude: 51.5074, longitude: -0.1278)),
            ("Madrid Centro Hotel", .init(latitude: 40.4168, longitude: -3.7038))
        ]
        let beaches: [(String, CLLocationCoordinate2D)] = [
            ("Copacabana", .init(latitude: -22.9711, longitude: -43.1822)),
            ("Bondi Beach", .init(latitude: -33.8908, longitude: 151.2743)),
            ("Waikiki", .init(latitude: 21.2767, longitude: -157.8275)),
            ("Bali Kuta", .init(latitude: -8.7177, longitude: 115.1687)),
            ("Nice Promenade", .init(latitude: 43.6950, longitude: 7.2656)),
            ("Phuket Patong", .init(latitude: 7.8966, longitude: 98.2960))
        ]
        let vets: [(String, CLLocationCoordinate2D)] = [
            ("Tokyo Vet Clinic", .init(latitude: 35.6895, longitude: 139.6917)),
            ("Paris Animal Care", .init(latitude: 48.8566, longitude: 2.3522)),
            ("NYC Pet Health", .init(latitude: 40.7128, longitude: -74.0060)),
            ("Sydney Vet Center", .init(latitude: -33.8688, longitude: 151.2093)),
            ("Johannesburg Vet", .init(latitude: -26.2041, longitude: 28.0473)),
            ("Toronto Vet", .init(latitude: 43.6532, longitude: -79.3832))
        ]

        var out: [PlacePin] = []
        out += parks.map { PlacePin(title: $0.0, coordinate: $0.1, symbol: "tree.fill", category: .park) }
        out += cafes.map { PlacePin(title: $0.0, coordinate: $0.1, symbol: "cup.and.saucer.fill", category: .cafe) }
        out += hotels.map { PlacePin(title: $0.0, coordinate: $0.1, symbol: "bed.double.fill", category: .hotel) }
        out += beaches.map { PlacePin(title: $0.0, coordinate: $0.1, symbol: "figure.surfing", category: .beach) }
        out += vets.map { PlacePin(title: $0.0, coordinate: $0.1, symbol: "cross.case.fill", category: .vet) }
        return out
    }
}

// MARK: - Settings

// Observable settings used for filters and appearance
final class SettingsStore: ObservableObject {
    @Published var filterParks: Bool = true
    @Published var filterCafes: Bool = true
    @Published var filterHotels: Bool = false
    @Published var filterBeaches: Bool = false
    @Published var filterVets: Bool = true
    @Published var darkMode: Bool = false
}

// Settings screen with filter toggles and dark mode option
struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Settings")
                        .font(.largeTitle.bold())
                        .padding(.top, 8)

                    Text("Filter Categories")
                        .font(.headline)
                    Text("Show these places in your search.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 1) {
                        ToggleRow(title: "Parks", systemImage: "tree.fill", isOn: $settings.filterParks)
                        ToggleRow(title: "Cafes", systemImage: "cup.and.saucer.fill", isOn: $settings.filterCafes)
                        ToggleRow(title: "Hotels", systemImage: "bed.double.fill", isOn: $settings.filterHotels)
                        ToggleRow(title: "Beaches", systemImage: "figure.surfing", isOn: $settings.filterBeaches)
                        ToggleRow(title: "Vet Clinics", systemImage: "cross.case.fill", isOn: $settings.filterVets)
                    }

                    Text("Appearance")
                        .font(.headline)
                        .padding(.top, 8)
                    ToggleRow(title: "Dark Mode", systemImage: "moon.fill", isOn: $settings.darkMode)

                    Text("More Info")
                        .font(.headline)
                        .padding(.top, 8)
                    VStack(spacing: 1) {
                        NavRow(title: "About This App", systemImage: "info.circle")
                        NavRow(title: "Privacy Policy", systemImage: "hand.raised")
                        NavRow(title: "Terms of Service", systemImage: "doc.plaintext")
                        NavRow(title: "Rate Us on the App Store", systemImage: "star")
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color(.secondarySystemBackground).opacity(0.4).ignoresSafeArea())
        }
    }
}

private struct ToggleRow: View {
    let title: String
    let systemImage: String
    @Binding var isOn: Bool
    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .labelStyle(.titleAndIcon)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
    }
}

private struct NavRow: View {
    let title: String
    let systemImage: String
    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
    }
}

enum Amenity: String, CaseIterable, Identifiable {
    // Amenity features a place can provide, used for icons and labels in details
    case waterBowls, outdoorSeating, leashFree, petMenu
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .waterBowls: return "drop.fill"
        case .outdoorSeating: return "sun.max.fill"
        case .leashFree: return "figure.walk"
        case .petMenu: return "fork.knife"
        }
    }
    var label: String {
        switch self {
        case .waterBowls: return "Water Bowls"
        case .outdoorSeating: return "Outdoor Seating"
        case .leashFree: return "Leash-Free Zone"
        case .petMenu: return "Pet Menu"
        }
    }
}

// Core Data-backed favorites manager used across the app
final class FavoritesStore: ObservableObject {
    @Published private(set) var items: [Place] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        load()
    }

    // Loads favorites from Core Data into memory
    func load() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoritePlace")
        do {
            let objects = try context.fetch(request)
            self.items = objects.compactMap { Self.place(from: $0) }
        } catch {
            print("Core Data fetch error:", error)
            self.items = []
        }
    }

    // Checks if a place is already favorited
    func contains(_ place: Place) -> Bool {
        items.contains { $0.title == place.title && $0.address == place.address }
    }

    // Adds a place to Core Data favorites
    func add(_ place: Place) {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoritePlace", in: context) else { return }
        let obj = NSManagedObject(entity: entity, insertInto: context)
        obj.setValue(UUID(), forKey: "id")
        obj.setValue(place.title, forKey: "title")
        obj.setValue(place.category, forKey: "category")
        obj.setValue(place.address, forKey: "address")
        obj.setValue(place.rating, forKey: "rating")
        obj.setValue(Int32(place.reviewsCount), forKey: "reviewsCount")
        obj.setValue(place.coordinate.latitude, forKey: "latitude")
        obj.setValue(place.coordinate.longitude, forKey: "longitude")
        obj.setValue(place.phone, forKey: "phone")
        obj.setValue(place.hoursText, forKey: "hoursText")
        obj.setValue(place.distanceText, forKey: "distanceText")
        save()
        load()
    }

    // Removes a place from Core Data favorites
    func remove(_ place: Place) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoritePlace")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "title == %@", place.title),
            NSPredicate(format: "address == %@", place.address)
        ])
        do {
            let matches = try context.fetch(request)
            for obj in matches { context.delete(obj) }
            save()
            load()
        } catch {
            print("Core Data delete error:", error)
        }
    }

    // Toggles favorite state for a place
    func toggle(_ place: Place) {
        contains(place) ? remove(place) : add(place)
    }

    // Persists any Core Data changes
    private func save() {
        guard context.hasChanges else { return }
        do { try context.save() } catch { print("Core Data save error:", error) }
    }

    // Maps a Core Data object into the in-memory Place model
    private static func place(from obj: NSManagedObject) -> Place? {
        guard
            let title = obj.value(forKey: "title") as? String,
            let category = obj.value(forKey: "category") as? String
        else { return nil }
        let address = (obj.value(forKey: "address") as? String) ?? ""
        let rating = obj.value(forKey: "rating") as? Double ?? 0
        let reviews = Int((obj.value(forKey: "reviewsCount") as? Int32) ?? 0)
        let lat = obj.value(forKey: "latitude") as? Double ?? 0
        let lon = obj.value(forKey: "longitude") as? Double ?? 0
        let phone = (obj.value(forKey: "phone") as? String) ?? ""
        let hours = (obj.value(forKey: "hoursText") as? String) ?? ""
        let distance = (obj.value(forKey: "distanceText") as? String) ?? ""
        return Place(title: title, category: category, rating: rating, reviewsCount: reviews, coordinate: .init(latitude: lat, longitude: lon), address: address, distanceText: distance, hoursText: hours, phone: phone, amenities: [], imageURL: nil)
    }
}

// Root view managing splash display and injecting shared environment objects
struct ContentView: View {
    @State private var showSplash = true
    @StateObject private var favorites = FavoritesStore()
    @StateObject private var settings = SettingsStore()
    var body: some View {
        ZStack {
            MainTabView()
                .environmentObject(favorites)
                .environmentObject(settings)
                .opacity(showSplash ? 0 : 1)
                .preferredColorScheme(settings.darkMode ? .dark : .light)
            if showSplash {
                SplashView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut) { showSplash = false }
            }
        }
    }
}


// Detailed info screen for a selected place with actions
struct PlaceDetailsView: View {
    let place: Place
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favorites: FavoritesStore
    private var headerImageName: String? {
        let cat = place.category.lowercased()
        if cat == PlaceCategory.beach.rawValue.lowercased() { return "Beach" }
        if cat == PlaceCategory.park.rawValue.lowercased() { return "Park" }
        if cat == PlaceCategory.cafe.rawValue.lowercased() { return "Cafe" }
        if cat == PlaceCategory.hotel.rawValue.lowercased() { return "Hotel" }
        if cat == PlaceCategory.vet.rawValue.lowercased() { return "vet" }
        return nil
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 220)
                        .overlay(
                            Group {
                                if let name = headerImageName {
                                    Image(name)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 18))
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.secondary)
                                        .padding(40)
                                }
                            }
                        )
                    HStack(spacing: 12) {
                        Button(action: { dismiss() }) { Image(systemName: "chevron.left") }
                        Button(action: share) { Image(systemName: "square.and.arrow.up") }
                    }
                    .padding(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(place.category.uppercased().isEmpty ? "CAFÉ" : place.category.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(place.title)
                        .font(.title2.bold())
                    HStack(spacing: 6) {
                        ForEach(0..<5, id: \.self) { i in
                            Image(systemName: i < Int(place.rating.rounded()) ? "star.fill" : "star")
                                .foregroundStyle(Color.yellow)
                        }
                        Text(String(format: "%.1f", place.rating))
                            .foregroundStyle(.secondary)
                        Text("(\(place.reviewsCount) reviews)")
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            favorites.toggle(place)
                        }
                    }) {
                        Image(systemName: favorites.contains(place) ? "heart.fill" : "heart")
                            .foregroundStyle(favorites.contains(place) ? Color.blue : .primary)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Button(action: openDirections) {
                        HStack {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            Text("Get Directions")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }

                Text("About this place")
                    .font(.headline)
                Text("A cozy spot for you and your furry friend to relax. Enjoy artisanal coffee and delicious pastries while your pet makes new friends in our safe, enclosed play area.")
                    .foregroundStyle(.secondary)

                Text("Amenities")
                    .font(.headline)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(place.amenities) { amenity in
                        HStack(spacing: 10) {
                            Image(systemName: amenity.icon)
                                .foregroundStyle(Color.green)
                                .frame(width: 28, height: 28)
                            Text(amenity.label)
                        }
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                        VStack(alignment: .leading) {
                            Text(place.address)
                            Text(place.distanceText).foregroundStyle(.secondary)
                        }
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                        Text(place.hoursText)
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "phone")
                        Text(place.phone)
                    }
                }
                .font(.subheadline)
            }
            .padding(16)
        }
        .background(Color(.systemYellow).opacity(0.15))
    }

    // Opens Apple Maps with driving directions to the place
    private func openDirections() {
        let placemark = MKPlacemark(coordinate: place.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = place.title
        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    // Placeholder for share sheet integration
    private func share() { }
}


@available(iOS 17.0, *)
// iOS 17+ Map view using the new MapCameraPosition API
struct NewMapView: View {
    @Binding var region: MKCoordinateRegion
    let pins: [PlacePin]
    var onSelect: (PlacePin) -> Void = { _ in }
    @State private var camera: MapCameraPosition = .automatic
    private var regionKey: RegionKey {
        RegionKey(lat: region.center.latitude,
                  lon: region.center.longitude,
                  dlat: region.span.latitudeDelta,
                  dlon: region.span.longitudeDelta)
    }
    private struct RegionKey: Equatable { let lat, lon, dlat, dlon: Double }
    var body: some View {
        Map(position: $camera) {
            ForEach(pins) { pin in
                Annotation(pin.title, coordinate: pin.coordinate) {
                    Button(action: { onSelect(pin) }) {
                        ZStack {
                            Circle().fill(Color.yellow).frame(width: 36, height: 36)
                            Image(systemName: pin.symbol)
                                .foregroundStyle(.white)
                        }
                        .shadow(radius: 2)
                    }
                }
            }
        }
        .onAppear { camera = .region(region) }
        .onChange(of: regionKey) { _, _ in
            camera = .region(region)
        }
    }
}

// MARK: - Map Home

// Map tab showing global pins and filter-driven visibility
struct MapHomeView: View {
    @EnvironmentObject private var settings: SettingsStore
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 130.0, longitudeDelta: 130.0)
    )
    @State private var query: String = ""
    @State private var pins: [PlacePin] = []
    private var allowedCategories: Set<PlaceCategory> {
        var set = Set<PlaceCategory>()
        if settings.filterParks { set.insert(.park) }
        if settings.filterCafes { set.insert(.cafe) }
        if settings.filterHotels { set.insert(.hotel) }
        if settings.filterBeaches { set.insert(.beach) }
        if settings.filterVets { set.insert(.vet) }
        return set
    }
    private var filteredPins: [PlacePin] {
        pins.filter { allowedCategories.contains($0.category) }
    }
    @State private var selectedPlace: Place? = nil
    var body: some View {
        ZStack(alignment: .top) {
            if #available(iOS 17.0, *) {
                NewMapView(region: $region, pins: filteredPins, onSelect: { pin in
                    selectedPlace = Place(
                        title: pin.title,
                        category: pin.category.rawValue,
                        rating: 4.5,
                        reviewsCount: 128,
                        coordinate: pin.coordinate,
                        address: "123 Puppy Lane, Petville",
                        distanceText: "Approx. 1.2 miles away",
                        hoursText: "Open 8:00 AM – 6:00 PM",
                        phone: "(555) 123-4567",
                        amenities: [.waterBowls, .outdoorSeating, .leashFree, .petMenu],
                        imageURL: nil
                    )
                })
                    .ignoresSafeArea()
            } else {
                Map(coordinateRegion: $region, annotationItems: filteredPins) { pin in
                    MapAnnotation(coordinate: pin.coordinate) {
                        Button(action: {
                            selectedPlace = Place(
                                title: pin.title,
                                category: pin.category.rawValue,
                                rating: 4.5,
                                reviewsCount: 128,
                                coordinate: pin.coordinate,
                                address: "123 Puppy Lane, Petville",
                                distanceText: "Approx. 1.2 miles away",
                                hoursText: "Open 8:00 AM – 6:00 PM",
                                phone: "(555) 123-4567",
                                amenities: [.waterBowls, .outdoorSeating, .leashFree, .petMenu],
                                imageURL: nil
                            )
                        }) {
                            ZStack {
                                Circle().fill(Color.yellow).frame(width: 36, height: 36)
                                Image(systemName: pin.symbol)
                                    .foregroundStyle(.white)
                            }
                            .shadow(radius: 2)
                        }
                    }
                }
                .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                SearchBar(text: $query) {
                    // Placeholder: trigger a search later
                }
                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZoomControls(zoomIn: {
                        region.span.latitudeDelta *= 0.7
                        region.span.longitudeDelta *= 0.7
                    }, zoomOut: {
                        region.span.latitudeDelta /= 0.7
                        region.span.longitudeDelta /= 0.7
                    })
                }
                .padding(.trailing, 12)
                .padding(.bottom, 120)
            }

            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)
                    .frame(height: 72)
                    .overlay(
                        HStack(spacing: 60) {
                            VStack { Image(systemName: "map"); Text("Map") }
                            VStack { Image(systemName: "heart"); Text("Favorites") }
                            VStack { Image(systemName: "gearshape"); Text("Settings") }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 18)
                    .opacity(0) // visual placeholder for screenshot spacing
            }
        }
        .sheet(item: $selectedPlace) { place in
            PlaceDetailsView(place: place)
        }
        .onAppear {
            if pins.isEmpty { pins = makeSamplePins() }
        }
    }
}

// Lightweight pin model for map annotations
struct PlacePin: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let symbol: String
    let category: PlaceCategory
}

// Supported place categories displayed in the app
enum PlaceCategory: String, CaseIterable, Identifiable, Hashable {
    case park = "Park"
    case cafe = "Cafe"
    case hotel = "Hotel"
    case beach = "Beach"
    case vet = "Vet Clinic"
    var id: String { rawValue }
}

// Reusable search bar component used on the map
struct SearchBar: View {
    @Binding var text: String
    var onSubmit: () -> Void
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search for parks, cafes, hotels...", text: $text)
                .submitLabel(.search)
                .onSubmit(onSubmit)
            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

// Small overlay with + / - controls to adjust map zoom
struct ZoomControls: View {
    var zoomIn: () -> Void
    var zoomOut: () -> Void
    var body: some View {
        VStack(spacing: 8) {
            Button(action: zoomIn) {
                Image(systemName: "+")
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Button(action: zoomOut) {
                Image(systemName: "-")
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .shadow(radius: 2)
    }
}

// MARK: - Favorites UI

// Favorites tab listing saved places with search and navigation to details
struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore
    @State private var search: String = ""
    private var filtered: [Place] {
        if search.trimmingCharacters(in: .whitespaces).isEmpty { return favorites.items }
        return favorites.items.filter { $0.title.localizedCaseInsensitiveContains(search) || $0.address.localizedCaseInsensitiveContains(search) || $0.category.localizedCaseInsensitiveContains(search) }
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Saved Places").font(.largeTitle.bold()).padding(.top, 8)
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search saved places...", text: $search)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )

                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(filtered) { place in
                            NavigationLink {
                                PlaceDetailsView(place: place)
                            } label: {
                                FavoriteRow(place: place) {
                                    favorites.remove(place)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .padding(.horizontal, 16)
            .background(Color(.systemYellow).opacity(0.15).ignoresSafeArea())
        }
    }
}

// Visual row used for each favorite place
struct FavoriteRow: View {
    let place: Place
    var onDelete: () -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 54, height: 54)
                .overlay(
                    Group {
                        if let name = imageName {
                            Image(name)
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Image(systemName: "photo").foregroundStyle(.secondary)
                        }
                    }
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(place.title).font(.headline)
                Text("\(place.category) – \(place.address)").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash").foregroundStyle(.red)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    private var imageName: String? {
        let cat = place.category.lowercased()
        if cat == PlaceCategory.beach.rawValue.lowercased() { return "Beach" }
        if cat == PlaceCategory.park.rawValue.lowercased() { return "Park" }
        if cat == PlaceCategory.cafe.rawValue.lowercased() { return "Cafe" }
        if cat == PlaceCategory.hotel.rawValue.lowercased() { return "Hotel" }
        if cat == PlaceCategory.vet.rawValue.lowercased() { return "vet" }
        return nil
    }
}

#Preview {
    ContentView()
}

// Bottom tab bar coordinating Map, Favorites, and Settings
struct MainTabView: View {
    var body: some View {
        TabView {
            MapHomeView()
                .tabItem { Label("Map", systemImage: "map") }
            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "heart.fill") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

// Splash screen with simple image and dots loading animation
struct SplashView: View {
    @State private var scale: CGFloat = 0.95
    @State private var opacity: Double = 0.0
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 16) {
                Image("SplashView")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .frame(maxWidth: 360)
                    .accessibilityHidden(true)
                DotsLoadingView()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) { scale = 1.0 }
            withAnimation(.easeIn(duration: 0.4)) { opacity = 1.0 }
        }
    }
}

// Animated sequence of dots used on the splash screen
struct DotsLoadingView: View {
    @State private var phase: Int = 0
    private let dotCount = 5
    @State private var timer: Timer? = nil
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<dotCount, id: \.self) { i in
                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 6, height: 6)
                    .opacity(phase == i ? 1 : 0.3)
            }
        }
        .onAppear {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                phase = (phase + 1) % dotCount
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}
