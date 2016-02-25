import Genetics

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

struct City {
    let x: Int
    let y: Int
    let identifier: String
    
    func distanceFromOtherCity(city: City) -> Int {
        let x = abs(self.x - city.x)
        let y = abs(self.y - city.y)
        return y * y + x * x
    }
}

extension City: Hashable {
    var hashValue: Int {
        return identifier.hashValue
    }
}

func ==(lhs: City, rhs: City) -> Bool {
    return lhs.identifier == rhs.identifier
}

class Algorithm {
    
    //    1  2  3  4  5  6  7  8  9  10
    // 1  A                    G      O
    // 2           B
    // 3              N
    // 4                  J    F      M
    // 5     I
    // 6               E
    // 7        P
    // 8  C            K              H
    // 9
    // 10         L               D
    
    let cities = [City(x: 1, y: 1, identifier: "A"),
                  City(x: 4, y: 2, identifier: "B"),
                  City(x: 1, y: 8, identifier: "C"),
                  City(x: 9, y: 10, identifier: "D"),
                  City(x: 5, y: 6, identifier: "E"),
                  City(x: 8, y: 4, identifier: "F"),
                  City(x: 8, y: 1, identifier: "G"),
                  City(x: 10, y: 8, identifier: "H"),
                  City(x: 2, y: 5, identifier: "I"),
                  City(x: 6, y: 4, identifier: "J"),
                  City(x: 5, y: 8, identifier: "K"),
                  City(x: 3, y: 10, identifier: "L"),
                  City(x: 10, y: 4, identifier: "M"),
                  City(x: 5, y: 3, identifier: "N"),
                  City(x: 10, y: 1, identifier: "O"),
                  City(x: 3, y: 7, identifier: "P"),
        ]
    
    let num = [1,2,3,4,5,6,7]
    

    let algorithm: GeneticAlgorithm<City>
    
    init() {
        algorithm = GeneticAlgorithm<City>(populationSize: 10,
                                           allowsDuplicates: false)
        
        algorithm.fitnessFunction = { (chromosome: [City]) -> Int in
            var distance = 0
            
            
            
            
            // Smaller is better
            var previousCity: City?
            for city in chromosome {
                if let previousCity = previousCity {
                    distance -= previousCity.distanceFromOtherCity(city)
                }
                
                previousCity = city
            }
            
            let first = chromosome[0]
            
            distance -= previousCity!.distanceFromOtherCity(first)
            
            return distance
        }
        
        algorithm.randomChromosome = { () -> [City] in
            
            
            let chromosome: [City] = self.cities.sort { _, _ -> Bool in
                #if os(Linux)
                    let index = Int(UInt32(rand()) % UInt32(2))
                #else
                    let index = Int(arc4random_uniform(UInt32(2)))
                #endif
                
                return index > 0
                
            }
            
            return chromosome
        }
        
        algorithm.onGenerationCompleted = { generation in
            let identifiers = self.algorithm.currentTopChromosome.map {
                return $0.identifier
            }
            
            let fitness = self.algorithm.currentTopFitness
            
            let details = identifiers.joinWithSeparator("")
            print("\(generation): \(details) - \(fitness)")
        }
    }
    
    func run() {
        algorithm.runSync()
    }
}

let algorithm = Algorithm()
algorithm.run()
