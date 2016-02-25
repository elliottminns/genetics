import Genetics
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

/*
final class StringChromosome: Chromosome<String> {
    
    typealias GeneType = String
    
    var genes: [Gene<String>]
    
    init(genes: [Gene<T>], allowsDuplicates: Bool) {
        
    }
    
    let possibleGenes = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
                         "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                         "w", "x", "y", "z"]
    
    func fitness() -> Int {
        
        let desired = "helloworld"
        
        let string = genes.joinWithSeparator("")
        
        let chars = string.characters
        
        var fitness = 0
        
        var characterSet = Set<Character>()
        
        for char in chars {
            characterSet.insert(char)
        }
        
        for char in desired.characters {
            if characterSet.contains(char) {
                fitness += 1
            }
        }
        
        var desiredArray = desired.characters.map {
            return String($0)
        }
        
        for i in 0 ..< desiredArray.count {
            
            let desiredChar = desiredArray[i]
            
            let actualChar = genes[i]
            
            if desiredChar == actualChar {
                fitness += 100
            }
        }
        
        return fitness
    }
    
    func randomMutationOnGene(gene: String) -> String {
        
        #if os(Linux)
            let newValueIndex = Int(UInt32(rand()) % UInt32(possibleGenes.count))
        #else
            let newValueIndex = Int(arc4random_uniform(UInt32(possibleGenes.count)))
        #endif
        
        return possibleGenes[newValueIndex]
    }
    
}*/
