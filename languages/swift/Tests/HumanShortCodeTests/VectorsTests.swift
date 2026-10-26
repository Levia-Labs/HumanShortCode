import Foundation
import XCTest
@testable import HumanShortCode

final class VectorsTests: XCTestCase {
    func testVectors() throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().appendingPathComponent("spec/vectors.tsv")
        let text = try String(contentsOf: url, encoding: .utf8).replacingOccurrences(of: "\r\n", with: "\n")
        for (n, line) in text.split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            if line.isEmpty || line.hasPrefix("#") { continue }
            let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            let alpha = f[2] == "-" ? HumanShortCode.defaultAlphabet : f[2]
            let length = f[3] == "-" ? HumanShortCode.defaultLength : Int(f[3])!
            let run: () throws -> String = {
                switch f[0] {
                case "encode": return try HumanShortCode.encode(Int64(f[1])!, alphabet: alpha, length: length)
                case "decode": return String(try HumanShortCode.decode(f[1], alphabet: alpha, length: length))
                default: return String(try HumanShortCode.verify(f[1], alphabet: alpha, length: length))
                }
            }
            if f[4] == "!error" {
                XCTAssertThrowsError(try run(), "line \(n + 1)") { XCTAssertTrue("\($0)".hasPrefix("human-short-code:")) }
            } else {
                XCTAssertEqual(try run(), f[4], "line \(n + 1)")
            }
        }
    }
}
