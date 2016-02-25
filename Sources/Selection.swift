import Foundation

public protocol Selection {
    func selectFromPopulation<T: Hashable>(population: Population<T>) -> [Chromosome<T>]
}

extension Selection {
    
    func selectRandomChromosome<T: Hashable>(population population: Population<T>) -> (chromosome: Chromosome<T>, index: Int) {
        let index = Int(arc4random_uniform(UInt32(population.chromosomes.count)))
        let chromosome = population.chromosomes[index]
        return (chromosome: chromosome, index: index)
    }
}