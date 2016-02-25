import Foundation

public protocol Crossover {
    
    var crossoverRate: Double { get set }
    
    init(crossoverRate: Double)
    
    func performCrossover<T: Hashable>(chromosomeA: [Gene<T>],
                          chromosomeB: [Gene<T>]) -> (childA: [Gene<T>], childB: [Gene<T>])
}

extension Crossover {
    
    func crossoverPopulation<T: Hashable>(parents: [[Gene<T>]]) -> [[Gene<T>]] {
        
        var firstParents = parents
        
        var children = [[Gene<T>]]()
        
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
    
    func swapDuplicates<T: Hashable>(inout genesA: [Gene<T>], inout _ genesB: [Gene<T>]) {
        
        var duplicatesA: [Gene<T>: Int] = duplicatesForGenes(genesA)
        var duplicatesB: [Gene<T>: Int] = duplicatesForGenes(genesB)
        
        while duplicatesA.count > 0 {
            
            guard let a = duplicatesA.popFirst(),let b = duplicatesB.popFirst() else {
                continue
            }
            
            genesA[a.1] = b.0
            genesB[b.1] = a.0
        }
    }
    
    func duplicatesForGenes<T: Hashable>(genes: [Gene<T>]) -> [Gene<T>: Int] {
        
        var set = Set<Gene<T>>()
        
        var duplicates: [Gene<T>: Int] = [:]

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