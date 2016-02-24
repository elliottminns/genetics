
import Foundation

public protocol GeneticAlgorithmDelegate {
    func geneticAlgorithm<T>(algorithm: GeneticAlgorithm<T>,
                          didCompleteGeneration generationCount: Int,
                                                withPopulation population: Population<T>)
}


public class GeneticAlgorithm<T: Chromosome> {
    
    public var topPopulation: Population<T>? {
        return currentTopPopulation
    }
    
    var currentTopPopulation: Population<T>?
    
    var topFitness: Int {
        return currentTopFitness
    }
    
    var delegate: GeneticAlgorithmDelegate
    
    var currentGeneration: Int = 0
    
    var currentTopFitness: Int = 0
    
    var currentPopulation: Population<T>
    
    var crossover: Crossover
    
    var mutationRate: Double = 0.005
    
    public var selection: Selection
    
    public var running: Bool {
        return isRunning
    }
    
    var isRunning = false
    
    public init(initialPopulation: Population<T>, delegate: GeneticAlgorithmDelegate) {
        selection = TournamentSelection()
        crossover = PartiallyMatchedCrossover<T>(crossoverRate: 80)
        currentPopulation = initialPopulation
        self.delegate = delegate
    }
    
    public func runSync(desiredFitness: Int? = nil) {
        isRunning = true

        if let desiredFitness = desiredFitness {
            repeat {
                runNextGeneration()
            } while topFitness < desiredFitness
        } else {
            repeat {
                runNextGeneration()
            } while true
        }
    }
    
    public func runAsync() {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.runSync()
        }
    }
    
    public func runNextGeneration() {
        let matingPool = selection.selectFromPopulation(currentPopulation)
        let children = crossover.crossoverPopulation(matingPool)
        
        for child in children {
            for gene in child.genes {
                let chance = Double(arc4random_uniform(UInt32(10e5))) / 1e4
                if chance <= mutationRate {
                    child.randomMutationOnGene(gene)
                }
            }
        }
        
        let population = Population<T>(chromosomes: children)
        currentPopulation = population
        let fitness = currentPopulation.totalFitness()
        if fitness > currentTopFitness {
            currentTopPopulation = currentPopulation
            currentTopFitness = fitness
        }
        
        delegate.geneticAlgorithm(self, didCompleteGeneration: currentGeneration, withPopulation: population)
        currentGeneration += 1
    }
    
    
    
}
