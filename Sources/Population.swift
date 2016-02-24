public struct Population<T: Chromosome> {

    var chromosomes: [T]

    init(chromosomes: [T]) {
        self.chromosomes = chromosomes       
    }
    
    func totalFitness() -> Int {
        
        let fitness = chromosomes.reduce(0) {
            return $0 + $1.fitness()
        }
        
        return fitness
    }
}
