import Foundation
import Genetics

class Algorithm {
    
    var algorithm: GeneticAlgorithm<StringChromosome>?
    
    func createPopulation() -> Population<StringChromosome> {
        
        var chromosomes = [StringChromosome]()
        
        for _ in 0 ..< 100 {
            chromosomes.append(createChromosome())
        }
        
        return Population<StringChromosome>(chromosomes: chromosomes)
    }
    
    func createChromosome() -> StringChromosome {
        
        let desired = "helloworld"
        
        var genes = [String]()
        
        for _ in 0 ..< desired.characters.count {
            genes.append("a")
        }
        
        let chromosome = StringChromosome(genes: genes)
        return chromosome
    }
    
    func start() {
        let initialPopulation = createPopulation()
        let algorithm = GeneticAlgorithm(initialPopulation: initialPopulation,
                                         delegate: self)
        algorithm.runSync()
    }
}

extension Algorithm: GeneticAlgorithmDelegate {
    func geneticAlgorithm<T: Chromosome>(algorithm: GeneticAlgorithm<T>,
                          didCompleteGeneration generation: Int,
                                                withPopulation population: Population<T>) {
        
        let top = algorithm.currentTopChromosome
        let genes = top.genes.map {
            return $0 as! String
        }
        
        let world = genes.joinWithSeparator("")
        print("\(generation): \(genes.joinWithSeparator(""))")
        
        if world == "helloworld" {
            algorithm.stop()
        }
        
    }
}

let algorithm = Algorithm()
algorithm.start()
