import Cocoa

// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Deck Register

// 1.1

enum Deck: String, CaseIterable {
    case bridge
    case lab
    case cargo
    case medbay
    case engine
    
    var evacuationPriority: Int{
        switch self{
        case.bridge:
            return 1
        case.lab:
            return 2
        case.cargo:
            return 3
        case.medbay:
            return 4
        case.engine:
            return 5
        }
    }
    
}

for deck in Deck.allCases{
    print("\(deck.rawValue): \(deck.evacuationPriority)")
}


// 1.2

enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let value = min(max(mass / 500, 0), 3)
        return AlarmLevel(rawValue: value) ?? .green
    }
}

print(AlarmLevel.level(forTotalMass: 0))
print(AlarmLevel.level(forTotalMass: 940))
print(AlarmLevel.level(forTotalMass: 4000))



// MARK: Level 2 · The Manifest

// 2.1

enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2

func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)

    guard let type = parts.first else {
        return .unknown(raw: line)
    }

    switch type {
    case "crate":
        if parts.count == 3,
            let id = Int(parts[1]),
            let mass = Int(parts[2]) {
            return .crate(id: id, massKg: mass)
        }

    case "container":
        if parts.count == 3,
            let mass = Int(parts[2]) {
             return .container(code: parts[1], massKg: mass)
        }

    case "livestock":
        if parts.count == 4,
            let count = Int(parts[2]),
            let mass = Int(parts[3]) {
            return .livestock(
                species: parts[1],
                count: count,
                massPerUnitKg: mass
            )
        }

    default:
        break
    }

    return .unknown(raw: line)
}

// 2.3

func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg

    case .container(_, let massKg):
        return massKg

    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg

    case .unknown:
        return 0
    }
}

var totalMass = 0
var unknownCount = 0

for line in rawManifest {
    let entry = parseEntry(line)
    totalMass += mass(of: entry)

    if case .unknown = entry {
        unknownCount += 1
    }
}

let A = totalMass

print("A =", A)
print("Unknown entries: \(unknownCount)")
print("Test crate: \(mass(of: parseEntry("crate:101:120"))) kg")
print("Test livestock: \(mass(of: parseEntry("livestock:lab mice:12:2"))) kg")


// MARK: Level 3 · Crew Snapshots

// 3.1

struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen = max(0, oxygen - max(0, amount))
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(
            name: name,
            deck: .medbay,
            oxygen: 100
        )
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(
            name: name,
            deck: .bridge,
            oxygen: 100
        )
    }
}


// 3.2

var crewRoster: [CrewSnapshot] = []

for person in crewData {
    if let deck = Deck(rawValue: person.deck) {
        let crew = CrewSnapshot(
            name: person.name,
            deck: deck,
            oxygen: person.oxygen
        )
        crewRoster.append(crew)
    } else {
        print("Warning: Invalid deck for \(person.name)")
    }
}

print("Crew members: \(crewRoster.count)")

for crew in crewRoster {
    print("\(crew.name): \(crew.deck.rawValue), oxygen \(crew.oxygen)")
}

// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)

//Copy
var original = CrewSnapshot.rookie(named: "Dana")
var copy = original

print("Before copy change: original \(original.oxygen), copy \(copy.oxygen)")
copy.breathe(30)
print("After copy change: original \(original.oxygen), copy \(copy.oxygen)")

//Without inout
func changeWithoutInout(_ crew: CrewSnapshot) {
    var local = crew
    print("Before local change: \(local.oxygen)")
    local.breathe(20)
    print("After local change: \(local.oxygen)")
}

print("Original before function: \(original.oxygen)")
changeWithoutInout(original)
print("Original after function: \(original.oxygen)")

//With inout
func changeWithInout(_ crew: inout CrewSnapshot) {
    crew.breathe(20)
}

print("Original before inout: \(original.oxygen)")
changeWithInout(&original)
print("Original after inout: \(original.oxygen)")



// MARK: Level 4 · The Teleport Pod

// 4.1

final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    // Struct gets a memberwise initializer automatically.
    // Class needs an explicit initializer.
    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        if occupant != nil || chargeLevel < 20 {
            return false
        }

        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let crew = occupant else {
            return nil
        }

        chargeLevel -= 20
        occupant = nil
        return crew
    }
}

// 4.2 · Charge ledger: load+fire three times, then fire an empty pod

let pod = TeleportPod(id: "P-1", chargeLevel: 100)

for name in ["Timur", "Dana", "Nurlan"] {
    for crew in crewRoster {
        if crew.name == name {
            let loaded = pod.load(crew)
            print("Load \(name): \(loaded), charge: \(pod.chargeLevel)")

            let result = pod.fire()
            print("Fire \(name): \(result?.name ?? "none"), charge: \(pod.chargeLevel)")
        }
    }
}

let emptyResult = pod.fire()
print("Empty fire: \(emptyResult?.name ?? "none"), charge: \(pod.chargeLevel)")

let C = pod.chargeLevel
print("C =", C)


// 4.3 · Reference-semantics demonstration

let secondPod = pod

print("Before class change: pod \(pod.chargeLevel), secondPod \(secondPod.chargeLevel)")
secondPod.chargeLevel = 30
print("After class change: pod \(pod.chargeLevel), secondPod \(secondPod.chargeLevel)")

var firstSnapshot = CrewSnapshot.rookie(named: "Dana")
var secondSnapshot = firstSnapshot

print("Before struct change: first \(firstSnapshot.oxygen), second \(secondSnapshot.oxygen)")
secondSnapshot.breathe(40)
print("After struct change: first \(firstSnapshot.oxygen), second \(secondSnapshot.oxygen)")
// Classes share the same instance; structs create independent copies.



// MARK: Level 5 · Station Systems

// 5.1

final class Station {
    let callSign: String

    var oxygenByDeck: [Deck: Int]

    var hullIntegrity: Int {
        willSet {
            print("Hull changing: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            hullIntegrity = min(100, max(0, hullIntegrity))
        }
    }

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "Station \(callSign): hull \(hullIntegrity), oxygen \(totalOxygen)"
    }()

    var totalOxygen: Int {
        var total = 0
        for oxygen in oxygenByDeck.values {
            total += oxygen
        }
        return total
    }

    var averageOxygen: Int {
        get {
            if oxygenByDeck.isEmpty {
                return 0
            }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)]) {
        self.callSign = callSign
        self.hullIntegrity = 100
        self.oxygenByDeck = [:]

        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                oxygenByDeck[deck] = reading.oxygen
            } else {
                print("Invalid deck skipped: \(reading.deck)")
            }
        }
    }
}

// Create Station
let station = Station(callSign: "ALMA-7", readings: deckReadings)

// fragment B
let B = station.averageOxygen

print("Total oxygen: \(station.totalOxygen)")
print("Average oxygen: \(B)")
print("B =", B)

// Test computed setter
station.averageOxygen = 50
print("New average oxygen: \(station.averageOxygen)")
print("New total oxygen: \(station.totalOxygen)")

// Test lazy property
print("Before diagnostics")
print(station.fullDiagnostics)
print("Second diagnostics access:")
print(station.fullDiagnostics)


// 5.2 · The clamp trap: 130, then -40, then 55

station.hullIntegrity = 130
print("Hull after 130: \(station.hullIntegrity)")

station.hullIntegrity = -40
print("Hull after -40: \(station.hullIntegrity)")

station.hullIntegrity = 55
print("Hull after 55: \(station.hullIntegrity)")

// Assigning inside didSet does not trigger didSet again,
// so clamping does not cause an infinite loop.


// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// Report 1
var roster = crewRoster
for var member in roster {
    member.oxygen -= 10
}
print(roster[0].oxygen)   // author expected the crew to have lost oxygen
 
*/

// Expected: all crew members lose 10 oxygen.
// Actual: roster does not change.
// Rule: struct has value semantics; for-in uses copies.
// Fix: modify array elements using indices.

var roster = crewRoster

for index in roster.indices {
    roster[index].oxygen -= 10
}

print("Report 1 fixed: \(roster[0].oxygen)")

/*
// Report 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = podA
podB.chargeLevel = 0
print(podA.chargeLevel)   // author expected 100
*/

// Expected: podA keeps charge 100.
// Actual: podA charge becomes 0.
// Rule: classes have reference semantics.
// Fix: create a separate TeleportPod.

let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = TeleportPod(id: "B", chargeLevel: podA.chargeLevel)

podB.chargeLevel = 0

print("Report 2 fixed: podA \(podA.chargeLevel), podB \(podB.chargeLevel)")

/*
// Report 3
struct Logbook {
    var entries: [String] = []
    func add(_ entry: String) {
        entries.append(entry)
    }
}
*/

// Expected: add() appends a new entry.
// Actual: original code does not compile.
// Rule: struct methods need mutating to change properties.
// Fix: add the mutating keyword.

struct Logbook {
    var entries: [String] = []

    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

var logbook = Logbook()
logbook.add("Teleport successful")
logbook.add("Crew arrived")

print("Report 3 fixed: \(logbook.entries)")

/*
// Report 4
let snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10
*/

// Expected: both let values can change their properties.
// Actual: struct let cannot change, class let can.
// Rule: let freezes a struct value but only
// freezes the reference to a class instance.
// Fix: use var for the struct.

var snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let reportPod = TeleportPod(id: "B", chargeLevel: 50)
reportPod.chargeLevel = 10

print("Report 4 snapshot oxygen: \(snapshot.oxygen)")
print("Report 4 pod charge: \(reportPod.chargeLevel)")


// MARK: Level 7 · Sealing the Black Box

final class FlightRecorder {
    private var entries: [String] = []

    private(set) var isSealed = false

    var entryCount: Int {
        return entries.count
    }

    var transcript: String {
        var result = ""
        for entry in entries {
            result += entry + "\n"
        }
        return result
    }

    func addEntry(_ entry: String) {
        if !isSealed {
            entries.append(entry)
        } else {
            print("Recorder is sealed!")
        }
    }

    func seal() {
        isSealed = true
    }

    fileprivate func auditInfo() -> String {
        return "Entries: \(entries.count), sealed: \(isSealed)"
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    return recorder.auditInfo()
}

// Test FlightRecorder
let recorder = FlightRecorder()

recorder.addEntry("Crew loaded")
recorder.addEntry("Teleport successful")

print("Entries: \(recorder.entryCount)")
print("Transcript:\n\(recorder.transcript)")

recorder.seal()
recorder.addEntry("Unauthorized entry")

print("Audit: \(auditTranscript(of: recorder))")

// These attempts must fail to compile:
// recorder.entries = []
// Error: 'entries' is inaccessible due to 'private' protection level.

// recorder.isSealed = false
// Error: setter is inaccessible.

// recorder.auditInfo()
// This call is allowed in the same file because it is fileprivate.


// MARK: Finale · Integrity Code

print("A =", A)
print("B =", B)
print("C =", C)
print("D =", D)

let D = AlarmLevel.level(forTotalMass: A).rawValue

let integrityCode = "\(A)-\(B)-\(C)-\(D)"

print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

var savedPod: TeleportPod?

do {
    let temporaryPod = TeleportPod(
        id: "BONUS",
        chargeLevel: 100
    )

    savedPod = temporaryPod

    print("Inside do block")
}

print("Outside do block")
print("Pod still exists")

savedPod = nil
print("Last reference removed")

// Identity operator ===
func samePod(_ a: TeleportPod, _ b: TeleportPod) -> Bool {
    return a === b
}

let firstPod = TeleportPod(id: "X", chargeLevel: 100)
let sameReference = firstPod
let anotherPod = TeleportPod(id: "X", chargeLevel: 100)

print("Same reference: \(samePod(firstPod, sameReference))")
print("Different objects: \(samePod(firstPod, anotherPod))")

// === works only with class instances.
// CrewSnapshot is a struct, so === cannot be used.



// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?
 
 CrewSnapshot gets a memberwise initializer automatically
 because it is a struct. TeleportPod is a class, so we must
 initialize its stored properties ourselves.

 2. What does `mutating` do to self, and why do classes never need it?
 
 mutating allows a struct method to modify its properties
 or replace self. Classes do not need mutating because
 they use reference semantics.


 3. In Report 4 both values are `let`. What exactly does `let` freeze for a
    struct, and what does it freeze for a class?
 
 For a struct, let freezes the entire value and its
 properties. For a class, let freezes only the reference,
 so var properties can still be changed.

 4. Why must a lazy property be var? When does lazy change behaviour, not
    just performance?
 
 A lazy property must be var because its value is
 initialized on first access. Lazy changes behavior when
 initialization has side effects, such as printing a
 message or performing a scan.


 5. private vs fileprivate: where in your FlightRecorder would private be
    too strict?
 
 private restricts access to the type and its extensions
 in the same file. fileprivate allows access from other
 code in the same file. Our auditTranscript function
 needs fileprivate to call auditInfo().

 Bonus. On which line does deinit fire, and why can't === be used on
 CrewSnapshot?
 
 deinit fires when savedPod = nil because the last
 strong reference to the object is removed.

 === cannot be used on CrewSnapshot because it is
 a struct (value type), not a class (reference type).
 === compares object identity, not values.

*/

