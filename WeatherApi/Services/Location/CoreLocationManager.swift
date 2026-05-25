import CoreLocation
import Foundation

class CoreLocationManager: NSObject, LocationManaging, CLLocationManagerDelegate {
   
    private var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocationName(from coordinate: CLLocationCoordinate2D) async -> String? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geocoder = CLGeocoder()
                
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                    
                // Vrátí locality (Město) nebo name jako zálohu
                if let placemark = placemarks.first {
                    return placemark.locality ?? placemark.name
                }
            } catch {
                print("Chyba při geokódování: \(error.localizedDescription)")
            }
            return nil
    }
    
}
