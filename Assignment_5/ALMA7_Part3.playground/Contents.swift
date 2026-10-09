import Cocoa

// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · The Power Cell

// A class lets multiple drones share the same PowerCell instance.
final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        self.charge = max(0, min(100, charge))
    }

    func level() -> Int {
        return charge
    }

    func spend(_ amount: Int) -> Bool {
        if amount <= 0 || amount > charge {
            return false
        }

        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        if amount <= 0 {
            return
        }

        charge = min(100, charge + amount)
    }
}

// Encapsulation proof:
let cell = PowerCell(charge: 80)
// cell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level

print(cell.level())
print(cell.spend(25))
print(cell.level())
cell.recharge(by: 100)
print(cell.level())
// MARK: Level 2 · The Fleet

// 2.1
// What does `final` on runOnce() buy you?  ->
// final prevents subclasses from changing the shift execution rules.

class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int {
        return 10
    }

    var statusLine: String {
        return "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    func performTask() -> Int {
        return 0
    }

    final func runOnce() -> Int {
        if !cell.spend(powerCost) {
            return 0
        }

        return performTask()
    }
}

// 2.2

final class WelderDrone: Drone {
    override var powerCost: Int {
        return 25
    }

    override func performTask() -> Int {
        return 40
    }

    func weldSeam() -> String {
        return "\(id) welded a seam"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int {
        return 10
    }

    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }

    override func performTask() -> Int {
        return 15
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int {
        return 20
    }

    override func performTask() -> Int {
        return 25
    }
}


// 2.3

func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)

    switch kind {
    case "welder":
        return WelderDrone(id: id, cell: cell)
    case "scanner":
        return ScannerDrone(id: id, cell: cell)
    case "cargo":
        return CargoDrone(id: id, cell: cell)
    default:
        return nil
    }
}

var fleet: [Drone] = []

for record in fleetData {
    if let drone = makeDrone(
        kind: record.kind,
        id: record.id,
        charge: record.charge
    ) {
        fleet.append(drone)
    } else {
        print("Warning: unknown drone kind \(record.kind)")
    }
}

print("Fleet ready: \(fleet.count) drones")



// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0

    for _ in 0..<max(0, rounds) {
        for drone in fleet {
            totalWork += drone.runOnce()
        }
    }

    return totalWork
}


let A = runShift(fleet, rounds: 3)


var B = 0
var C = 0

for drone in fleet {
    print(drone.statusLine)

    let remainingCharge = drone.cell.level()
    B += remainingCharge

    if remainingCharge >= drone.powerCost {
        C += 1
    }
}

print("A = \(A)")
print("B = \(B)")
print("C = \(C)")


// MARK: Level 4 · Diagnostics

// 4.1

protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2

protocol Rechargeable {
    mutating func recharge(by amount: Int)
}
// Why does Drone implement recharge(by:) without `mutating`?  ->
// Classes use reference semantics, so mutating is not needed.

extension Drone: Diagnosable, Rechargeable {
    var componentID: String {
        return id
    }

    var statusCode: Int {
        return healthCode(cell.level())
    }

//    func diagnose() -> String {
//        return "\(componentID): code \(statusCode)"
//    }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let componentID: String
    var chargeLevel: Int

    var statusCode: Int {
        return healthCode(chargeLevel)
    }

//    func diagnose() -> String {
//        return "\(componentID): code \(statusCode)"
//    }

    mutating func recharge(by amount: Int) {
        if amount > 0 {
            chargeLevel = min(100, chargeLevel + amount)
        }
    }
}

// Shared health rule (temporary location).
// In Level 5, move this logic into Diagnosable extension.

//func healthCode(for charge: Int) -> Int {
//    if charge < 20 {
//        return 2
//    } else if charge < 50 {
//        return 1
//    }
//    return 0
//}


// 4.3
// Why could [Drone] never have held the sensors?  ->
// [Drone] cannot hold sensors because SensorModule
// does not inherit from Drone.

func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = ""

    for component in components {
        report += component.diagnose() + "\n"
    }

    return report
}

// Create sensors
var sensors: [SensorModule] = []

for data in sensorData {
    let sensor = SensorModule(
        componentID: data.id,
        chargeLevel: data.charge
    )
    sensors.append(sensor)
}

// Combine drones and sensors
var components: [Diagnosable] = []

for drone in fleet {
    components.append(drone)
}

for sensor in sensors {
    components.append(sensor)
}

print("=== DIAGNOSTICS REPORT ===")
print(diagnosticsReport(components))


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
extension Diagnosable {

    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }

    func healthCode(_ charge: Int) -> Int {
        if charge < 20 {
            return 2
        } else if charge < 50 {
            return 1
        }
        return 0
    }
}

// 5.2 · the beacon you cannot edit
extension LegacyBeacon: Diagnosable {

    var componentID: String {
        return name
    }

    var statusCode: Int {
        return healthCode(signalStrength)
    }

    func diagnose() -> String {
        return "LEGACY BEACON \(componentID): code \(statusCode)"
    }
}

// Add beacon to diagnostics
components.append(beacon)

print("=== FINAL DIAGNOSTICS ===")
print(diagnosticsReport(components))


var D = 0
for component in components {
    D += component.statusCode
}

print("D = \(D)")


// 5.3

extension Int {
    var powerBar: String {
        let filled = Swift.max(0, Swift.min(10, self / 10))
        let empty = 10 - filled

        return String(repeating: "#", count: filled)
             + String(repeating: ".", count: empty)
    }
}


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// Report 1
class PatchDrone: Drone {
    func performTask() -> Int {
        return 30
    }
}
*/
// Expected: PatchDrone performs 30 work units.
// Actual: Compilation error: missing 'override' keyword.
// Rule: Overriding a superclass method requires 'override'.
// Fix: Add 'override' before func performTask().



/*
// Report 2
final class HeavyWelder: WelderDrone {
    override func runOnce() -> Int {
        return 999
    }
}
*/
// Expected: HeavyWelder overrides runOnce() and returns 999.
// Actual: Compilation error.
// Rule: A final class cannot be inherited,
// and a final method cannot be overridden.
// Fix: Create a new Drone subclass and override
// performTask() instead of runOnce().



/*
// Report 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
print(first.weldSeam())
*/
// Expected: Call weldSeam() on the welder.
// Actual: Compilation error because Drone has no weldSeam().
// Rule: A superclass reference only exposes
// members declared in the superclass.
// Fix: Use conditional casting with 'as?'.
// 'as?' returns an optional because casting may fail.

let reportFleet: [Drone] = [
    WelderDrone(id: "W-9", cell: PowerCell(charge: 100))
]

let first = reportFleet[0]

if let welder = first as? WelderDrone {
    print(welder.weldSeam())
}



/*
// Report 4
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())
*/

protocol Labelled {
    var componentID: String { get }
    func label() -> String
}

extension Labelled {
    func label() -> String {
        return "generic component"
    }
}

struct Thruster: Labelled {
    let componentID: String

    func label() -> String {
        return "thruster \(componentID)"
    }
}

let parts: [Labelled] = [
    Thruster(componentID: "T-1")
]

print(parts[0].label())


// MARK: Finale · Mission Code

print("A = \(A)")
print("B = \(B)")
print("C = \(C)")
print("D = \(D)")

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("MISSION CODE: \(missionCode)")


// MARK: Bonus

// Two ways to forbid using Drone directly; a protocol-based redesign;
// two or three sentences comparing them.

// 1. Runtime protection:
// A base class can reject direct instantiation at runtime.
// Example (do not add this to the existing Drone class):
//
// class RuntimeDrone {
//     init() {
//         precondition(type(of: self) != RuntimeDrone.self,
//                      "Cannot create a base drone directly")
//     }
// }

// Compile-time protection:
// A private initializer prevents code outside
// the type's access scope from calling it.
//
// class RestrictedDrone {
//     private init() {}
// }

// 2. Protocol-based redesign

protocol DroneProtocol {
    var id: String { get }
    var charge: Int { get set }
    var powerCost: Int { get }
    var workUnits: Int { get }

    mutating func runOnce() -> Int
}

extension DroneProtocol {
    mutating func runOnce() -> Int {
        if charge < powerCost {
            return 0
        }

        charge -= powerCost
        return workUnits
    }
}

struct ProtocolWelderDrone: DroneProtocol {
    let id: String
    var charge: Int

    var powerCost: Int {
        return 25
    }

    var workUnits: Int {
        return 40
    }
}

var bonusWelder = ProtocolWelderDrone(
    id: "BW-1",
    charge: 80
)

print("Bonus work: \(bonusWelder.runOnce())")

// 3. Comparison:
// Inheritance shares stored state and behavior through
// a base class, while protocols define common behavior
// for unrelated types.
// I would choose classes for this station because drones
// may need to share mutable state such as PowerCell.
// With structs, shared mutable state would require
// a separate reference-type object.

// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?
 
 Classes are reference types, so their methods can modify
 properties without the mutating keyword.
 Structs are value types and require mutating when a method
 changes their stored properties.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:
 
 Inheritance allows subclasses to inherit stored properties
 and implementations from a superclass.
 Protocols allow unrelated classes and structs to share
 the same interface.


 3. What does `final` prevent, and what did it protect in runOnce()?
 
 final prevents inheritance when applied to a class
 and overriding when applied to a method.
 In runOnce(), it prevents subclasses from bypassing
 the battery spending rules.

 4. In Report 4, why did the protocol extension's method win?
 
 Because label() was only defined in the protocol extension,
 not declared as a protocol requirement.
 Swift used static dispatch and called the extension method.
 Adding label() to the protocol enables dynamic dispatch
 to the Thruster implementation.

*/

