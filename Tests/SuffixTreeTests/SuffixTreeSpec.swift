import Foundation
import Nimble
import Quick
import Bedrock
import AwesomeTrie
@testable import SuffixTree

final class SuffixTreeSpec: QuickSpec {
    override func spec() {
        describe("getting counts") {
            let fst = SuffixTree<String>()
            let fst1 = fst.incrementing(["Hello", "World"])
            it("should have 1 count") {
                expect(fst1.children.values().first!.childCount).to(equal(1))
            }
            let fst2 = fst1.incrementing(["Hello", "World", "My Friends!"])
            it("should have 2 count") {
                expect(fst2.children.values().first!.childCount).to(equal(2))
            }
            let fst3 = fst2.incrementing(["Hello", "World", "My Friends!"])
            it("should have 3 count") {
                expect(fst3.children.values().first!.childCount).to(equal(3))
            }
        }
        describe("ksame") {
            let arrayToAnalyze = SuffixTree<String>.extractSuffixes(keys: ["1", "2", "3", "4", "1", "2", "3", "4", "3", "2", "1"])
            it("should calculate k same") {
                expect(arrayToAnalyze.ksame(k: 2)).to(equal(4))
            }
        }
    }
}

