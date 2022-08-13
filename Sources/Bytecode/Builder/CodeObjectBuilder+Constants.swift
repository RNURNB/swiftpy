import Foundation
import BigInt
import VioletCore

extension CodeObjectBuilder {

  /// Append a `loadConst(True)` instruction to this code object.
  public func appendTrue() throws {
    if let index = self.cache.true {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.true)
      self.cache.true = index
    }
  }

  /// Append a `loadConst(False)` instruction to this code object.
  public func appendFalse() throws {
    if let index = self.cache.false {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.false)
      self.cache.false = index
    }
  }

  /// Append a `loadConst(None)` instruction to this code object.
  public func appendNone() throws {
    if let index = self.cache.none {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.none)
      self.cache.none = index
    }
  }

  /// Append a `loadConst(Ellipsis)` instruction to this code object.
  public func appendEllipsis() throws {
    if let index = self.cache.ellipsis {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.ellipsis)
      self.cache.ellipsis = index
    }
  }
  
  public func appendInteger(_ value: BigInt) throws {
      //convert to int
      let s=value.description
      try self.appendInteger(Int(s)!)
  }

  /// Append a `loadConst(Integer)` instruction to this code object.
  public func appendInteger(_ value: Int) throws {
    switch value {
    case 0:
      if let index = self.cache.zero {
        try self.appendExistingConstant(index: index)
      } else {
        let index = try self.appendNewConstant(.integer(value))
        self.cache.zero = index
      }

    case 1:
      if let index = self.cache.one {
        try self.appendExistingConstant(index: index)
      } else {
        let index = try self.appendNewConstant(.integer(value))
        self.cache.one = index
      }

    default:
      _ = try self.appendNewConstant(.integer(value))
    }
  }

  /// Append a `loadConst(Float)` instruction to this code object.
  public func appendFloat(_ value: Double) throws {
    _ = try self.appendNewConstant(.float(value))
  }

  /// Append a `loadConst(Complex)` instruction to this code object.
  public func appendComplex(real: Double, imag: Double) throws {
    _ = try self.appendNewConstant(.complex(real: real, imag: imag))
  }

  /// Append a `loadConst(String)` instruction to this code object.
  public func appendString(_ value: String) throws {
    let key = UseScalarsToHashString(value)

    if let index = self.cache.constantStrings[key] {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.string(value))
      self.cache.constantStrings[key] = index
    }
  }

  /// Append a `loadConst(String)` instruction to this code object.
  public func appendString(_ name: MangledName) throws {
    try self.appendString(name.value)
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendBytes(_ value: Data) throws {
    _ = try self.appendNewConstant(.bytes(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendTuple(_ value: [CodeObject.Constant]) throws {
    _ = try self.appendNewConstant(.tuple(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendCode(_ value: CodeObject) throws {
    _ = try self.appendNewConstant(.code(value))
  }

  public func appendConstant(_ value: CodeObject.Constant) throws {
    switch value {
    case .true:
      try self.appendTrue()
    case .false:
      try self.appendFalse()

    case .none:
      try self.appendNone()
    case .ellipsis:
      try self.appendEllipsis()

    case let .integer(i):
      try self.appendInteger(i)
    case let .float(d):
      try self.appendFloat(d)
    case let .complex(real: r, imag: i):
      try self.appendComplex(real: r, imag: i)

    case let .string(s):
      try self.appendString(s)
    case let .bytes(b):
      try self.appendBytes(b)

    case let .code(c):
      try self.appendCode(c)

    case let .tuple(es):
      try self.appendTuple(es)
    }
  }

  // MARK: - Add

  /// Simply add new constant, without emitting any instruction.
  public func addNoneConstant() {
    let constant = CodeObject.Constant.none
    self.constants.append(constant)
  }

  /// Simply add new constant, without emitting any instruction.
  public func addConstant(string: String) {
    let constant = CodeObject.Constant.string(string)
    self.constants.append(constant)
  }

  // MARK: - Helpers

  private func appendNewConstant(_ constant: CodeObject.Constant) throws -> Int {
    let index = self.constants.endIndex
    self.constants.append(constant)

    try self.appendExistingConstant(index: index)
    return index
  }

  private func appendExistingConstant(index: Int) throws {
    let arg = try self.appendExtendedArgIfNeeded(index)
    self.append(.loadConst(index: arg))
  }
}
