import Foundation

extension Int: Gene {
    
}

final class IntChromosome: Chromosome {
    
    var genes: [Int]
    
    static var allowsDuplicates: Bool {
        return true
    }
    
    required init(genes: [Int]) {
        self.genes = genes
    }
    
    func fitness() -> Int {
        return genes.reduce(0) {
            return $0 + $1
        }
    }
    
    func randomMutationOnGene(gene: Int) -> Int {
        let chance = arc4random_uniform(UInt32(2))
        
        if chance == 0 {
            return gene.predecessor()
        } else {
            return gene.successor()
        }
    }
    
}

class Runner {
    
    var algorithm: GeneticAlgorithm<IntChromosome>?
    
    init() {
    }
    
    func createPopulation() -> Population<IntChromosome> {
        var chromosomes = [IntChromosome]()
        for _ in 0 ..< 100 {
            chromosomes.append(createChromosome())
        }
        
        return Population<IntChromosome>(chromosomes: chromosomes)
    }
    
    func createChromosome() -> IntChromosome {
        
        var genes = [Int]()
        
        for _ in 0 ..< 10 {
            genes.append(0)
        }
        
        let chromosome = IntChromosome(genes: genes)
        return chromosome
    }
    
    func start() {
        let initialPopulation = createPopulation()
        let algorithm = GeneticAlgorithm(initialPopulation: initialPopulation,
                                         delegate: self)
        algorithm.runSync()
    }
}

extension Runner: GeneticAlgorithmDelegate {
    func geneticAlgorithm<T: Chromosome>(algorithm: GeneticAlgorithm<T>,
                          didCompleteGeneration generation: Int,
                                                withPopulation population: Population<T>) {
        
        print("\(generation) fitness: \(population.totalFitness())")
        
        print("\(algorithm.currentTopChromosome.fitness())")
    }
}

let runner = Runner() 
runner.start()
