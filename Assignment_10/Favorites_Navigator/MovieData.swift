//
//  MovieData.swift
//  Favorites_Navigator
//
//  Created by Балнур on 10.11.2026.
//

import Foundation

enum MovieData {
    static let movies: [FavoriteItem] = [
        FavoriteItem(
            title: "Interstellar",
            subtitle: "Christopher Nolan (2014)",
            imageName: "interstellar",
            sceneImageName: "interstellar_scene",
            rating: 5,
            description: "Earth is dying, and a former pilot joins a mission through a wormhole. The crew searches for a new home for humanity. Time becomes both their greatest enemy and their greatest sacrifice."
        ),
        FavoriteItem(
            title: "Fight Club",
            subtitle: "David Fincher (1999)",
            imageName: "fightclub",
            sceneImageName: "fightclub_scene",
            rating: 5,
            description: "An office worker with insomnia meets a charismatic soap salesman. Together they start an underground club where men fight to feel alive. The movement soon spins out of control and becomes something far more dangerous."
        ),
        FavoriteItem(
            title: "Se7en",
            subtitle: "David Fincher (1995)",
            imageName: "seven",
            sceneImageName: "seven_scene",
            rating: 5,
            description: "Two detectives investigate a series of murders based on the seven deadly sins. One is close to retirement, the other is just starting out. The case pulls them into a dark game with no painless way out."
        ),
        FavoriteItem(
            title: "The Dark Knight",
            subtitle: "Christopher Nolan (2008)",
            imageName: "darkknight",
            sceneImageName: "darkknight_scene",
            rating: 5,
            description: "Batman, Gordon and Harvey Dent try to clean up the crime in Gotham City. Then the Joker appears, a villain who wants chaos instead of money. The hero must choose between his principles and the safety of the city."
        ),
        FavoriteItem(
            title: "The Wolf of Wall Street",
            subtitle: "Martin Scorsese (2013)",
            imageName: "wolfofwallstreet",
            sceneImageName: "wolfofwallstreet_scene",
            rating: 4,
            description: "Jordan Belfort builds a brokerage empire on fraud and deceiving his clients. Money, parties and excess quickly become his way of life. Meanwhile, the FBI is watching his every move."
        ),
        FavoriteItem(
            title: "The Prestige",
            subtitle: "Christopher Nolan (2006)",
            imageName: "prestige",
            sceneImageName: "prestige_scene",
            rating: 5,
            description: "Two magicians in late 19th century London turn from friends into bitter rivals. Each wants to create the most incredible trick and uncover the other's secret. Their obsession costs both of them far too much."
        ),
        FavoriteItem(
            title: "The Matrix",
            subtitle: "Lana and Lilly Wachowski (1999)",
            imageName: "matrix",
            sceneImageName: "matrix_scene",
            rating: 5,
            description: "A hacker named Neo learns that his everyday world is actually a computer simulation. He joins a group of rebels fighting against the machines. Now he must discover who he really is and what role he has to play."
        ),
        FavoriteItem(
            title: "Night at the Museum",
            subtitle: "Shawn Levy (2006)",
            imageName: "nightatthemuseum",
            sceneImageName: "nightatthemuseum_scene",
            rating: 4,
            description: "A struggling dad named Larry takes a job as a night guard at the Museum of Natural History. He discovers that all the exhibits come to life after dark. He has to keep order among dinosaurs, Roman soldiers and cowboys."
        ),
        FavoriteItem(
            title: "The Green Mile",
            subtitle: "Frank Darabont (1999)",
            imageName: "greenmile",
            sceneImageName: "greenmile_scene",
            rating: 5,
            description: "A death row prison guard meets an unusual inmate named John Coffey. Huge and gentle, he has a mysterious gift. This meeting changes the lives of everyone who works on the Green Mile forever."
        ),
        FavoriteItem(
            title: "Gladiator",
            subtitle: "Ridley Scott (2000)",
            imageName: "gladiator",
            sceneImageName: "gladiator_scene",
            rating: 5,
            description: "The Roman general Maximus is betrayed and sold into slavery. He becomes a gladiator and fights his way into the Colosseum. His goal is to take revenge on the man who destroyed his life."
        ),
        FavoriteItem(
            title: "The Truman Show",
            subtitle: "Peter Weir (1998)",
            imageName: "trumanshow",
            sceneImageName: "trumanshow_scene",
            rating: 5,
            description: "Truman Burbank has lived his whole life in a town that is really a giant TV set. Every step he takes is broadcast to the world, and his friends and family are actors. Slowly he notices strange details and decides to break free."
        ),
        FavoriteItem(
            title: "The Intouchables",
            subtitle: "Olivier Nakache, Éric Toledano (2011)",
            imageName: "intouchables",
            sceneImageName: "intouchables_scene",
            rating: 5,
            description: "A wealthy paralyzed aristocrat hires a young man from the projects who has just got out of prison. They are completely different, but they quickly find a common language. Their friendship helps both of them see life in a new way."
        ),
        FavoriteItem(
            title: "2 Fast 2 Furious",
            subtitle: "John Singleton (2003)",
            imageName: "2fast2furious",
            sceneImageName: "2fast2furious_scene",
            rating: 4,
            description: "Former cop Brian O'Conner moves to Miami and goes back to street racing. The authorities offer him a deal to infiltrate a drug lord's organization. To do it, he teams up with his old friend Roman."
        ),
        FavoriteItem(
            title: "The Fast and the Furious: Tokyo Drift",
            subtitle: "Justin Lin (2006)",
            imageName: "tokyodrift",
            sceneImageName: "tokyodrift_scene",
            rating: 4,
            description: "A teenager named Sean is sent to Tokyo after another run-in with the law. There he discovers the world of drifting and makes new friends and enemies. To win the big race, he has to master a completely new style of driving."
        ),
        FavoriteItem(
            title: "White Chicks",
            subtitle: "Keenen Ivory Wayans (2004)",
            imageName: "whitechicks",
            sceneImageName: "whitechicks_scene",
            rating: 4,
            description: "Two FBI agents fail an important assignment and risk their careers. To protect two wealthy socialites, they have to disguise themselves as them. This leads to a series of ridiculous and hilarious situations."
        ),
        FavoriteItem(
            title: "Ocean's 8",
            subtitle: "Gary Ross (2018)",
            imageName: "oceans8",
            sceneImageName: "oceans8_scene",
            rating: 4,
            description: "Debbie Ocean gets out of prison with a perfect plan for a huge heist. She puts together a crew of talented women with different skills. Their target is a famous necklace at the Met Gala."
        ),
        FavoriteItem(
            title: "La La Land",
            subtitle: "Damien Chazelle (2016)",
            imageName: "lalaland",
            sceneImageName: "lalaland_scene",
            rating: 5,
            description: "An aspiring actress named Mia and a jazz pianist named Sebastian meet in Los Angeles. Both dream of big careers and support each other along the way. Over time, their ambitions begin to come between them."
        ),
        FavoriteItem(
            title: "Guardians of the Galaxy",
            subtitle: "James Gunn (2014)",
            imageName: "guardians",
            sceneImageName: "guardians_scene",
            rating: 5,
            description: "Peter Quill steals a mysterious orb and becomes a target for hunters across the galaxy. By chance, he ends up on a team with four misfits. Together they must stop a villain who wants to destroy entire planets."
        ),
        FavoriteItem(
            title: "Doctor Strange",
            subtitle: "Scott Derrickson (2016)",
            imageName: "doctorstrange",
            sceneImageName: "doctorstrange_scene",
            rating: 4,
            description: "A gifted neurosurgeon loses the ability to operate after a car accident. Searching for a cure, he discovers a hidden world of magic. There he must become a protector of reality against dark forces."
        ),
        FavoriteItem(
            title: "Spider-Man: Homecoming",
            subtitle: "Jon Watts (2017)",
            imageName: "homecoming",
            sceneImageName: "homecoming_scene",
            rating: 4,
            description: "Peter Parker returns to school life after his adventure with the Avengers. He wants to prove to Tony Stark that he is ready for more. But a local villain called the Vulture forces him to take things seriously."
        ),
        FavoriteItem(
            title: "Avengers: Infinity War",
            subtitle: "Anthony and Joe Russo (2018)",
            imageName: "infinitywar",
            sceneImageName: "infinitywar_scene",
            rating: 5,
            description: "Thanos collects the Infinity Stones to reshape the fate of the universe. The Avengers, the Guardians of the Galaxy and their allies unite against him. The stakes have never been higher, and the price of victory may be too great."
        ),
        FavoriteItem(
            title: "Parasite",
            subtitle: "Bong Joon-ho (2019)",
            imageName: "parasite",
            sceneImageName: "parasite_scene",
            rating: 5,
            description: "A poor family, the Kims, slowly works its way into the home of the wealthy Park family. Each of them finds a job there while hiding their family ties. But the perfect plan falls apart because of a secret hidden in the mansion."
        ),
        FavoriteItem(
            title: "Mad Max: Fury Road",
            subtitle: "George Miller (2015)",
            imageName: "madmax",
            sceneImageName: "madmax_scene",
            rating: 5,
            description: "In a post-apocalyptic desert, Max is captured by the tyrant Immortan Joe. He is forced to escape with Furiosa and a group of runaway women. A wild chase across the wasteland begins as they search for freedom."
        ),
        FavoriteItem(
            title: "The Secret Life of Walter Mitty",
            subtitle: "Ben Stiller (2013)",
            imageName: "waltermitty",
            sceneImageName: "waltermitty_scene",
            rating: 4,
            description: "Walter Mitty, a quiet magazine employee, constantly escapes into daydreams. When an important photo negative for the cover goes missing, he has to set off on a real adventure. Along the way he finds courage he never knew he had."
        ),
        FavoriteItem(
            title: "Lion",
            subtitle: "Garth Davis (2016)",
            imageName: "lion",
            sceneImageName: "lion_scene",
            rating: 5,
            description: "Five-year-old Saroo gets lost by accident and ends up thousands of miles from home. He is adopted by a family in Australia and grows up far from his past. Many years later, his memories push him to search for his birth family."
        ),
        FavoriteItem(
            title: "Ghost Rider",
            subtitle: "Mark Steven Johnson (2007)",
            imageName: "ghostrider",
            sceneImageName: "ghostrider_scene",
            rating: 3,
            description: "Stunt rider Johnny Blaze makes a deal with the devil to save someone he loves. Now at night he transforms into a fiery spirit of vengeance. He must fight a demon who wants to gain ultimate power."
        ),
        FavoriteItem(
            title: "Men in Black",
            subtitle: "Barry Sonnenfeld (1997)",
            imageName: "meninblack",
            sceneImageName: "meninblack_scene",
            rating: 4,
            description: "A secret agency monitors the aliens who live among humans on Earth. New York cop Jay is recruited as a partner for the veteran agent Kay. Together they must stop an alien bug that threatens the whole planet."
        ),
        FavoriteItem(
            title: "Life of Pi",
            subtitle: "Ang Lee (2012)",
            imageName: "lifeofpi",
            sceneImageName: "lifeofpi_scene",
            rating: 5,
            description: "After a shipwreck, an Indian boy named Pi finds himself in a lifeboat in the middle of the ocean. His only companion is a Bengal tiger named Richard Parker. They have to survive together for many months, and the journey changes the boy forever."
        )
    ]
}
