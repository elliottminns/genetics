public struct Population<T: Hashable> {
    
    var chromosomes: [Chromosome<T>]

    init(chromosomes: [Chromosome<T>]) {
        self.chromosomes = chromosomes       
    }
}
