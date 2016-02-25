
import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class GeneticAlgorithm<T: Hashable> {
    
    public var topPopulation: Population<T>? {
        return currentTopPopulation
    }
    
    var currentTopPopulation: Population<T>?

    public var currentTopChromosome: [T] {
        return topChromosome.genes.map {
            return $0.value
        }
    }
    
    var topChromosome: Chromosome<T>!
    
    var topFitness: Int {
        return currentTopFitness
    }
    
    public var fitnessFunction: ((chromosome: [T]) -> Int)?
    
    public var randomMutation: ((gene: T) -> T)?
    
    public var randomChromosome: (() -> [T])?
    
    public var onGenerationCompleted: ((generation: Int) -> ())?
    
    var currentGeneration: Int = 0
    
    var currentTopFitness: Int = 0
    
    var currentPopulation: Population<T>!
    
    public var crossover: Crossover
    
    public var selection: Selection
    
    public var mutationRate: Double = 0.02
    
    public var running: Bool {
        return isRunning
    }
    
    var isRunning = false
    
    let allowsDuplicates: Bool
    
    let populationSize: Int
    
    public init(populationSize: Int, allowsDuplicates: Bool) {
        
        selection = TournamentSelection()
        
        crossover = PartiallyMatchedCrossover(crossoverRate: 80)
        
        self.allowsDuplicates = allowsDuplicates
        
        self.populationSize = populationSize
    }
    
    public func fitnessForChromosome(chromosome: Chromosome<T>) -> Int {
        let genes = chromosome.genes.map {
            return $0.value
        }
        return self.fitnessFunction!(chromosome: genes)
    }
    
    public func setupInitial() {
        var initialPopulation = [Chromosome<T>]()
        
        for _ in 0 ..< populationSize {
            
            let genes = randomChromosome!().map {
                return Gene<T>(value: $0)
            }
            
            let chromosome = Chromosome<T>(genes: genes,
                                           allowsDuplicates: allowsDuplicates,
                                           fitnessFunction: fitnessFunction!)
            
            initialPopulation.append(chromosome)
        }
        
        let population = Population<T>(chromosomes: initialPopulation)
        currentPopulation = population
        
        topChromosome = findTopChromosomeInPopulation(population)
    }
    
    public func stop() {
        isRunning = false
    }
    
    public func runSync(desiredFitness: Int? = nil) {
        self.setupInitial()
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
        
        let mating = matingPool.map {
            return $0.genes
        }
        
        var children = crossover.crossoverPopulation(mating)
        
        for childIndex in 0 ..< children.count {
            
            for i in 0 ..< children[childIndex].count {
                
                let chance = Double(arc4random_uniform(UInt32(10e5))) / 10e5
                
                if chance <= mutationRate {
                    
                    let child = children[childIndex]
                    
                    let gene = child[i]
                    if let randomMutation = randomMutation {
                        let value = randomMutation(gene: gene.value)
                        children[childIndex][i] = Gene<T>(value: value)
                    } else {
                        
                        // Perform swap mutation
                        var newValue: Int
                        repeat {
                        #if os(Linux)
                            newValue = Int(UInt32(rand()) % UInt32(child.count))
                        #else
                            newValue = Int(arc4random_uniform(UInt32(child.count)))
                        #endif
                        } while newValue != i
                        
                        let a = child[i]
                        let b = child[newValue]
                        
                        children[childIndex][i] = b
                        children[childIndex][newValue] = a
                    }
                }
            }
        }
        
        let newPopulation = children.map {
            return Chromosome<T>(genes: $0, allowsDuplicates: self.allowsDuplicates, fitnessFunction: self.fitnessFunction!)
        }
        
        let population = Population<T>(chromosomes: newPopulation)

        currentPopulation = population

        currentGeneration += 1
        
        topChromosome = findTopChromosomeInPopulation(population)
        
        onGenerationCompleted!(generation: currentGeneration)
        
    }
    
    func findTopChromosomeInPopulation(population: Population<T>) -> Chromosome<T> {
        
        var topFitness: Int? = nil
        
        var topChromosome = population.chromosomes.first!
        
        for chromo in population.chromosomes {
            
            let genes = chromo.genes.map {
                return $0.value
            }
            
            let fitness = fitnessFunction!(chromosome: genes)
            
            if let best = topFitness {
                
                if fitness > best {
                    topFitness = fitness
                    topChromosome = chromo
                }
                
            } else {
                
                topFitness = fitness
                topChromosome = chromo
            }
        }
        return topChromosome
    }
    
    
    
}
