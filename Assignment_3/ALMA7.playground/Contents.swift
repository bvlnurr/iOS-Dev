import Cocoa

// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · Decoding Telemetry

// 1.1

func parseReading(_ raw: String) -> Reading? {
    guard let (sensor, text) = splitOnce(raw, by: ":"),
          !sensor.isEmpty,
          let value = Int(text),
          (value >= 0 || sensor == "TEMP")
    else {
        return nil
    }
    
    return (sensor: sensor, value: value)
}

print(parseReading("02:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)



// 1.2

func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0
    
    for line in lines{
        if let reading = parseReading(line){
            valid.append(reading)
        } else{
            invalidCount += 1
        }
    }
    
    return (valid: valid, invalidCount: invalidCount)
}

let result = parseLog(rawLog)

//print("Valid readings:")
//for reading in result.valid{
//    print("\(reading.sensor): \(reading.value)")
//}

print("Valid readings:", result.valid)

let A = result.invalidCount
print("A =", A)

//second test
let testLog = ["O2:50", "BAD", "TEMP:-5"]
print(parseLog(testLog))


// MARK: Level 2 · Analysis

// 2.1

func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var selected: [Reading] = []
    
    for reading in readings{
        if isIncluded(reading){
            selected.append(reading)
        }
    }
    
    return selected
}


func values(of readings: [Reading]) -> [Int] {
    var numbers: [Int] = []
    
    for reading in readings{
        numbers.append(reading.value)
    }
    
    return numbers
}

let oxygenReading = select(result.valid){
    $0.sensor == "O2"
}

let oxygenValue = values(of: oxygenReading)

print("Oxygen readings:", oxygenReading)
print("Oxygen values:", oxygenValue)

//second test
let tempReading = select(result.valid){
    $0.sensor == "TEMP"
}

print("Temperature readings:", tempReading)
print("Temperature values:", values(of: tempReading))

// 2.2

func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first
    else{
        return nil
    }
    
    var minimum = first
    var maximum = first
    var sum = 0
    
    for value in values{
        if value < minimum{
            minimum = value
        }
        
        if value > maximum{
            maximum = value
        }
        
        sum += value
    }
    
    let average = Double(sum) / Double(values.count)
    
    
    return (min: minimum, max: maximum, average: average)
    
}


func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print("Stats test 1:", stats(3, 8, 1) as Any)
print("Stats test 2:", stats() as Any)

let oxygenStats = stats(of: oxygenValue)
let B = Int(oxygenStats?.average ?? 0)
print("B =", B)


// 2.3 · The Closure Ladder (5 sorts, then compare results in code)

//full closure
let sorted1 = result.valid.sorted(by: {(a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})


//types inerred
let sorted2 = result.valid.sorted(by:{ a, b in
    return a.value > b.value
})


//implicit return
let sorted3 = result.valid.sorted(by: { a, b in
    a.value > b.value
})


//shorthand arguments
let sorted4 = result.valid.sorted(by: {
    $0.value > $1.value
})


//trailling closure
let sorted5 = result.valid.sorted{
    $0.value > $1.value
}

func sameReading(_ a: [Reading], _ b: [Reading]) -> Bool{
    guard a.count == b.count
    else{
        return false
    }
    
    for i in a.indices{
        if a[i].sensor != b[i].sensor ||
            a[i].value != b[i].value{
            return false
        }
    }
    
    return true
}

let allMatch = sameReading(sorted1, sorted2) &&
    sameReading(sorted2, sorted3) &&
    sameReading(sorted3, sorted4) &&
    sameReading(sorted4, sorted5)

print("All five sorts match:", allMatch)



// MARK: Level 3 · Temperature Stabilization

// 3.1

func heatUp(_ t: Int) -> Int {
    return t + 5
}

func coolDown(_ t: Int) -> Int {
    return t - 3
}

func hold(_ t: Int) -> Int {
    return t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18{
        return heatUp
    } else if temp > 24{
        return coolDown
    } else{
        return hold
    }
}


print("Heat:", heatUp(10))
print("Cool:", coolDown(30))
print("Hold:", hold(20))
print("Protocol cold:", chooseProtocol(for: 10)(10))
print("Protocol hot:", chooseProtocol(for: 30)(30))
print("Protocol normal:", chooseProtocol(for: 20)(20))


// 3.2

func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temperature = start
    var steps = 0
    
    while(temperature < 18 || temperature > 24) && steps < maxSteps {
        let protocolFunction = chooseProtocol(for: temperature)
        temperature = protocolFunction(temperature)
        steps += 1
    }
    
    let isStable = temperature >= 18 && temperature <= 24
    
    return (finalTemp: temperature, steps: steps, isStable: isStable)
    
}


print("Test 1:", runUntilStable(from: 31))
print("Test 2:", runUntilStable(from: -100, maxSteps: 5))
print("Test 3:", runUntilStable(from: 20))

let tempReadingsForC = select(result.valid){
    $0.sensor == "TEMP"
}

let tempValuesForC = values(of: tempReadingsForC)

let tempStats = stats(of: tempValuesForC)

let lowestTemp = tempStats?.min ?? 0

let stabilizationResult = runUntilStable(from: lowestTemp)

let C = stabilizationResult.steps

print("Lowest temperature:", lowestTemp)
print("Stabilization:", stabilizationResult)
print("C=", C)


// MARK: Level 4 · The Crew

// 4.1

func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

print("Timur oxygen:", oxygenLevel(of: crew[0]) as Any)
print("Dana oxygen:", oxygenLevel(of: crew[1]) as Any)
print("Aigerim oxygen:", oxygenLevel(of: crew[2]) as Any)
print("Nurlan oxygen:", oxygenLevel(of: crew[3]) as Any)

// 4.2

func status(of member: CrewMember) -> String {
    let moduleName = member.module?.name ?? "open space"
    
    guard let oxygen = oxygenLevel(of: member) else{
        return "\(member.name): no data (\(moduleName))"
    }
    
    if oxygen < 20{
        return "\(member.name): \(oxygen)% CRITICAL"
    } else{
        return "\(member.name): \(oxygen)% OK"
    }
}

print("Test 1:", status(of: crew[0]))
print("Test 2:", status(of: crew[1]))
print("Test 3:", status(of: crew[2]))
print("Test 4:", status(of: crew[3]))

// 4.3

@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    if amount < 0{
        return 0
    }
    
    let availableSpace = max(0, 100 - target)
    let actualAmount = min(amount, max(0, source), availableSpace)
    
    source -= actualAmount
    target += actualAmount
    
    return actualAmount
    
}


//Target almost full
var source1 = 50
var target1 = 95
let moved1 = transferOxygen(from: &source1, to: &target1, amount: 30)

print("Test 1:", source1, target1, moved1)

//Negative amount
var source2 = 40
var target2 = 12

let moved2 = transferOxygen(from: &source2, to: &target2, amount: -10)

print("Test 2:", source2, target2, moved2)


var D = 0

if let labTank = lab.oxygenTank,
   let habTank = hab.oxygenTank {

    let transferred = transferOxygen(
        from: &labTank.level,
        to: &habTank.level,
        amount: 30
    )

    print("Transferred:", transferred)
    print("Lab oxygen:", labTank.level)
    print("Hab oxygen:", habTank.level)

    D = habTank.level
}

print("D =", D)

// 4.4

func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var foundMembers: [CrewMember] = []

    for name in names {
        guard let member = roster[name]
        else {
            print("Unknown crew member: \(name)")
            continue
        }

        foundMembers.append(member)
    }

    let sortedMembers = foundMembers.sorted {
        $0.priority < $1.priority
    }

    var result: [String] = []

    for member in sortedMembers {
        result.append(member.name)
    }

    return result
}

let order1 = evacuationOrder(
    "Dana", "Ghost", "Aigerim", "Timur",
    roster: roster
)
print("Evacuation order 1:", order1)


let order2 = evacuationOrder(
    "Timur", "Nurlan", "Dana", "Aigerim",
    roster: roster
)
print("Evacuation order 2:", order2)



// MARK: Level 5 · The Saboteur's Logbook
// The saboteur's code is below, commented out (it needs your
// oxygenLevel(of:) to compile). Comment on every problem, then
// write fixed versions and a test that proves the logic bug is gone.

/*
func reportOxygen(for member: CrewMember) -> String {
    let tank = member.module!.oxygenTank!
    return "\(member.name): \(tank.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String {
    var result: String?
    for member in crew {
        if oxygenLevel(of: member)! < 20 {
            result = member.name
        }
    }
    return result!
}
*/

// Bug 1: module can be nil (Nurlan), causing a crash.
// Bug 2: oxygenTank can be nil (Dana), causing a crash.

func reportOxygen(for member: CrewMember) -> String {
    guard let oxygen = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }

    return "\(member.name): \(oxygen)%"
}

// Bug 3: oxygenLevel can be nil, causing a crash.
// Bug 4: result can stay nil if no critical member exists.
// Bug 5: the loop returns the LAST critical member,
// not the FIRST one.

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let oxygen = oxygenLevel(of: member) else {
            continue
        }

        if oxygen < 20 {
            return member.name
        }
    }

    return nil
}

print("Report 1:", reportOxygen(for: crew[0]))
print("Report 2:", reportOxygen(for: crew[3]))
print("Critical 1:", firstCritical(in: crew) as Any)
print("Critical 2:", firstCritical(in: []) as Any)

//Prove test
let testModule1 = Module(
    name: "Test1",
    oxygenTank: Tank(level: 10)
)

let testModule2 = Module(
    name: "Test2",
    oxygenTank: Tank(level: 5)
)

let testCrew = [
    CrewMember(
        name: "First",
        role: "Tester",
        priority: 1,
        module: testModule1
    ),
    CrewMember(
        name: "Second",
        role: "Tester",
        priority: 2,
        module: testModule2
    )
]

let firstResult = firstCritical(in: testCrew)

print("Logic bug test:", firstResult as Any)
print("First critical is correct?:", firstResult == "First")

// MARK: Finale · Launch Code
print("A=", A)
print("B =", B)
print("C=", C)
print("D =", D)

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("Launch code:", launchCode)


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var alarmCount = 0
    
    return { value in
        if value < threshold{
            alarmCount += 1
            print("ALARM! Count: \(alarmCount)")
            return true
        }
        
        return false
        
    }
}

let oxygenAlarm = makeAlarm(threshold: 20)

print("Test 1:", oxygenAlarm(40))
print("Test 2:", oxygenAlarm(12))
print("Test 3:", oxygenAlarm(10))
print("Test 4:", oxygenAlarm(25))
print("Test 5:", oxygenAlarm(5))



// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:

 Both safely unwrap optional values. if let unwraps a value inside its own code block. guard let requires an early exit if the value is nil. After a successful guard let, the unwrapped value can be used in the rest of the current scope.
 
 
 
 2. Why can't you pass [Int] to stats(_ values: Int...)?
 
 Int... is a variadic parameter that accepts separate Int arguments. An array [Int] cannot be expanded into variadic arguments in Swift. We can use the other overload: stats(of: values).
 
 

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
 
 Both inout arguments would access and modify the same variable. Swift prevents overlapping mutable access to memory. We must use two different variables.
 
 

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?
 
 oxygenLevel returns Int?.
 The nil-coalescing operator ?? needs a compatible value type.
 "no data" is a String, not an Int.
 We can convert the number to String before using ??:
 let text = oxygenLevel(of: dana).map { String($0) } ?? "no data"
 Or use if let to handle both cases without map.

 

 5. Full type of chooseProtocol and how to read it:
 
 (Int) -> ((Int) -> Int)
 It is a function that takes an Int and returns another function. The returned function takes an Int and returns an Int.
 
 

 Bonus. Where does the alarm counter live after makeAlarm returns?

 The alarm counter lives in the closure's captured state. Swift keeps it alive after makeAlarm returns, allowing the closure to remember and update the counter between calls.
*/
