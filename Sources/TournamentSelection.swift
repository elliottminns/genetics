struct TournamentSelection {
    
    let size: Int = 4
    
}

extension TournamentSelection: Selection {
    
    func selectFromPopulation<T: Chromosome>(population: Population<T>) -> [T] {
        
        var pool = population;
        
        var matingPool = [T]()
        
        repeat {
            var fighters = [Int: T]()
            
            var highestFighterIndex: Int = 0
            
            var highestFighterFitness: Int = 0
            
            repeat {
                
                let randomSelection = selectRandomChromosome(population: pool)
                fighters[randomSelection.index] = randomSelection.chromosome
                
                let fitness = randomSelection.chromosome.fitness()
                
                if fitness > highestFighterFitness {
                    highestFighterFitness = fitness
                    highestFighterIndex = randomSelection.index
                }
                
            } while fighters.count < size
            
            if let highestFighter = fighters[highestFighterIndex] {
                matingPool.append(highestFighter)
                pool.chromosomes.removeAtIndex(highestFighterIndex)
            }
            
        } while matingPool.count < population.chromosomes.count / 2
    
        return matingPool
    }
}
