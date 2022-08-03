//import UnicodeData
import Foundation

let letters = NSCharacterSet.letters
let digits = NSCharacterSet.decimalDigits

public extension String {
    subscript(range: NSRange) -> Substring {
        get {
            if range.location == NSNotFound {
                return ""
            } else {
                let swiftRange = Range(range, in: self)!
                return self[swiftRange]
            }
        }
    }

    /// Title-cased string is a string that has the first letter of each word capitalised (except for prepositions, articles and conjunctions)
    var localizedTitleCasedString: String {
        var newStr: String = ""

        // create linguistic tagger
        let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
        let range = NSRange(location: 0, length: self.utf16.count)
        tagger.string = self

        // enumerate linguistic tags in string
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: []) { tag, tokenRange, _ in
            let word = self[tokenRange]

            guard let tag = tag else {
                newStr.append(contentsOf: word)
                return
            }

            // conjunctions, prepositions and articles should remain lowercased
            if tag == .conjunction || tag == .preposition || tag == .determiner {
                newStr.append(contentsOf: word.localizedLowercase)
            } else {
                // any other words should be capitalized
                newStr.append(contentsOf: word.localizedCapitalized)
            }
        }
        return newStr
    }
}

extension Character {
    public init(_ i: Int) {
        self.self = Character(UnicodeScalar(i)!)
    }
}
extension Character {

    var unicode: Unicode.Scalar {
        return self.unicodeScalars.first!
    }
    var properties: Unicode.Scalar.Properties {
        return self.unicode.properties
    }
    public var uppercaseMapping: String {
        return self.properties.uppercaseMapping
    }
    public var lowercaseMapping: String {
        return self.properties.lowercaseMapping
    }
    public var titlecaseMapping: String {
        return self.properties.titlecaseMapping
    }
    public func toUpper() -> Character {
        return Character(self.uppercaseMapping)
    }
    public func toLower() -> Character {
        return Character(self.lowercaseMapping)
    }
    public func toTitle() -> Character {
        return Character(self.titlecaseMapping)
    }
    public var isTitlecase: Bool {
        return properties.generalCategory == .titlecaseLetter
    }
    public func isdecimal() -> Bool {
        return self.properties.generalCategory == .decimalNumber
    }
    public func isdigit() -> Bool {
        if let numericType = self.properties.numericType {
            return numericType == .decimal || numericType == .digit
        }
        return false
    }
}


extension String {
    func at(_ i: Int) -> Character? {
        if self.count > i {
            return self[self.index(self.startIndex, offsetBy: i)]
        }
        return nil
    }
    public func capitalize() -> String {
        if let f = first {
            return f.titlecaseMapping + dropFirst().lowercased()
        }
        return self
    }
    public func casefold() -> String {
        return map { casefoldTable[$0.unicode.value, default: String($0)] }.joined()
    }
    /*public func center(_ width: Int, fillchar: Character = " ") -> String {
        if self.count >= width {
            return self
        }
        let left = width - self.count
        let right = left / 2 + left % 2
        return fillchar * (left - right) + self + fillchar * right
    }*/
    /*public func count(_ sub: String, start: Int? = nil, end: Int? = nil) -> Int {
        let (s, e) = adjustIndex(start, end)
        if (e - s < sub.count) { return 0 }
        if sub.isEmpty {
            return Swift.max(e - s, 0) + 1
        }
        var n = find(sub, start: s, end: e)
        var c = 0
        while n != -1 {
            c += 1
            n = find(sub, start: n + sub.count, end: e)
        }
        return c
    }
    public func endswith(_ suffix: String, start: Int? = nil, end: Int? = nil) -> Bool {
        let (s, e) = adjustIndex(start, end)
        if (e - s < suffix.count) { return false }
        return suffix.isEmpty || slice(start: s, end: e).hasSuffix(suffix)
    }
    public func endswith(_ suffixes: [String], start: Int? = nil, end: Int? = nil) -> Bool {
        return suffixes.contains(where: { endswith($0, start: start, end: end) })
    }
    public func expandtabs(_ tabsize: Int = 8) -> String {
        var buffer = ""
        buffer.reserveCapacity(count + count("\t") * tabsize)
        var linePos = 0
        for ch in self {
            if (ch == "\t") {
                if (tabsize > 0) {
                    let incr = tabsize - (linePos % tabsize)
                    linePos += incr
                    buffer.append(" " * incr)
                }
            } else {
                linePos += 1
                buffer.append(ch)
                if (ch == "\n" || ch == "\r" || ch == "\r\n") {
                    linePos = 0
                }
            }
        }
        return buffer
    }

    public func find(_ sub: String, start: Int? = nil, end: Int? = nil) -> Int {
        let (s, e) = adjustIndex(start, end)
        if (e - s < sub.count) { return -1 }
        if sub.isEmpty {
            return s
        }
        let start = index(startIndex, offsetBy: s)
        let end = index(startIndex, offsetBy: e)
        if let range = range(of: sub, options: .init(), range: start..<end) {
            return distance(from: startIndex, to: range.lowerBound)
        }
        return -1
    }
    public func index(_ sub: String, start: Int? = nil, end: Int? = nil) throws -> Int {
        let i = self.find(sub, start: start, end: end)
        if i == -1 {
            throw PyException.ValueError("substring not found")
        }
        return i
    }
    */
    
    private func isX(_ conditional: (Character) -> Bool, empty: Bool) -> Bool {
        if self.isEmpty {
            return empty
        }
        return self.allSatisfy({ conditional($0) })
    }
    

    public func isalnum() -> Bool {
        let alphaTypes: [Unicode.GeneralCategory] = [.modifierLetter, .titlecaseLetter, .uppercaseLetter, .lowercaseLetter, .otherLetter, .decimalNumber]
        return self.isX({ (chr) -> Bool in
            return alphaTypes.contains(chr.properties.generalCategory) || chr.properties.numericType != nil
        }, empty: false)
    }

    public func isalpha() -> Bool {
        let alphaTypes: [Unicode.GeneralCategory] = [.modifierLetter, .titlecaseLetter, .uppercaseLetter, .lowercaseLetter, .otherLetter]
        return self.isX({ (chr) -> Bool in
            return alphaTypes.contains(chr.properties.generalCategory)
        }, empty: false)
    }

    public func isascii() -> Bool {
        return self.isX({ (chr) -> Bool in
            return 0 <= chr.unicode.value && chr.unicode.value <= 127
        }, empty: true)
    }

    public func isdecimal() -> Bool {
        return self.isX({ (chr) -> Bool in
            return chr.properties.generalCategory == .decimalNumber
        }, empty: false)
    }

    public func isdigit() -> Bool {
        return self.isX({ (chr) -> Bool in
            if let numericType = chr.properties.numericType {
                return numericType == .decimal || numericType == .digit
            }
            return false
        }, empty: false)
    }
    public func islower() -> Bool {
        if self.isEmpty {
            return false
        }
        var hasCase = false
        for chr in self {
            if chr.isCased {
                if !chr.isLowercase {
                    return false
                }
                hasCase = true
            }
        }
        return hasCase
    }

    public func isnumeric() -> Bool {
        return self.isX({ (chr) -> Bool in
            return chr.properties.numericType != nil
        }, empty: false)
    }

    public func isprintable() -> Bool {
        let otherTypes: [Unicode.GeneralCategory] = [.otherLetter, .otherNumber, .otherSymbol, .otherPunctuation]
        let separatorTypes: [Unicode.GeneralCategory] = [.lineSeparator, .spaceSeparator, .paragraphSeparator]
        let maybeDisPrintable = otherTypes + separatorTypes
        return self.isX({ (chr) -> Bool in
            if maybeDisPrintable.contains(chr.properties.generalCategory) {
                return chr == " "
            }
            return true
        }, empty: true)
    }

    public func isspace() -> Bool {
        return self.isX({ (chr) -> Bool in
            // TODO:unicode propaty
            return chr.isWhitespace
        }, empty: false)
    }
    public func istitle() -> Bool {
        if isEmpty {
            return false
        }
        var cased = false
        var previousIsCased = false
        for ch in self {
            if (ch.isUppercase || ch.isTitlecase) {
                if (previousIsCased) {
                    return false
                }
                previousIsCased = true
                cased = true
            } else if (ch.isLowercase) {
                if (!previousIsCased) {
                    return false
                }
                previousIsCased = true
                cased = true
            }
            else {
                previousIsCased = false
            }
        }
        return cased
    }
    public func isupper() -> Bool {
        if self.isEmpty {
            return false
        }
        var hasCase = false
        for chr in self {
            if chr.isCased {
                if !chr.isUppercase {
                    return false
                }
                hasCase = true
            }
        }
        return hasCase
    }
    public func join(_ iterable: [String]) -> String {
        return iterable.joined(separator: self)
    }
    public func join<T: Sequence>(_ iterable: T) -> String where T.Element == Character {
        return String(iterable.reduce(into: "") { (result, char) in
                result.append(char)
                result.append(self)
            }.dropLast(count))
    }
    public func join<T: Sequence, U: StringProtocol>(_ iterable: T) -> String where T.Element == U {
        return String(iterable.reduce(into: "") { (result, char) in
                result.append(contentsOf: char)
                result.append(self)
            }.dropLast(count))
    }
    /*public func rjust(_ width: Int, fillchar: Character = " ") -> String {
        if self.count >= width {
            return self
        }
        let w = width - self.count
        return fillchar * w + self
    }*/
    public func lower() -> String {
        return self.lowercased()
    }
    public func lstrip(_ chars: String? = nil) -> String {
        if let chars = chars {
            return String(drop(while: { chars.contains($0) }))
        }
        return String(drop(while: { $0.isWhitespace }))
    }
    static public func maketrans(_ x: [UInt32: String?]) -> [Character: String] {
        var _x: [Character: String?] = [:]
        for (key, value) in x {
            _x[Character(UnicodeScalar(key)!)] = value
        }
        return maketrans(_x)
    }
    static public func maketrans(_ x: [Character: String?]) -> [Character: String] {
        var cvTable: [Character: String] = [:]
        for (key, value) in x {
            cvTable[key] = value ?? ""
        }
        return cvTable
    }
    static public func maketrans(_ x: String, y: String, z: String = "") -> [Character: String] {
        var cvTable: [Character: String] = [:]
        let loop: Int = Swift.max(x.count, y.count)
        for i in 0..<loop {
            cvTable[x[i]] = String(y[i])
        }
        for chr in z {
            cvTable[chr] = ""
        }
        return cvTable
    }
    /*public func partition(_ sep: String) -> (String, String, String) {
        let tmp = self.split(sep, maxsplit: 1)
        if tmp.count == 1 {
            return (self, "", "")
        }
        return (tmp[0], sep, tmp[1])
    }*/

    /// If the string ends with the suffix string and that suffix is not empty, return string[null, -suffix.count].
    /// Otherwise, return a copy of the original string.
    /*public func removesuffix(_ suffix: String) -> String {
        if endswith(suffix) {
            return String(dropLast(suffix.count))
        }
        return self
    }

    /// If the string starts with the prefix string, return string[prefix.count, null].
    /// Otherwise, return a copy of the original string.
    public func removeprefix(_ prefix: String) -> String {
        if startswith(prefix) {
            return String(dropFirst(prefix.count))
        }
        return self
    }*/

    /*public func replace(_ old: String, new: String, count: Int = Int.max) -> String {
        if old.isEmpty {
            if isEmpty {
                if count == .zero {
                    return ""
                }
                return new
            }
            return repleceEmpty(to: new, count: count)
        }
        return new.join(split(old, maxsplit: count))
    }
    func repleceEmpty(to new: String, count: Int) -> String {
        if count == .zero {
            return self
        }
        var count = 0 < count ? count : .max
        var buffer = new
        for c in self {
            buffer.append(c)
            count--
            if count > 0 {
                buffer += new
            }
        }
        return buffer
    }
    public func rfind(_ sub: String, start: Int? = nil, end: Int? = nil) -> Int {
        let (s, e) = adjustIndex(start, end)
        if (e - s < sub.count) { return -1 }
        if sub.isEmpty {
            return count
        }
        let start = index(startIndex, offsetBy: s)
        let end = index(startIndex, offsetBy: e)
        if let range = range(of: sub, options: .backwards, range: start..<end) {
            return distance(from: startIndex, to: range.lowerBound)
        }
        return -1
    }
    public func rindex(_ sub: String, start: Int? = nil, end: Int? = nil) throws -> Int {
        let i = self.rfind(sub, start: start, end: end)
        if i == -1 {
            throw PyException.ValueError("substring not found")
        }
        return i
    }
    public func ljust(_ width: Int, fillchar: Character = " ") -> String {
        if self.count >= width {
            return self
        }
        let w = width - self.count
        return self + fillchar * w
    }

    public func rpartition(_ sep: String) -> (String, String, String) {
        let tmp = self._rsplit(sep, maxsplit: 1)
        if tmp.count == 1 {
            return ("", "", self)
        }
        return (tmp[0], sep, tmp[1])
    }
    func _rsplit(_ sep: String, maxsplit: Int) -> [String] {
        if self.isEmpty {
            return [self]
        }
        if sep.isEmpty {
            // error
            return self._rsplit(maxsplit: maxsplit)
        }
        var result: [String] = []
        var index = 0, prev_index = Int.max, sep_len = sep.count
        var maxsplit = maxsplit
        if maxsplit < 0 {
            maxsplit = Int.max
        }
        while maxsplit != 0 {
            index = self.rfind(sep, end: prev_index)
            if index == -1 {
                break
            }
            index += sep_len
            result.insert(String(slice(start: index, end: prev_index)), at: 0)
            index -= sep_len

            index -= 1
            prev_index = index + 1

            maxsplit -= 1

            if maxsplit == 0 {
                break
            }
        }
        result.insert(String(slice(start: 0, end: prev_index)), at: 0)
        return result
    }
    func _rsplit(maxsplit: Int) -> [String] {
        let maxsplit = maxsplit >= 0 ? maxsplit : .max
        return "".join(reversed()).split(maxSplits: maxsplit, omittingEmptySubsequences: true, whereSeparator: { $0.isWhitespace }).map { "".join(String($0).lstrip().reversed()) }.filter { !$0.isEmpty }.reversed()
    }
    public func rsplit(_ sep: String? = nil, maxsplit: Int = (-1)) -> [String] {
        if let sep = sep {
            return self._rsplit(sep, maxsplit: maxsplit)
        }
        return self._rsplit(maxsplit: maxsplit)
    }
    public func rstrip(_ chars: String? = nil) -> String {
        if let chars = chars {
            return "".join(reversed().drop(while: { chars.contains($0) }).reversed())
        }
        return "".join(reversed().drop(while: { $0.isWhitespace }).reversed())
    }
    func _split(_ sep: String, maxsplit: Int) -> [String] {
        if self.isEmpty {
            return [self]
        }
        if sep.isEmpty {
            // error
            return self._split(maxsplit: maxsplit)
        }
        var maxsplit = maxsplit
        var result: [String] = []
        if maxsplit < 0 {
            maxsplit = Int.max
        }
        var index = 0, prev_index = 0, sep_len = sep.count
        while maxsplit != 0 {
            index = self.find(sep, start: prev_index)
            if index == -1 {
                break
            }
            result.append(String(slice(start: prev_index, end: index)))
            prev_index = index + sep_len

            maxsplit -= 1
        }

        result.append(String(slice(start: prev_index, end: nil)))

        return result
    }
    func _split(maxsplit: Int) -> [String] {
        let maxsplit = maxsplit >= 0 ? maxsplit : .max
        return split(maxSplits: maxsplit, omittingEmptySubsequences: true, whereSeparator: { $0.isWhitespace }).map { String($0).lstrip() }.filter { !$0.isEmpty }
    }
    public func split(_ sep: String? = nil, maxsplit: Int = (-1)) -> [String] {
        if let sep = sep {
            return self._split(sep, maxsplit: maxsplit)
        }
        return self._split(maxsplit: maxsplit)
    }
    public func splitlines(_ keepends: Bool = false) -> [String] {
        let lineTokens = "\n\r\r\n\u{0b}\u{0c}\u{1c}\u{1d}\u{1e}\u{85}\u{2028}\u{2029}"
        var len = self.count, i = 0, j = 0, eol = 0
        var result: [String] = []
        while i < len {
            while i < len && !lineTokens.contains(self[i]) {
                i += 1
            }
            eol = i
            if i < len {
                i += 1
                if keepends {
                    eol = i
                }
            }
            result.append(String(slice(start: j, end: eol)))
            j = i
        }
        if j < len {
            result.append(String(slice(start: j, end: eol)))
        }
        return result
    }
    public func startswith(_ prefix: String, start: Int? = nil, end: Int? = nil) -> Bool {
        let (s, e) = adjustIndex(start, end)
        if (e - s < prefix.count) { return false }
        return prefix.isEmpty || slice(start: s, end: e).hasPrefix(prefix)
    }
    public func startswith(_ prefixes: [String], start: Int? = nil, end: Int? = nil) -> Bool {
        return prefixes.contains(where: { startswith($0, start: start, end: end) })
    }

    public func strip(_ chars: String? = nil) -> String {
        return self.lstrip(chars).rstrip(chars)
    }
    public func swapcase() -> String {
        var swapped = ""
        for chr in self {
            if chr.isASCII {
                if chr.isUppercase {
                    swapped.append(chr.lowercaseMapping)
                } else if chr.isLowercase {
                    swapped.append(chr.uppercaseMapping)
                } else {
                    swapped.append(chr)
                }
            } else {
                swapped.append(chr)
            }
        }
        return swapped
    }
    */
    
    public func title() -> String {
        var titled = ""
        var prev_cased = false
        for chr in self {
            if !prev_cased {
                if !chr.isTitlecase {
                    titled.append(chr.titlecaseMapping)
                } else {
                    titled.append(chr)
                }
            } else {
                if chr.isCased {
                    if !chr.isLowercase {
                        titled.append(chr.lowercaseMapping)
                    } else {
                        titled.append(chr)
                    }
                } else {
                    titled.append(chr)
                }
            }
            prev_cased = chr.isCased
        }
        return titled
    }
    public func translate(_ table: [Character: String]) -> String {
        return map { table[$0, default: String($0)] }.joined()
    }
    public func upper() -> String {
        return self.uppercased()
    }
    /*public func zfill(_ width: Int) -> String {
        if !isEmpty {
            if let h = first, h == "+" || h == "-" {
                return "\(h)\(String(dropFirst()).rjust(width - 1, fillchar: "0"))"
            }
        }
        return rjust(width, fillchar: "0")
    }*/
}

struct UnicodeData {
    typealias CaseMapping=String
    
    static func toLowercase(_ element: UnicodeScalar) -> CaseMapping {
        return String(element).lowercased()
    }
    
    static func toUppercase(_ element: UnicodeScalar) -> CaseMapping {
        return String(element).uppercased()
    }
    
    static func toTitlecase(_ element: UnicodeScalar) -> CaseMapping {
        return String(element).localizedTitleCasedString
    }
    
    static func toCasefold(_ element: UnicodeScalar) -> CaseMapping {
        return String(element).casefold()
    }
    
    static func isWhitespace(_ element: UnicodeScalar) -> Bool {
        return element.properties.isWhitespace
    }
    
    static func isLineBreak(_ element: UnicodeScalar) -> Bool {
        return element.properties.generalCategory == .lineSeparator
    }
    
    static func isAlphaNumeric(_ element: UnicodeScalar) -> Bool {
        //return element.properties.isAlphaNumeric
        //return letters.longCharacterIsMember(element.value) || digits.longCharacterIsMember(element.value)
        return isAlpha(element) || isNumeric(element)
    }
    
    static func isAlpha(_ element: UnicodeScalar) -> Bool {
        //return element.properties.isAlpha
        //return element.properties.isASCII
        return isMember(of: alphaSet, element)
    }
    
    static func isDecimalDigit(_ element: UnicodeScalar) -> Bool {
        //return element.properties.isDecimalDigit
        return "0123456789".contains(String(element))
    }
    
    static func isDigit(_ element: UnicodeScalar) -> Bool {
        return element.properties.generalCategory == .decimalNumber
    }
    
    static func isCased(_ element: UnicodeScalar) -> Bool {
        return element.properties.isCased
    }
    
    static func isLowercase(_ element: UnicodeScalar) -> Bool {
        return element.properties.isLowercase
    }
    
    static func isUppercase(_ element: UnicodeScalar) -> Bool {
        return element.properties.isUppercase
    }
    
    static func isNumeric(_ element: UnicodeScalar) -> Bool {
        return element.properties.numericType != nil
    }
    
    static func isTitlecase(_ element: UnicodeScalar) -> Bool {
        return element.properties.generalCategory == .titlecaseLetter
    }
    
    static func isPrintable(_ element: UnicodeScalar) -> Bool {
        //return element.properties.isPrintable
        return true //?
    }
    
    /// Return `true` if `self` normalized contains a single code unit that is a member of the supplied character set.
    ///
    /// - parameter set: The `CharacterSet` used to test for membership.
    /// - returns: `true` if `self` normalized contains a single code unit that is a member of the supplied character set.
    static func isMember(of set: CharacterSet, _ element: UnicodeScalar) -> Bool {
        
        let normalized = String(element).precomposedStringWithCanonicalMapping
        let unicodes = normalized.unicodeScalars
        
        guard unicodes.count == 1 else { return false }
        
        return set.contains(unicodes.first!)
        
    }
}

private let uppercaseSet = CharacterSet.uppercaseLetters
private let lowercaseSet = CharacterSet.lowercaseLetters
private let alphaSet = CharacterSet.letters
private let alphaNumericSet = CharacterSet.alphanumerics
private let symbolSet = CharacterSet.symbols
private let digitSet = CharacterSet.decimalDigits

extension Character {
    
    /// The first `UnicodeScalar` of `self`.
    var unicodeScalar: UnicodeScalar {
        
        let unicodes = String(self).unicodeScalars
        return unicodes[unicodes.startIndex]
        
    }
    
    /// True for any space character, and the control characters \t, \n, \r, \f, \v.
    var isSpace: Bool {
        
        switch self {
            
        case " ", "\t", "\n", "\r", "\r\n": return true
            
        case "\u{000B}", "\u{000C}": return true // Form Feed, vertical tab
           
        default: return false
            
        }
        
    }
    
    /// True for any Unicode space character, and the control characters \t, \n, \r, \f, \v.
    var isUnicodeSpace: Bool {
        
        switch self {
            
        case " ", "\t", "\n", "\r", "\r\n": return true
            
        case "\u{000C}", "\u{000B}", "\u{0085}": return true // Form Feed, vertical tab, next line (nel)
            
        case "\u{00A0}", "\u{1680}", "\u{180E}": return true // No-break space, ogham space mark, mongolian vowel
            
        case "\u{2000}"..."\u{200D}": return true // En quad, em quad, en space, em space, three-per-em space, four-per-em space, six-per-em space, figure space, ponctuation space, thin space, hair space, zero width space, zero width non-joiner, zero width joiner.
        case "\u{2028}", "\u{2029}": return true // Line separator, paragraph separator.
            
        case "\u{202F}", "\u{205F}", "\u{2060}", "\u{3000}", "\u{FEFF}": return true // Narrow no-break space, medium mathematical space, word joiner, ideographic space, zero width no-break space.
            
        default: return false
            
        }
        
    }
    
    /// `true` if `self` normalized contains a single code unit that is in the categories of Uppercase and Titlecase Letters.
    var isUppercase: Bool {
        
        return isMember(of: uppercaseSet)
        
    }
    
    /// `true` if `self` normalized contains a single code unit that is in the category of Lowercase Letters.
    var isLowercase: Bool {
        
        return isMember(of: lowercaseSet)
        
    }
    
    /// `true` if `self` normalized contains a single code unit that is in the categories of Letters and Marks.
    var isAlpha: Bool {
        
        return isMember(of: alphaSet)
        
    }
    
    /// `true` if `self` normalized contains a single code unit that is in th categories of Letters, Marks, and Numbers.
    var isAlphaNumeric: Bool {
        
        return isMember(of: alphaNumericSet)
        
    }
    
    /// `true` if `self` normalized contains a single code unit that is in the category of Symbols. These characters include, for example, the dollar sign ($) and the plus (+) sign.
    var isSymbol: Bool {
        
        return isMember(of: symbolSet)
        
    }
    
    /// `true` if `self` normalized contains a single code unit that is in the category of Decimal Numbers.
    var isDigit: Bool {
        
        return isMember(of: digitSet)
        
    }
    
    /// `true` if `self` is an ASCII decimal digit, i.e. between "0" and "9".
    var isDecimalDigit: Bool {
        
        return "0123456789".contains(self)
        
    }
    
    /// `true` if `self` is an ASCII hexadecimal digit, i.e. "0"..."9", "a"..."f", "A"..."F".
    var isHexadecimalDigit: Bool {
        
        return "01234567890abcdefABCDEF".contains(self)
        
    }
    
    /// `true` if `self` is an ASCII octal digit, i.e. between '0' and '7'.
    var isOctalDigit: Bool {
        
        return "01234567".contains(self)
        
    }
    
    /// Lowercase `self`.
    var lowercase: Character {
        
        let str = String(self).lowercased()
        return str[str.startIndex]
        
    }
    
    /// Uppercase `self`.
    var uppercase: Character {
        
        let str = String(self).uppercased()
        return str[str.startIndex]
        
    }
    
    /// Return `true` if `self` normalized contains a single code unit that is a member of the supplied character set.
    ///
    /// - parameter set: The `CharacterSet` used to test for membership.
    /// - returns: `true` if `self` normalized contains a single code unit that is a member of the supplied character set.
    func isMember(of set: CharacterSet) -> Bool {
        
        let normalized = String(self).precomposedStringWithCanonicalMapping
        let unicodes = normalized.unicodeScalars
        
        guard unicodes.count == 1 else { return false }
        
        return set.contains(unicodes.first!)
        
    }
    
}

extension PyString {

  // MARK: - Types

  internal typealias Element = UnicodeScalar
  internal typealias Elements = String.UnicodeScalarView
  internal typealias Builder = UnicodeScalarBuilder
  internal typealias ElementSwiftType = PyString

  // MARK: - Defaults

  internal static let defaultFill: UnicodeScalar = " "
  internal static let zFill: UnicodeScalar = "0"

  // MARK: - To object

  internal static func newObject(_ py: Py, element: UnicodeScalar) -> Self {
    return py.newString(scalar: element)
  }

  internal static func newObject(_ py: Py, elements: String.UnicodeScalarView) -> Self {
    return py.newString(elements)
  }

  internal static func newObject(_ py: Py, elements: Substring.UnicodeScalarView) -> Self {
    return py.newString(elements)
  }

  internal static func newObject(_ py: Py, result: String) -> Self {
    return py.newString(result)
  }

  // MARK: - Get elements

  internal static func getElements(_ py: Py, object: PyObject) -> Elements? {
    if let string = Self.downcast(py, object) {
      return string.elements
    }

    return nil
  }

  internal static func getElementsForFindCountContainsIndexOf(
    _ py: Py,
    object: PyObject
  ) -> AbstractStringElementsForFindCountContainsIndexOf<Elements> {
    // Nothing special here, only 'str' can be used in 'find', 'count' etc… '.
    if let string = Self.downcast(py, object) {
      return .value(string.elements)
    }

    return .invalidObjectType
  }

  // MARK: - Whitespace

  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  ///
  internal static func isWhitespace(element: UnicodeScalar) -> Bool {
    return UnicodeData.isWhitespace(element)
  }

  // MARK: - Line break

  /// This is not exposed to Python, but it is used in various methods
  /// (for example `splitlines`).
  ///
  internal static func isLineBreak(element: UnicodeScalar) -> Bool {
    return UnicodeData.isLineBreak(element)
  }

  // MARK: - Alpha numeric

  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  ///
  internal static func isAlphaNumeric(element: UnicodeScalar) -> Bool {
    return UnicodeData.isAlphaNumeric(element)
  }

  // MARK: - Alpha

  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  ///
  internal static func isAlpha(element: UnicodeScalar) -> Bool {
    return UnicodeData.isAlpha(element)
  }

  // MARK: - ASCII

  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  ///
  internal static func isAscii(element: UnicodeScalar) -> Bool {
    return ASCIIData.isASCII(element)
  }

  // MARK: - Decimal

  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  ///
  internal static func isDecimal(element: UnicodeScalar) -> Bool {
    return UnicodeData.isDecimalDigit(element)
  }

  // MARK: - Digit

  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  ///
  internal static func isDigit(element: UnicodeScalar) -> Bool {
    return UnicodeData.isDigit(element)
  }

  // MARK: - Lower

  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  ///
  internal static func isLower(element: UnicodeScalar) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return !UnicodeData.isCased(element) || UnicodeData.isLowercase(element)
  }

  internal static func lowercaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toLowercase(element)
  }

  // MARK: - Upper

  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  ///
  internal static func isUpper(element: UnicodeScalar) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".isupper() -> True
    return !UnicodeData.isCased(element) || UnicodeData.isUppercase(element)
  }

  internal static func uppercaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toUppercase(element)
  }

  // MARK: - Numeric

  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  ///
  internal static func isNumeric(element: UnicodeScalar) -> Bool {
    return UnicodeData.isNumeric(element)
  }

  // MARK: - Title

  internal static func isTitle(element: UnicodeScalar) -> Bool {
    return UnicodeData.isTitlecase(element)
  }

  internal static func titlecaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toTitlecase(element)
  }

  // MARK: - Is cased

  internal static func isCased(element: UnicodeScalar) -> Bool {
    return UnicodeData.isCased(element)
  }

  // MARK: - Printable

  /// Return true if all characters in the string are printable
  /// or the string is empty.
  ///
  /// Nonprintable characters are those characters defined in the Unicode
  /// character database as “Other” or “Separator”,
  /// excepting the ASCII space (0x20) which is considered printable.
  ///
  /// All characters except those characters defined in the Unicode character
  /// database as following categories are considered printable.
  ///    * Cc (Other, Control)
  ///    * Cf (Other, Format)
  ///    * Cs (Other, Surrogate)
  ///    * Co (Other, Private Use)
  ///    * Cn (Other, Not Assigned)
  ///    * Zl Separator, Line ('\u2028', LINE SEPARATOR)
  ///    * Zp Separator, Paragraph ('\u2029', PARAGRAPH SEPARATOR)
  ///    * Zs (Separator, Space) other than ASCII space('\x20').
  /// https://docs.python.org/3/library/stdtypes.html#str.isprintable
  ///
  internal static func isPrintable(element: UnicodeScalar) -> Bool {
    return UnicodeData.isPrintable(element)
  }

  // MARK: - Specific characters

  /// Is this `+` or `-` (`0x2B` and `0x2D` in ASCII respectively).
  /// Used inside `zfill`.
  ///
  internal static func isPlusOrMinus(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x2b || value == 0x2d
  }

  /// Is this `HT` (`0x09` in ASCII)?
  /// Used inside `expandTabs`.
  ///
  internal static func isHorizontalTab(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x09
  }

  /// Is this `CR` (`0x0D` in ASCII)?
  /// Used inside `splitLines`.
  ///
  internal static func isCarriageReturn(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x0d
  }

  /// Is this `LF` (`0x0A` in ASCII)?
  /// Used inside `splitLines`.
  ///
  internal static func isLineFeed(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x0a
  }
}
