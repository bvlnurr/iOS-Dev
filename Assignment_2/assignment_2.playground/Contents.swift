import UIKit

//Easy Tasks
//1. Array creation and access:
var fruits: [String] = ["Banana", "Blueberry", "Mango", "Apple", "Orange"]

print(fruits[2])
//[0],[1],[2],[3],[4]
//banana,blueberry,mango,apple,orange

//2. Set creation and manipulation:
var favNumbers: Set<Int> = [8, 7, 3, 5, 22]

favNumbers.insert(64)
print(favNumbers)

//3. Dictionary creation and access:
var progLang = ["Swift": 2014, "Python": 1991, "JavaScript": 1995]

print(progLang["Swift"]!)

//4. Array element update:
var colors: [String] = ["Cyan", "Green", "Purple", "Pink"]

colors[1] = "Brown"

print(colors)


//Medium tasks
//1. Set intersection:
let firstSet: Set<Int> = [1,2,3,4]
let secondSet: Set<Int> = [3,4,5,6]
let result = firstSet.intersection(secondSet)

print(result)

//2. Dictionary update:
var dict = ["John": 90, "Cris": 75, "Marie": 81]

dict["Cris"] = 80

print(dict["Cris"]!)

//3. Array merge:
let array1 = ["apple", "banana"]
let array2 = ["cherry", "date"]
let allFruits = array1 + array2

print(allFruits)

//Hard tasks
//1. Dictionary key addition:
var countries = ["Japan": 122427731, "South Korea": 51600388, "France": 66746401]
countries["Kazakhstan"] = 21083626

print(countries)

//2. Set union and subtract
let set1: Set<String> = ["cat", "dog"]
let set2: Set<String> = ["dog", "mouse"]

let unionSet = set1.union(set2)
let finalSet = set1.subtracting(set2)

//print(unionSet)
print(finalSet)

//3. Nested collection:
var grades = ["Alice": [78, 85, 90], "Dimash": [65, 70, 91], "Arina": [73, 88, 93]]

print(grades["Alice"]![1])
