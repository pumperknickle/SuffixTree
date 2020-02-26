import Foundation
import Nimble
import Quick
import Bedrock
import AwesomeTrie
@testable import SuffixTree

final class SuffixTreeSpec: QuickSpec {
    override func spec() {
        describe("counts and paths") {
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
            let fst4 = fst3.incrementing(["Goodbye", "World"]).incrementing(["Hello", "Dolly"])
            let fst5 = fst4.incrementingAllSuffixes(["How", "Are", "You"])
            it("should correctly extract paths") {
                let paths = fst4.paths(begin: "Hello", contain: "World")
                expect(paths.elements().first!.1).to(equal(3))
                expect(paths.elements().first!.0).to(equal(["Hello", "World"]))
                expect(fst5[["How", "Are", "You"]]).toNot(beNil())
                expect(fst5[["Are", "You"]]).toNot(beNil())
                expect(fst5[["You"]]).toNot(beNil())

            }
        }
        describe("ksame") {
            let arrayToAnalyze = SuffixTree<String>.extractSuffixes(keys: ["1", "2", "3", "4", "1", "2", "3", "4", "3", "2", "1"])
            it("should calculate k same") {
                expect(arrayToAnalyze.ksame(k: 2)).to(equal(4))
            }
        }
        describe("sweep to") {
            let arrayToSweep = [1,2,3,4]
            it("should sweep correctly") {
                expect(arrayToSweep.sweepTo(3)).to(equal([1,2,3]))
            }
        }
    }
}

