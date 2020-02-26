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
    
    func incrementingAllSuffixes(_ keys: [Key]) -> Self {
        Self.expand(keys: keys).reduce(self) { (result, entry) -> Self in
            return result.incrementing(entry)
        }
    }
    
    func decrementingAllSuffixes(_ keys: [Key]) -> Self {
        Self.expand(keys: keys).reduce(self) { (result, entry) -> Self in
            return result.decrementing(entry)
        }
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
        guard let firstNode = children[begin] else { return TrieMapping<Key, Int>() }
        return firstNode.paths(containing: contain, currentPath: [])
    }
    
    func ngrams(n: Int) -> TrieMapping<Key, Int> {
        if n == 0 { return TrieMapping<Key, Int>() }
        return children.values().reduce(TrieMapping<Key, Int>()) { (result, entry) -> TrieMapping<Key, Int> in
            return result.overwrite(with: entry.ngrams(n: n, currentPath: []))
        }
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

    func paths(containing element: Key, currentPath: [Key]) -> TrieMapping<Key, Int> {
        guard let sweepToPrefix = prefix.sweepTo(element) else {
            return children.values().map { $0.paths(containing: element, currentPath: currentPath + prefix) }.reduce(TrieMapping<Key, Int>()) { (result, entry) -> TrieMapping<Key, Int> in
                return result.overwrite(with: entry)
            }
        }
        return TrieMapping<Key, Int>().setting(keys: currentPath + sweepToPrefix, value: childCount)
    }
    
    func ksame(k: Int, prefixCount: Int) -> Int {
        if childCount < k { return 0 }
        return max((children.values().map { $0.ksame(k: k, prefixCount: prefixCount + prefix.count) }.max() ?? 0), prefixCount + prefix.count)
    }
    
    func ngrams(n: Int, currentPath: [Key]) -> TrieMapping<Key, Int> {
        let concatenatedPath = currentPath + prefix
        if concatenatedPath.count >= n { return TrieMapping<Key, Int>().setting(keys: Array(concatenatedPath.prefix(n)), value: childCount) }
        let childPaths = children.values().reduce(TrieMapping<Key, Int>()) { (result, entry) -> TrieMapping<Key, Int> in
            return result.overwrite(with: entry.ngrams(n: n, currentPath: concatenatedPath))
        }
        return childPaths
    }
}

public extension Array where Element: Equatable {
    func sweepTo(_ element: Element) -> Self? {
        guard let firstElement = first else { return nil }
        if firstElement == element { return [element] }
        guard let suffix = Array(self.dropFirst()).sweepTo(element) else { return nil }
        return [firstElement] + suffix
    }
}
