
import Foundation

struct PartiallyMatchedCrossover<T: Chromosome> {

    var crossoverRate: Double
    
    init(crossoverRate: Double) {
        self.crossoverRate = crossoverRate
    }
}

extension PartiallyMatchedCrossover: Crossover {
    
    func performCrossover<T: Chromosome>(chromosomeA: T, chromosomeB: T) -> (childA: T, childB: T) {
        
        let point1 = Int(arc4random_uniform(UInt32(chromosomeA.genes.count)))
        let point2 = Int(arc4random_uniform(UInt32(chromosomeB.genes.count)))
        
        let crossoverA = min(point1, point2)
        
        var childGenesA: [T.GeneType] = []
        var childGenesB: [T.GeneType] = []
        
        for i in 0 ..< chromosomeA.genes.count {
            if i < crossoverA {
                childGenesA.append(chromosomeA.genes[i])
                childGenesB.append(chromosomeB.genes[i])
            } else {
                childGenesA.append(chromosomeB.genes[i])
                childGenesB.append(chromosomeA.genes[i])
            }
        }
        
        if !T.allowsDuplicates {
            swapDuplicates(&childGenesA, &childGenesB)
        }
        
        let childA = T(genes: childGenesA)
        let childB = T(genes: childGenesB)
        
        return (childA: childA, childB: childB)
    }
}