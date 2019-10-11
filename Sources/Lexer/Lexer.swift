public enum LexicalToken {
    case keyword(Keyword)
    case number(String)   //[0-9]*.?[0-9]*
    case string(String)   //".*"
    case variable(String) //[a-z]+[a-z0-9_]
    case op(Operator)
    case other(OtherToken)
}

public enum OtherToken: String {
    case openBracket = "("
    case closeBracket = ")"
    case semiColon = ";"
    case openBrace = "{"
    case closeBrace = "}"
}    

public enum Operator: String {
    case plus = "+"
    case increment = "++"

    case minus = "-"
    case decrement = "--"

    case multiply = "*"
    case divide = "/"
    case raisedTo = "^"

    case assign = "="
    case equalTo = "=="

    case greaterThan = ">"
    case greaterThanOrEqualTo = ">="

    case lesserThan = "<"
    case lesserThanOrEqualTo = "<="

    case not = "!"
    case notEqualTo = "!="

    case and = "&&"
    case or = "||"

    case remainder = "%"
    
}

public enum Keyword: String, CaseIterable {
    case `for` = "for"
    case `while` = "while"
    case `break` = "break" 
    case `continue` = "continue"
    case `halt` = "halt"
    case `return` = "return"
    case `if` = "if"
    case `else` = "else"
    case `define` = "define"
    case warranty = "warranty"
    case quit = "quit"
    case limits = "limits"
    case auto = "auto"
    case print = "print"
}

extension Keyword {
    public static func isKeyword(_ name: String) -> Bool {
        return Keyword.allCases.filter { $0.rawValue == name }.count != 0
    }
}

public struct Lexer {

    private var chars: [Character]

    public init(input: String) {
        self.chars = []
        for c in input {
            chars.append(c)
        }
    }

    public func run() -> [LexicalToken] {
        var tokens: [LexicalToken] = []
        var index = 0
        var multiLineCommentInProgress = false
        var singleLineCommentInProgress = false
        var numberInProgress = false
        var stringInProgress = false
        var nameInProgress = false

        var currentNumber: [Character] = []
        var currentString: [Character] = []
        var currentName: [Character] = []

        var dotVisited = false

        while index < chars.count {

            if stringInProgress == true {
                if chars[index] == "\"" {
                    stringInProgress = false
                    tokens.append(.string(String(currentString)))
                    currentString = []
                } else {
                    currentString.append(chars[index])
                }
                index = index + 1 
                continue
            }

            if multiLineCommentInProgress {
                if chars[index] == "*" && chars[index+1] == "/" {
                    index = index + 1 
                    multiLineCommentInProgress = false
                }
                index = index + 1
                continue
            }

            if singleLineCommentInProgress {
                if chars[index] == "\n" {
                    singleLineCommentInProgress = false
                }
                index = index + 1
                continue
            }

            if numberInProgress && chars[index].isNumber == false && chars[index] != "." {
                numberInProgress = false
                dotVisited = false
                tokens.append(.number(String(currentNumber)))
                currentNumber = []
            }            

            if nameInProgress && chars[index].isValidVarCharacter == false {
                nameInProgress = false
                let currentNameStr = String(currentName)
                if Keyword.isKeyword(currentNameStr) {
                    tokens.append(.keyword(Keyword(rawValue: currentNameStr)!))
                } else {
                    tokens.append(.variable(currentNameStr))
                }
                currentName = []
            }

            switch chars[index] {
            case "(":
                tokens.append(.other(.openBracket))
            case ")":
                tokens.append(.other(.closeBracket))
            case "{":
                tokens.append(.other(.openBrace))
            case "}":
                tokens.append(.other(.closeBrace))
            case ";":
                tokens.append(.other(.semiColon))
            case "+":
                if chars[index+1] == "+" {
                    tokens.append(.op(.increment))
                    index = index + 1
                } else {
                    tokens.append(.op(.plus))
                }
            case "-":
                if chars[index+1] == "-" {
                    tokens.append(.op(.decrement))
                    index = index + 1
                } else {
                    tokens.append(.op(.minus))
                }
            case "*":
                tokens.append(.op(.multiply))

            case "%":
                tokens.append(.op(.remainder))
            case "/":
                if chars[index+1] == "*" {
                    multiLineCommentInProgress = true
                    index = index + 1
                } else {
                    tokens.append(.op(.divide))
                }
            case "^":
                tokens.append(.op(.raisedTo))
            case "=":
                if chars[index + 1] == "=" {
                    index = index + 1
                    tokens.append(.op(.equalTo))
                } else {
                    tokens.append(.op(.assign))
                }
            case ">":
                if chars[index + 1] == "=" {
                    index = index + 1
                    tokens.append(.op(.greaterThanOrEqualTo))
                } else {
                    tokens.append(.op(.greaterThan))
                }
            case "<":
                if chars[index+1] == "=" {
                    index = index + 1
                    tokens.append(.op(.lesserThanOrEqualTo))
                } else {
                    tokens.append(.op(.lesserThan))
                }
            case "&":
                if chars[index+1] == "&" {
                    index = index + 1
                    tokens.append(.op(.and))
                } else {
                    //error
                }

           case "|":
               if chars[index+1] == "|" {
                   index = index + 1
                   tokens.append(.op(.or))
               } else {
                   //error
               }
            case "!":
                if chars[index+1] == "=" {
                    index = index + 1
                    tokens.append(.op(.notEqualTo))
                } else {
                    tokens.append(.op(.not))
                }
            case "#":
                singleLineCommentInProgress = true

            case ".":
                if numberInProgress && !dotVisited {
                    currentNumber.append(".")
                } else if !dotVisited {
                    currentNumber.append(".")
                    numberInProgress = true
                } else {
                    () //error
                }
                dotVisited = true

            case "_":
                if nameInProgress {
                    currentName.append("_")
                } else {
                    () //error
                }

            case "\"":
                stringInProgress = true

            case let c where c.isNumber:
                if numberInProgress {
                    currentNumber.append(c)
                } else if nameInProgress {
                    currentName.append(c) 
                } else {
                    currentNumber.append(c)
                    numberInProgress = true
                }

            case let c where c.isLetter:
                if nameInProgress && c.isLowercase {
                    currentName.append(c)
                } else if c.isLowercase {
                    currentName.append(c)
                    nameInProgress = true
                } else {
                    //error
                }

            case let c where c.isNewline:
                singleLineCommentInProgress = false

            default:
                () //error
            }
            index = index + 1
        }

        if numberInProgress {
            tokens.append(.number(String(currentNumber)))
        }

        if nameInProgress {
            let currentNameStr = String(currentName)
            if Keyword.isKeyword(currentNameStr) {
                tokens.append(.keyword(Keyword(rawValue: currentNameStr)!))
            } else {
                tokens.append(.variable(currentNameStr))
            }
        }

        return tokens
    }
}

extension Character {
    var isValidVarCharacter: Bool {
        return self.isNumber || (self.isLetter && self.isLowercase) || self == "_"
    }
}    
