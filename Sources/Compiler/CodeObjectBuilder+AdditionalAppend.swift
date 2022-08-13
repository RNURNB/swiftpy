import VioletCore
import VioletParser
import VioletBytecode

extension CodeObjectBuilder {

  // MARK: - Variables

  internal func appendName(name: MangledName, context: ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreName(name)
    case .load: try self.appendLoadName(name)
    case .del: try self.appendDeleteName(name)
    }
  }

  internal func appendGlobal(name: String, context: ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreGlobal(name)
    case .load: try self.appendLoadGlobal(name)
    case .del: try self.appendDeleteGlobal(name)
    }
  }

  internal func appendGlobal(name: MangledName, context: ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreGlobal(name)
    case .load: try self.appendLoadGlobal(name)
    case .del: try self.appendDeleteGlobal(name)
    }
  }

  internal func appendFast(name: MangledName, context: ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreFast(name)
    case .load: try self.appendLoadFast(name)
    case .del: try self.appendDeleteFast(name)
    }
  }

  internal func appendCell(name: MangledName, context: ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreCell(name)
    case .load: try self.appendLoadCell(name)
    case .del: try self.appendDeleteCell(name)
    }
  }

  internal func appendFree(name: MangledName, context: ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreFree(name)
    case .load: try self.appendLoadFree(name)
    case .del: try self.appendDeleteFree(name)
    }
  }

  // MARK: - Operators

  internal func appendUnaryOperator(_ op: UnaryOpExpr.Operator) throws {
    switch op {
    case .invert: self.appendUnaryInvert()
    case .not: self.appendUnaryNot()
    case .plus: self.appendUnaryPositive()
    case .minus: self.appendUnaryNegative()
    }
  }

  internal func appendBinaryOperator(_ op: BinaryOpExpr.Operator) {
    switch op {
    case .add: self.appendBinaryAdd()
    case .sub: self.appendBinarySubtract()
    case .mul: self.appendBinaryMultiply()
    case .matMul: self.appendBinaryMatrixMultiply()
    case .div: self.appendBinaryTrueDivide()
    case .modulo: self.appendBinaryModulo()
    case .pow: self.appendBinaryPower()
    case .leftShift: self.appendBinaryLShift()
    case .rightShift: self.appendBinaryRShift()
    case .bitOr: self.appendBinaryOr()
    case .bitXor: self.appendBinaryXor()
    case .bitAnd: self.appendBinaryAnd()
    case .floorDiv: self.appendBinaryFloorDivide()
    }
  }

  internal func appendInPlaceOperator(_ op: BinaryOpExpr.Operator) {
    switch op {
    case .add: self.appendInPlaceAdd()
    case .sub: self.appendInPlaceSubtract()
    case .mul: self.appendInPlaceMultiply()
    case .matMul: self.appendInPlaceMatrixMultiply()
    case .div: self.appendInPlaceTrueDivide()
    case .modulo: self.appendInPlaceModulo()
    case .pow: self.appendInPlacePower()
    case .leftShift: self.appendInPlaceLShift()
    case .rightShift: self.appendInPlaceRShift()
    case .bitOr: self.appendInPlaceOr()
    case .bitXor: self.appendInPlaceXor()
    case .bitAnd: self.appendInPlaceAnd()
    case .floorDiv: self.appendInPlaceFloorDivide()
    }
  }

  // MARK: - Compare

  /// Append a `compareOp` instruction to code object.
  internal func appendCompareOp(operator: CompareExpr.Operator) {
    switch `operator` {
    case .equal: self.appendCompareOp(type: .equal)
    case .notEqual: self.appendCompareOp(type: .notEqual)
    case .less: self.appendCompareOp(type: .less)
    case .lessEqual: self.appendCompareOp(type: .lessEqual)
    case .greater: self.appendCompareOp(type: .greater)
    case .greaterEqual: self.appendCompareOp(type: .greaterEqual)
    case .is: self.appendCompareOp(type: .is)
    case .isNot: self.appendCompareOp(type: .isNot)
    case .in: self.appendCompareOp(type: .in)
    case .notIn: self.appendCompareOp(type: .notIn)
    }
  }
}
