
import Foundation

struct PartiallyMatchedCrossover {

    var crossoverRate: Double
    
    init(crossoverRate: Double) {
        self.crossoverRate = crossoverRate
    }
}

extension PartiallyMatchedCrossover: Crossover {
    
    func performCrossover<T: Hashable>(chromosomeA: [Gene<T>], chromosomeB: [Gene<T>]) -> (childA: [Gene<T>], childB: [Gene<T>]) {
        
        let point1 = Int(arc4random_uniform(UInt32(chromosomeA.count)))
        let point2 = Int(arc4random_uniform(UInt32(chromosomeB.count)))
        
        let crossoverA = min(point1, point2)
        
        var childGenesA: [Gene<T>] = []
        var childGenesB: [Gene<T>] = []
        
        for i in 0 ..< chromosomeA.count {
            if i < crossoverA {
                childGenesA.append(chromosomeA[i])
                childGenesB.append(chromosomeB[i])
            } else {
                childGenesA.append(chromosomeB[i])
                childGenesB.append(chromosomeA[i])
            }
        }
        
        return (childA: childGenesA, childB: childGenesB)
    }
}