import Cocoa

protocol Vehicle {
    var id: String { get }
    var isAvailable: Bool { get set }
    
    func startRide()
    func stopRide()
}

class Car : Vehicle {
    var id: String
    var isAvailable: Bool
    
    init(id: String, isAvailable: Bool) {
        self.id = id
        self.isAvailable = isAvailable
    }
    
    convenience init(id: String) {
        self.init(id: id, isAvailable: false)
    }
    
    func startRide() {
        isAvailable = false
    }
    
    func stopRide() {
        isAvailable = true
    }
}

class ElectricCar : Car {
    var batteryValue: Int
    var count: Int = 0
    
    override init(id: String, isAvailable: Bool) {
        self.batteryValue = 100
        super.init(id: id, isAvailable: isAvailable)
    }
    
    
    override func startRide() {
        self.isAvailable = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in if self.count == 30 {
                self.stopRide()
                timer.invalidate()
            }
            self.count+=1
        }
    }
    
    override func stopRide() {
        self.isAvailable = true
    }
}

class VanCar : Car {
    var maxWeight: Float
    var currentWeight: Float
    
    init?(id: String, maxWeight: Float, currentWeight: Float) {
        guard maxWeight <= 1000 else {
            print("Weight exceeded 1000 kg!")
            return nil
        }
        guard currentWeight <= maxWeight else {
            print("Current weight exceeded max weight!")
            return nil
        }
        self.maxWeight = maxWeight
        self.currentWeight = currentWeight
        super.init(id: id, isAvailable: true)
    }
    
    override func stopRide() {
        self.currentWeight = 0.0
        super.stopRide()
    }
}

class FleetManager<T:Car> {
    private var vehicles: [T] = []
    
    func addVehicle(_ vehicle: T) {
        self.vehicles.append(vehicle)
    }
    
    func startAllVehicles() {
        for vehicle in vehicles {
            vehicle.startRide()
        }
    }
    
    func stopAllVehicles() {
        for vehicle in vehicles {
            vehicle.stopRide()
        }
    }
    
    func getVehicleByType<Specific: Car>(ofType: Specific.Type) -> [Specific] {
        var specificVehicles: [Specific] = []
        
        for vehicle in vehicles {
            if let specificVehicle = vehicle as? Specific {
                specificVehicles.append(specificVehicle)
            }
        }
        return specificVehicles
    }
    
    func printInfo() {
        for vehicle in self.vehicles {
            print("Vehicle with id \(vehicle.id) is currently with status: \(vehicle.isAvailable) \(vehicle.carStatusIcon)")
        }
    }
}

extension Car {
    var carStatusIcon: String {
        return isAvailable ? "🚘" : "❌"
    }
}


