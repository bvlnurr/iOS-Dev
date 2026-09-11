import UIKit

//Step 1
let firstName: String = "Balnur"
let lastName: String = "Dauirkhankyzy"
let age: Int = 20
let birthYear: Int = 2006
let isStudent: Bool = true
let height: Double = 1.67

let currentYear: Int = 2026
let calculatedAge: Int = currentYear - birthYear

//Step 2
let hobby: String = "drawing, watching kdramas, baking"
let numberOfHobbies: Int = 3
let favoriteNumber: Int = 8
let ishobbyCreative: Bool = true
let favoriteColor: String = "Lilac" // shade of purple
let favoriteCarBrand: String = "BMW530"

//Step 3
var lifeStory: String = "My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear). I am currently a student. I enjoy \(hobby), which are creative hobbies. I have \(numberOfHobbies) in total, and my favorite number is \(favoriteNumber). And about my favorite color, it is \(favoriteColor). Also I love \(favoriteCarBrand) so much."

//Step 4
//print(lifeStory)

//Bonus Task
let favoriteEmoji: String = "🤣🤭"
let 💕: String = "wanna"
let futureGoals: String = "In the future, I want to be a good developer, \(💕) travel around the wolrd and be rich \(favoriteEmoji)."

lifeStory += " \(futureGoals)"
print(lifeStory)
