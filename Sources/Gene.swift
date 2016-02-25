public struct Gene<T: Hashable> : Hashable {
    public let value: T
    
    public init(value: T) {
        self.value = value
    }
    
    public var hashValue: Int {
        return value.hashValue
    }
}

public func ==<T: Hashable>(lhs: Gene<T>, rhs: Gene<T>) -> Bool {
    return lhs.value == rhs.value
}