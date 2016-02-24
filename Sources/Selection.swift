import Foundation

public protocol Selection {
    func selectFromPopulation<T: Chromosome>(population: Population<T>) -> [T]
}

extension Selection {
    
    func selectRandomChromosome<T: Chromosome>(population population: Population<T>) -> (chromosome: T, index: Int) {
        let index = Int(arc4random_uniform(UInt32(population.chromosomes.count)))
        let chromosome = population.chromosomes[index]
        return (chromosome: chromosome, index: index)
    }
}