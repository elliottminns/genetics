# Genetics

A lightweight and generic Genetic Algorithm, for Swift

## Getting Started

To get started, you must have Swift 2.2 or later.

## Hello World

The best way to get started is with a Hello World example, using a genetic algorithm.

The example below will take all lower case characters `["a", "b", "c", "d" ..., "z"]` and attempts to produce the string `"helloworld"`

Using brute force, this operation as a 26^10 search space. 

With Genetics, it can find the result ~80 iterations (Depending on how lucky you are). 

### Project Setup

First, create a project repository and create a `Package.swift`

```
$ mkdir HelloGAWorld && cd HelloGAWorld

$ touch Package.swift

```

Add the repoitory to your `Package.swift` like so:

```swift
import PackageDescription

let package = Package(name: "HelloGAWorld",
    dependencies: [
        .Package(url: "https://github.com/elliottminns/genetics", majorVersion: 0)
    ]
)

```

Then create a `Sources` directory and add the following files to it:

```
$ mkdir Sources

$ touch main.swift

$ touch StringChromosome.swift
```

Then, add the following code to each file

```
main.swift
```

```swift
import Foundation
import Genetics

class Algorithm {
    
    var algorithm: GeneticAlgorithm<StringChromosome>?
    
    func createPopulation() -> Population<StringChromosome> {
        
        var chromosomes = [StringChromosome]()
        
        for _ in 0 ..< 100 {
            chromosomes.append(createChromosome())
        }
        
        return Population<StringChromosome>(chromosomes: chromosomes)
    }
    
    func createChromosome() -> StringChromosome {
        
        let desired = "helloworld"
        
        var genes = [String]()
        
        for _ in 0 ..< desired.characters.count {
            genes.append("a")
        }
        
        let chromosome = StringChromosome(genes: genes)
        return chromosome
    }
    
    func start() {
        let initialPopulation = createPopulation()
        let algorithm = GeneticAlgorithm(initialPopulation: initialPopulation,
                                         delegate: self)
        algorithm.runSync()
    }
}

extension Algorithm: GeneticAlgorithmDelegate {
    func geneticAlgorithm<T: Chromosome>(algorithm: GeneticAlgorithm<T>,
                          didCompleteGeneration generation: Int,
                                                withPopulation population: Population<T>) {
        
        let top = algorithm.currentTopChromosome
        let genes = top.genes.map {
            return $0 as! String
        }
        
        let world = genes.joinWithSeparator("")
        print("\(generation): \(genes.joinWithSeparator(""))")
        
        if world == "helloworld" {
            algorithm.stop()
        }
        
    }
}

let algorithm = Algorithm()

algorithm.start()

```

```
StringChromosome.swift
```

```swift
import Genetics

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

extension String: Gene {}

final class StringChromosome: Chromosome {
    
    var genes: [String]
    
    static var allowsDuplicates: Bool {
        return false
    }
    
    required init(genes: [String]) {
        self.genes = genes
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
    
}
```

Then run and see the results. 

```
0: aaaaaaoaaa
1: aaaaaaoaaa
2: aaaaaaoaaa
3: aeaaxaoaaa
4: aeaaxaoaaa
5: aeaaaaoada
6: aeahxaoaad
7: tedhaaoraa
8: leaaaaoaad
9: aeahaaorad
10: leahaaorad
11: leahaaorad
12: leahaaorad
13: leahaaorad
14: leahaaorad
15: leahaaorad
16: aefhaaorld
17: aefhaaorld
18: aefhaaorld
19: aefhaaorld
20: aefhaaorld
21: aefhaaorld
22: aefhaaorld
23: aefhaaorld
24: aefhaaorld
25: wefhaaorld
26: lelhaaorld
27: veahaworld
28: veahaworld
29: veahaworld
30: veahaworld
31: veahaworld
32: veahaworld
33: veahaworld
34: veahaworld
35: veahaworld
36: welhaworld
37: welhaworld
38: welhaworld
39: welhaworld
40: welhaworld
41: welhaworld
42: welhaworld
43: uellaworld
44: uellaworld
45: uellaworld
46: lelhoworld
47: lelhoworld
48: lelhoworld
49: lelhoworld
50: lelhoworld
51: lelhoworld
52: lelhoworld
53: lelhoworld
54: velloworld
55: velloworld
56: velloworld
57: velloworld
58: velloworld
59: velloworld
60: velloworld
61: velloworld
62: velloworld
63: velloworld
64: velloworld
65: velloworld
66: velloworld
67: velloworld
68: velloworld
69: velloworld
70: velloworld
71: hellhworld
72: hellhworld
73: hellhworld
74: hellhworld
75: hellhworld
76: hellhworld
77: hellhworld
78: hellhworld
79: hellhworld
80: hellhworld
81: helloworld
```

Pretty neat :)

See the Wiki for more details on how to set up other projects. 
