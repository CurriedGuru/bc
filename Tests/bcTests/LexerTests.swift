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

    func testSimpleNumericalExpression(_ actual: [LexicalToken], _ expected: [String]) {
        if case let .number(x) = actual[0], case let .number(y) = actual[2], case let .op(op) = actual[1] {
            XCTAssertEqual(x, expected[0])
            XCTAssertEqual(y, expected[2])
            XCTAssertEqual(op.rawValue, expected[1])
        } else {
           XCTFail("Unexpected output")
        }
    }

    func testSimpleVariableExpression(_ actual: [LexicalToken], _ expected: [String]) {
        if case let .variable(x) = actual[0], case let .variable(y) = actual[2], case let .op(op) = actual[1] {
            XCTAssertEqual(x, expected[0])
            XCTAssertEqual(y, expected[2])
            XCTAssertEqual(op.rawValue, expected[1])
        } else {
           XCTFail("Unexpected output")
        }
    } 

    func testSimpleExpressions() throws {
       testSimpleNumericalExpression(Lexer(input: "123+321").run(), ["123", "+", "321"])
       testSimpleNumericalExpression(Lexer(input: ".123 % 0.0").run(), [".123", "%", "0.0"])
       testSimpleNumericalExpression(Lexer(input: "119./     .19").run(), ["119.", "/", ".19"])
       testSimpleNumericalExpression(Lexer(input: ". * .").run(), [".", "*", "."])
       testSimpleNumericalExpression(Lexer(input: "8 > 10").run(), ["8", ">", "10"])
       testSimpleNumericalExpression(Lexer(input: "9.11111111==10.").run(), ["9.11111111", "==", "10."])
       testSimpleNumericalExpression(Lexer(input: "3.14^2.78").run(), ["3.14", "^", "2.78"])
       testSimpleNumericalExpression(Lexer(input: ".^.").run(), [".", "^", "."])
       testSimpleVariableExpression(Lexer(input: "abc + bcd").run(), ["abc", "+", "bcd"])
       testSimpleVariableExpression(Lexer(input: "ijk-knm").run(), ["ijk", "-", "knm"])
       testSimpleVariableExpression(Lexer(input: "a__ * b__").run(), ["a__", "*", "b__"])
       testSimpleVariableExpression(Lexer(input: "a90/a80").run(), ["a90", "/", "a80"])
       testSimpleVariableExpression(Lexer(input: "a9^a").run(), ["a9", "^", "a"])
       testSimpleVariableExpression(Lexer(input: "x = pi").run(), ["x", "=", "pi"])
       testSimpleVariableExpression(Lexer(input: "pi==ki").run(), ["pi", "==", "ki"])
       testSimpleVariableExpression(Lexer(input: "mmmm>kkkkk").run(), ["mmmm", ">", "kkkkk"])
       testSimpleVariableExpression(Lexer(input: "jack<jill").run(), ["jack", "<", "jill"])
       testSimpleVariableExpression(Lexer(input: "jack<=jill").run(), ["jack", "<=", "jill"])
       testSimpleVariableExpression(Lexer(input: "kill>=bill").run(), ["kill", ">=", "bill"])
       testSimpleVariableExpression(Lexer(input: "a__ != b__").run(), ["a__", "!=", "b__"])
       testSimpleVariableExpression(Lexer(input: "big % small").run(), ["big", "%", "small"])
       testSimpleVariableExpression(Lexer(input: "true && false").run(), ["true", "&&", "false"])
       testSimpleVariableExpression(Lexer(input: "true || true").run(), ["true", "||", "true"])
    }

    func testVariableName(_ actual: LexicalToken, _ expected: String) {
        if case let .variable(name) = actual {
            XCTAssertEqual(name, expected)
        } else {
            XCTFail("Unexpected lexical token found")
        }
    }

    func testVariableNames() throws {
        testVariableName(Lexer(input: "a").run()[0], "a")
        testVariableName(Lexer(input: "aa").run()[0], "aa")
        testVariableName(Lexer(input: "a_____").run()[0], "a_____")
        testVariableName(Lexer(input: "a12345__").run()[0], "a12345__")
        testVariableName(Lexer(input: "a_1_2_3_4_5_a").run()[0], "a_1_2_3_4_5_a")
    }
            
    static var allTests = [
        ("testNumbers", testNumbers),
        ("testiVariableNames", testVariableNames),
        ("testSimpleExpressions", testSimpleExpressions),
    ]
}
