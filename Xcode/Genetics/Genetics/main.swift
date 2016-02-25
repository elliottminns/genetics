import Foundation

import Genetics

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

final class Algorithm {
    
    let possibleGenes = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
                         "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                         "w", "x", "y", "z"]
    
    let algorithm = GeneticAlgorithm<String>(populationSize: 50, allowsDuplicates: false)
    
    init() {
        
        algorithm.fitnessFunction = { (chromosome: [String]) -> Int in
            
            let desired = "helloworld"
            
            let string = chromosome.joinWithSeparator("")
            
            let chars = string.characters
            
            var fitness = 0
            
            var characterSet = Set<Character>()
            
            for char in chars {
                characterSet.insert(char)
            }
            
            for char in desired.characters {
                if characterSet.contains(char) {
                    fitness += 1
                }
            }
            
            var desiredArray = desired.characters.map {
                return String($0)
            }
            
            for i in 0 ..< desiredArray.count {
                
                let desiredChar = desiredArray[i]
                
                let actualChar = chromosome[i]
                
                if desiredChar == actualChar {
                    fitness += 100
                }
            }
            
            return fitness
        }
        
        algorithm.randomMutation = { (gene: String) -> String in
            #if os(Linux)
                let newValueIndex = Int(UInt32(rand()) % UInt32(possibleGenes.count))
            #else
                let newValueIndex = Int(arc4random_uniform(UInt32(self.possibleGenes.count)))
            #endif
            
            return self.possibleGenes[newValueIndex]
        }
        
        algorithm.randomChromosome = { () -> [String] in
        
            let length = "helloworld".characters.count
            
            var chromosome: [String] = []
            
            for _ in 0 ..< length {
                chromosome.append("a")
            }
            
            return chromosome
        }
        
        algorithm.onGenerationCompleted = { generation in
            let details = self.algorithm.currentTopChromosome.joinWithSeparator("")
            print("\(generation): \(details)")
            if details == "helloworld" {
                self.algorithm.stop()
            }
        }
    }
    
    func run() {
        algorithm.runSync()
    }
}

let algorithm = Algorithm()
algorithm.run()
