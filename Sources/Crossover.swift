import Foundation

public protocol Crossover {
    
    var crossoverRate: Double { get set }
    
    init(crossoverRate: Double)
    
    func performCrossover<T: Chromosome>(chromosomeA: T, chromosomeB: T) -> (childA: T, childB: T)
}

extension Crossover {
    
    func crossoverPopulation<T: Chromosome>(parents: [T]) -> [T] {
        
        var firstParents = parents
        var children = [T]()
        
        let total = parents.count * 2
        
        while children.count < total {
            let indexA = Int(arc4random_uniform(UInt32(firstParents.count)))
            let parentA = firstParents.removeAtIndex(indexA)
            let indexB = Int(arc4random_uniform(UInt32(firstParents.count)))
            let parentB = firstParents.removeAtIndex(indexB)
            
            if firstParents.count <= 1 {
                firstParents = parents
            }
            
            let childs = performCrossover(parentA, chromosomeB: parentB)
            children.append(childs.childA)
            children.append(childs.childB)
        }
        
        return children
    }
    
    func swapDuplicates<U: Gene>(inout genesA: [U], inout _ genesB: [U]) {
        
        var duplicatesA: [U: Int] = duplicatesForGenes(genesA)
        var duplicatesB: [U: Int] = duplicatesForGenes(genesB)
        
        while duplicatesA.count > 0 {
            
            guard let a = duplicatesA.popFirst(),let b = duplicatesB.popFirst() else {
                continue
            }
            
            genesA[a.1] = b.0
            genesB[b.1] = a.0
        }
    }
    
    func duplicatesForGenes<U: Gene>(genes: [U]) -> [U: Int] {
        
        var set = Set<U>()
        
        var duplicates: [U: Int] = [:]

        var index = 0
        
        for gene in genes {
            
            if set.contains(gene) {
                duplicates[gene] = index
            } else {
                set.insert(gene)
            }
            index += 1
        }
        
        return duplicates
    }
}