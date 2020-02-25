import Foundation
import AwesomeTrie
import AwesomeDictionary

public protocol NumberedTree: Trie where NodeType: NumberedNode { }

public extension NumberedTree {
    func incrementing(_ keys: [Key]) -> Self {
        let currentVal = self[keys] ?? 0
        return setting(keys: keys, value: currentVal + 1)
    }
       
    func decrementing(_ keys: [Key]) -> Self {
        guard let currentVal = self[keys] else { return self }
        return setting(keys: keys, value: currentVal - 1)
    }
    
    static func extractSuffixes(keys: [Key]) -> Self {
        return create(keys: expand(keys: keys))
    }
    
    static func expand(keys: [Key]) -> [[Key]] {
        if keys.count == 0 { return [] }
        return [keys] + expand(keys: Array(keys.dropFirst()))
    }
    
    static func create(keys: [[Key]]) -> Self {
        return Self().create(keys: keys)
    }
    
    func create(keys: [[Key]]) -> Self {
        guard let firstKey = keys.first else { return self }
        return incrementing(firstKey).create(keys: Array(keys.dropFirst()))
    }
    
    func ksame(k: Int) -> Int {
        return children.values().map { $0.ksame(k: k, prefixCount: 0) }.max() ?? 0
    }
    
    func paths(begin: Key, contain: Key) -> TrieMapping<Key, Int> {
        
    }
}

public protocol NumberedNode: AwesomeTrie.Node where Value == Int {
    var childCount: Int! { get }
    
    init(prefix: [Key], value: Value?, children: Mapping<Key, Self>, childCount: Int)
}

public extension NumberedNode {
    init(prefix: [Key], value: Value?, children: Mapping<Key, Self>) {
        let count = children.values().map { $0.childCount }.reduce(0, +)
        self.init(prefix: prefix, value: value, children: children, childCount: count + (value ?? 0))
    }
    
    func ksame(k: Int, prefixCount: Int) -> Int {
        if childCount < k { return 0 }
        return max((children.values().map { $0.ksame(k: k, prefixCount: prefixCount + prefix.count) }.max() ?? 0), prefixCount + prefix.count)
    }
}
