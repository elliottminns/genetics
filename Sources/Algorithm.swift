
import Foundation

public protocol GeneticAlgorithmDelegate {
    func geneticAlgorithm<T: Chromosome>(algorithm: GeneticAlgorithm<T>,
        didCompleteGeneration generationCount: Int,
        withPopulation population: Population<T>)
}


public class GeneticAlgorithm<T: Chromosome> {
    
    public var topPopulation: Population<T>? {
        return currentTopPopulation
    }
    
    var currentTopPopulation: Population<T>?

    var currentTopChromosome: T
    
    var topFitness: Int {
        return currentTopFitness
    }
    
    var delegate: GeneticAlgorithmDelegate
    
    var currentGeneration: Int = 0
    
    var currentTopFitness: Int = 0
    
    var currentPopulation: Population<T>
    
    var crossover: Crossover
    
    var mutationRate: Double = 1.0
    
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
    
        var topChromo = initialPopulation.chromosomes.first!
        for chromo in initialPopulation.chromosomes {
            if chromo.fitness() > topChromo.fitness() {
                topChromo = chromo
            }   
        }
        currentTopChromosome = topChromo
    }
    
    public func stop() {
        isRunning = false
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
            } while isRunning
        }
    }
    
    public func runAsync() {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.runSync()
        }
    }
    
    public func runNextGeneration() {
        let matingPool = selection.selectFromPopulation(currentPopulation)
        var children = crossover.crossoverPopulation(matingPool)
        
        for childIndex in 0 ..< children.count {
            
            for i in 0 ..< children[childIndex].genes.count {
                
                let chance = Double(arc4random_uniform(UInt32(10e5))) / 1e4
                
                if chance <= mutationRate {
                    let child = children[childIndex]
                    let gene = child.genes[i]
                    
                    children[childIndex].genes[i] = child.randomMutationOnGene(gene)
                    
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

        for chromo in currentPopulation.chromosomes {
            if chromo.fitness() > currentTopChromosome.fitness() {
                self.currentTopChromosome = chromo
            }
        }
        
        delegate.geneticAlgorithm(self, didCompleteGeneration: currentGeneration, withPopulation: population)
        currentGeneration += 1
    }
    
    
    
}
