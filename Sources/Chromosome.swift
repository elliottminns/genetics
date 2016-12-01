
public final class Chromosome<T: Hashable> {
    
    var genes: [Gene<T>]
    
    let allowsDuplicates: Bool
    
    let fitnessFunction: ((_ chromosome: [T]) -> Int)
    
    init(genes: [Gene<T>], allowsDuplicates: Bool, fitnessFunction: @escaping (_ chromosome: [T]) -> Int) {
        self.genes = genes
        self.allowsDuplicates = false
        self.fitnessFunction = fitnessFunction
    }
    
    public func fitness() -> Int {
        let values = self.genes.map {
            return $0.value
        }
        return self.fitnessFunction(values)
    }
}




