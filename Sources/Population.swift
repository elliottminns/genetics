struct Population<T: Chromosome> {

    let chromosomes: [T]

    init(chromosomes: [T]) {
        self.chromosomes = chromosomes       
    }
}
