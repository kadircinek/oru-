import SwiftUI
import MapKit

/// Smart features settings view for location, weather, and calendar integrations
struct SmartFeaturesView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var weatherManager = WeatherManager.shared
    @StateObject private var calendarManager = CalendarManager.shared
    
    @State private var showingMapPicker = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Smart Features")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Personalized suggestions based on your location, weather and calendar")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    // Location Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "location.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.primary)
                            Text("Location-Based Notifications")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Text("Get notified when approaching home if fast ending soon")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                        
                        if locationManager.isAuthorized {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppColors.success)
                                    Text("Location permission granted")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.success)
                                }
                                
                                if let home = locationManager.homeLocation {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Your Home Location:")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text("📍 \(String(format: "%.4f, %.4f", home.latitude, home.longitude))")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textSecondary)
                                        
                                        if locationManager.isNearHome {
                                            HStack {
                                                Image(systemName: "house.fill")
                                                    .foregroundColor(AppColors.primary)
                                                Text("You're currently at home")
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundColor(AppColors.primary)
                                            }
                                        }
                                        
                                        Button {
                                            showingMapPicker = true
                                        } label: {
                                            Text("Change Home Location")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(AppColors.primary)
                                        }
                                        .padding(.top, 4)
                                    }
                                    .padding(12)
                                    .background(AppColors.surfaceBackground)
                                    .cornerRadius(12)
                                } else {
                                    Button {
                                        showingMapPicker = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "house.fill")
                                            Text("Set Home Location")
                                        }
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(AppColors.primary)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        } else {
                            Button {
                                locationManager.requestAuthorization()
                            } label: {
                                HStack {
                                    Image(systemName: "location.circle")
                                    Text("Grant Location Permission")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppColors.primary)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    .padding(.horizontal, 20)
                    
                    // Weather Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "cloud.sun.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.orange)
                            Text("Weather Integration")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Text("Get personalized suggestions and alerts based on weather")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                        
                        if let weather = weatherManager.currentWeather {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("\(Int(weather.temperature))°C")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(weather.condition)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                        Text("Humidity: \(weather.humidity)%")
                                            .font(.system(size: 13))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                                
                                if let suggestion = weatherManager.weatherSuggestion {
                                    Text(suggestion)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColors.primary.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                        } else {
                            Button {
                                if let location = locationManager.currentLocation {
                                    weatherManager.fetchWeather(
                                        latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude
                                    )
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Refresh Weather")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppColors.orange)
                                .cornerRadius(12)
                            }
                            .disabled(!locationManager.isAuthorized)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    .padding(.horizontal, 20)
                    
                    // Calendar Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.blue)
                            Text("Calendar Integration")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Text("We recommend the most suitable fasting program based on your calendar")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                        
                        if calendarManager.isAuthorized {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppColors.success)
                                    Text("Calendar permission granted")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.success)
                                }
                                
                                if !calendarManager.upcomingEvents.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Upcoming Events: \(calendarManager.upcomingEvents.count)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        if let suggestion = calendarManager.fastingSuggestion {
                                            Text(suggestion)
                                                .font(.system(size: 14))
                                                .foregroundColor(AppColors.textPrimary)
                                                .padding(12)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(AppColors.blue.opacity(0.1))
                                                .cornerRadius(10)
                                        }
                                        
                                        if let recommended = calendarManager.getRecommendedPlan() {
                                            HStack {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(AppColors.primary)
                                                Text("Recommended: \(recommended.name)")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(AppColors.primary)
                                            }
                                            .padding(.top, 4)
                                        }
                                    }
                                    .padding(12)
                                    .background(AppColors.surfaceBackground)
                                    .cornerRadius(12)
                                }
                                
                                Button {
                                    calendarManager.fetchUpcomingEvents()
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Refresh Calendar")
                                    }
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppColors.blue)
                                }
                                .padding(.top, 4)
                            }
                        } else {
                            Button {
                                calendarManager.requestAuthorization()
                            } label: {
                                HStack {
                                    Image(systemName: "calendar.badge.plus")
                                    Text("Grant Calendar Permission")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppColors.blue)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingMapPicker) {
            MapLocationPicker(selectedCoordinate: $selectedCoordinate)
                .onDisappear {
                    if let coordinate = selectedCoordinate {
                        locationManager.setHomeLocation(coordinate)
                    }
                }
        }
        .onAppear {
            if locationManager.isAuthorized && locationManager.homeLocation == nil {
                // Set current location as home by default
                if let current = locationManager.currentLocation {
                    selectedCoordinate = current.coordinate
                }
            }
            
            // Fetch weather if location is available
            if let location = locationManager.currentLocation {
                weatherManager.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
        }
    }
}

// MARK: - Map Location Picker

struct MapLocationPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: selectedCoordinate != nil ? [MapPin(coordinate: selectedCoordinate!)] : []) { pin in
                    MapMarker(coordinate: pin.coordinate, tint: .red)
                }
                .ignoresSafeArea()
                
                // Center pin
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppColors.primary)
                    .shadow(radius: 4)
                
                VStack {
                    Spacer()
                    
                    Button {
                        selectedCoordinate = region.center
                        dismiss()
                    } label: {
                        Text("Select This Location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.primary)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Select Home Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationStack {
        SmartFeaturesView()
    }
}
