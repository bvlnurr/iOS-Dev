//
//  ViewController.swift
//  10_fav_cars
//
//  Created by Балнур on 16.10.2026.
//


import UIKit

struct FavoriteCar {
    let name: String
    let description: String
    let imageName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carDescriptionLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!

    let cars: [FavoriteCar] = [
        FavoriteCar(
            name: "Toyota Supra",
            description: "I've always loved the Supra, especially its iconic look. It's one of those cars I could never get tired of seeing. Definitely one of my dream cars.",
            imageName: "Supra"
        ),
        FavoriteCar(
            name: "Porsche 911",
            description: "I love how Porsche looks so simple but expensive at the same time. Everything about this car is just perfect to me. I hope I'll own one someday.",
            imageName: "Porsche"
        ),
        FavoriteCar(
            name: "BMW M5",
            description: "The BMW M5 is literally my type of car. I love how it looks classy but also aggressive. If I could choose one car to drive every day, this would be one of my first choices.",
            imageName: "BMW"
        ),
        FavoriteCar(
            name: "Mitsubishi Eclipse",
            description: "I fell in love with this car because of its old-school JDM vibe. There's something so special about its design, and I honestly think older cars have more personality.",
            imageName: "Eclipse"
        ),
        FavoriteCar(
            name: "Ferrari F40",
            description: "This Ferrari is just different. I love its vintage design and the fact that it still looks incredible after all these years. It's one of the most beautiful cars I've ever seen.",
            imageName: "Ferrari"
        ),
        FavoriteCar(
            name: "Toyota Land Cruiser",
            description: "I've always liked the Land Cruiser because it looks powerful and reliable. It's the kind of car I'd want for long road trips, adventures, and everyday comfort.",
            imageName: "LandCruiser"
        ),
        FavoriteCar(
            name: "Mazda Miata",
            description: "The Miata is so cute, especially with its pop-up headlights. I love how small and fun it looks. It just makes me smile every time I see one.",
            imageName: "Miata"
        ),
        FavoriteCar(
            name: "Bugatti Chiron",
            description: "I know this car is insanely expensive, but that's part of the dream. I love its unique design and how unreal it looks. Seeing one in real life would be unforgettable.",
            imageName: "Bugatti"
        ),
        FavoriteCar(
            name: "McLaren 720S",
            description: "I love how futuristic the McLaren looks. The shape, the doors, the whole design — everything about it is so cool. I'd love to experience driving one someday.",
            imageName: "McLaren"
        ),
        FavoriteCar(
            name: "Nissan GT-R",
            description: "The GT-R has always been one of my favorite Japanese cars. I love its aggressive look and the sound of its engine. There's just something about this car that makes it special to me.",
            imageName: "Nissan"
        )
    ]

    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        carImageView.contentMode = .scaleAspectFill
        carDescriptionLabel.numberOfLines = 0

        carImageView.layer.cornerRadius = 12
        carImageView.clipsToBounds = true

        showCar(at: currentIndex)
    }

    func showCar(at index: Int) {
        let car = cars[index]

        carNameLabel.text = car.name
        carDescriptionLabel.text = car.description
        carImageView.image = UIImage(named: car.imageName)
        carNumberLabel.text = String(format: "%02d / 10", index + 1)
    }

    @IBAction func nextCarTapped(_ sender: UIButton) {
        var newIndex = currentIndex

        while newIndex == currentIndex {
            newIndex = Int.random(in: 0..<cars.count)
        }

        currentIndex = newIndex
        showCar(at: currentIndex)
    }
}


