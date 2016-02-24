public protocol Chromosome {
    
    associatedtype GeneType: Gene
    
    var genes: [GeneType] { get set }
    
    static var allowsDuplicates: Bool { get }
    
    init(genes: [GeneType])
    
    func fitness() -> Int
    
    func randomMutationOnGene(gene: GeneType) -> GeneType
}




