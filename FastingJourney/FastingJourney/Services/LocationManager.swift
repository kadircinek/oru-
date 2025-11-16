import Foundation
import CoreLocation
import Combine

/// Manages location-based features and geofencing
class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    @Published var isAuthorized = false
    @Published var currentLocation: CLLocation?
    @Published var isNearHome = false
    
    private let locationManager = CLLocationManager()
    private let persistenceManager = PersistenceManager.shared
    
    // Home location (user sets this)
    @Published var homeLocation: CLLocationCoordinate2D?
    private let homeRadiusMeters: CLLocationDistance = 500 // 500 meters
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100 // Update every 100 meters
        
        loadHomeLocation()
        checkAuthorization()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func checkAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            startMonitoring()
        case .notDetermined:
            isAuthorized = false
        case .denied, .restricted:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }
    
    // MARK: - Monitoring
    
    func startMonitoring() {
        guard isAuthorized else { return }
        locationManager.startUpdatingLocation()
        
        // Setup geofencing if home is set
        if let home = homeLocation {
            setupGeofencing(at: home)
        }
    }
    
    func stopMonitoring() {
        locationManager.stopUpdatingLocation()
        
        // Remove all geofences
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    // MARK: - Home Location
    
    func setHomeLocation(_ coordinate: CLLocationCoordinate2D) {
        homeLocation = coordinate
        saveHomeLocation(coordinate)
        
        if isAuthorized {
            setupGeofencing(at: coordinate)
        }
    }
    
    private func setupGeofencing(at coordinate: CLLocationCoordinate2D) {
        // Remove existing home geofence
        for region in locationManager.monitoredRegions {
            if region.identifier == "home" {
                locationManager.stopMonitoring(for: region)
            }
        }
        
        // Create new geofence
        let region = CLCircularRegion(
            center: coordinate,
            radius: homeRadiusMeters,
            identifier: "home"
        )
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
    }
    
    // MARK: - Distance Calculations
    
    func distanceToHome() -> CLLocationDistance? {
        guard let current = currentLocation,
              let home = homeLocation else {
            return nil
        }
        
        let homeLocation = CLLocation(latitude: home.latitude, longitude: home.longitude)
        return current.distance(from: homeLocation)
    }
    
    func isWithinHomeRadius() -> Bool {
        guard let distance = distanceToHome() else { return false }
        return distance <= homeRadiusMeters
    }
    
    // MARK: - Smart Notifications
    
    func checkAndNotifyHomeApproach() {
        guard isNearHome else { return }
        
        // Check if fasting is ending soon (within 1 hour)
        let sessionViewModel = FastingSessionViewModel()
        if sessionViewModel.isActive() && sessionViewModel.remainingTime <= 3600 && sessionViewModel.remainingTime > 0 {
            NotificationManager.shared.scheduleHomeApproachReminder(
                minutesRemaining: Int(sessionViewModel.remainingTime / 60)
            )
        }
    }
    
    // MARK: - Persistence
    
    private func saveHomeLocation(_ coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: "homeLatitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "homeLongitude")
    }
    
    private func loadHomeLocation() {
        let lat = UserDefaults.standard.double(forKey: "homeLatitude")
        let lon = UserDefaults.standard.double(forKey: "homeLongitude")
        
        if lat != 0 && lon != 0 {
            homeLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        // Check if near home
        if let _ = homeLocation {
            let wasNearHome = isNearHome
            isNearHome = isWithinHomeRadius()
            
            // Notify when approaching home (wasn't near, now is)
            if !wasNearHome && isNearHome {
                checkAndNotifyHomeApproach()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "home" {
            isNearHome = true
            checkAndNotifyHomeApproach()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == "home" {
            isNearHome = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
