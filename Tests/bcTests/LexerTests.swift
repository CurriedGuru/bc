@testable import Lexer 
import XCTest

final class LexerTests: XCTestCase {

    func testNumber(_ expected: String, _ actual: LexicalToken) {
        if case let .number(x) = actual {
            XCTAssertEqual(x, expected)
        } else {
            XCTFail("Unexpected output")
        }
    }

    func testNumbers() throws {
        testNumber("123", Lexer(input: "123").run()[0])
        testNumber("123456.123456", Lexer(input: "123456.123456").run()[0])
        testNumber(".123123123", Lexer(input: ".123123123").run()[0])
        testNumber("987.", Lexer(input: "987.").run()[0])
        testNumber(".", Lexer(input: ".").run()[0])
    }

    func testSimpleExpression(_ actual: [LexicalToken], _ expected: [String]) {
        if case let .number(x) = actual[0], case let .number(y) = actual[2], case let .op(op) = actual[1] {
            XCTAssertEqual(x, expected[0])
            XCTAssertEqual(y, expected[2])
            XCTAssertEqual(op.rawValue, expected[1])
        } else {
           XCTFail("Unexpected output")
        }
    }
 
    func testSimpleExpressions() throws {
       testSimpleExpression(Lexer(input: "123+321").run(), ["123", "+", "321"])
       testSimpleExpression(Lexer(input: ".123 % 0.0").run(), [".123", "%", "0.0"])
       testSimpleExpression(Lexer(input: "119./     .19").run(), ["119.", "/", ".19"]) 
    }

    static var allTests = [
        ("testNumbers", testNumbers),
        ("testSimpleExpressions", testSimpleExpressions),
    ]
}
