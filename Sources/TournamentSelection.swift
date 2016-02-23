struct TournamentSelection {
    
}

extension TournamentSelection: Selection {
    func selectFromPopulation<T>(population: Population<T>) -> Population<T> {
        return population
    }
}
