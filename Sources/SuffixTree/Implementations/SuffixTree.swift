import Foundation
import Bedrock
import AwesomeDictionary
import AwesomeTrie

public struct SuffixTree<Key: DataEncodable>: Codable {
    private let rawChildren: Mapping<Key, NodeType>!
    
    public init(children: Mapping<Key, NodeType>) {
        self.rawChildren = children
    }
}

extension SuffixTree: NumberedTree {
    public typealias NodeType = NNode<Key>

    public var children: Mapping<Key, NodeType>! { return rawChildren }
}

public struct NNode<Key: DataEncodable>: Codable {
    private let rawPrefix: [Key]!
    private let rawValue: Value?
    private let rawChildren: [Mapping<Key, NNode<Key>>]!
    private let rawChildCount: Int!
}

extension NNode: NumberedNode {
    public typealias Value = Int
    public var prefix: [Key]! { return rawPrefix }
    public var value: Value? { return rawValue }
    public var children: Mapping<Key, NNode<Key>>! { return rawChildren.first! }
    public var childCount: Int! { return rawChildCount }
    
    public init(prefix: [Key], value: Value?, children: Mapping<Key, NNode<Key>>, childCount: Int) {
        self.init(rawPrefix: prefix, rawValue: value, rawChildren: [children], rawChildCount: childCount)
    }
}
