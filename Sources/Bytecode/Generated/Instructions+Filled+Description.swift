// This file was auto-generated by Elsa from 'opcodes.letitgo.'
// DO NOT EDIT!

import Foundation
import VioletCore

extension Instruction.Filled: CustomStringConvertible {

  public var description: String {
    switch self {
    case .nop:
      return "nop"
    case .popTop:
      return "popTop"
    case .rotTwo:
      return "rotTwo"
    case .rotThree:
      return "rotThree"
    case .dupTop:
      return "dupTop"
    case .dupTopTwo:
      return "dupTopTwo"
    case .unaryPositive:
      return "unaryPositive"
    case .unaryNegative:
      return "unaryNegative"
    case .unaryNot:
      return "unaryNot"
    case .unaryInvert:
      return "unaryInvert"
    case .binaryPower:
      return "binaryPower"
    case .binaryMultiply:
      return "binaryMultiply"
    case .binaryMatrixMultiply:
      return "binaryMatrixMultiply"
    case .binaryFloorDivide:
      return "binaryFloorDivide"
    case .binaryTrueDivide:
      return "binaryTrueDivide"
    case .binaryModulo:
      return "binaryModulo"
    case .binaryAdd:
      return "binaryAdd"
    case .binarySubtract:
      return "binarySubtract"
    case .binaryLShift:
      return "binaryLShift"
    case .binaryRShift:
      return "binaryRShift"
    case .binaryAnd:
      return "binaryAnd"
    case .binaryXor:
      return "binaryXor"
    case .binaryOr:
      return "binaryOr"
    case .inPlacePower:
      return "inPlacePower"
    case .inPlaceMultiply:
      return "inPlaceMultiply"
    case .inPlaceMatrixMultiply:
      return "inPlaceMatrixMultiply"
    case .inPlaceFloorDivide:
      return "inPlaceFloorDivide"
    case .inPlaceTrueDivide:
      return "inPlaceTrueDivide"
    case .inPlaceModulo:
      return "inPlaceModulo"
    case .inPlaceAdd:
      return "inPlaceAdd"
    case .inPlaceSubtract:
      return "inPlaceSubtract"
    case .inPlaceLShift:
      return "inPlaceLShift"
    case .inPlaceRShift:
      return "inPlaceRShift"
    case .inPlaceAnd:
      return "inPlaceAnd"
    case .inPlaceXor:
      return "inPlaceXor"
    case .inPlaceOr:
      return "inPlaceOr"
    case let .compareOp(type: value0):
      return "compareOp(type: \(value0))"
    case .getAwaitable:
      return "getAwaitable"
    case .getAIter:
      return "getAIter"
    case .getANext:
      return "getANext"
    case .yieldValue:
      return "yieldValue"
    case .yieldFrom:
      return "yieldFrom"
    case .printExpr:
      return "printExpr"
    case let .setupLoop(loopEndLabel: value0):
      return "setupLoop(loopEndLabel: \(value0))"
    case let .forIter(ifEmptyLabel: value0):
      return "forIter(ifEmptyLabel: \(value0))"
    case .getIter:
      return "getIter"
    case .getYieldFromIter:
      return "getYieldFromIter"
    case .`break`:
      return "break"
    case let .`continue`(loopStartLabel: value0):
      return "continue(loopStartLabel: \(value0))"
    case let .buildTuple(elementCount: value0):
      return "buildTuple(elementCount: \(value0))"
    case let .buildList(elementCount: value0):
      return "buildList(elementCount: \(value0))"
    case let .buildSet(elementCount: value0):
      return "buildSet(elementCount: \(value0))"
    case let .buildMap(elementCount: value0):
      return "buildMap(elementCount: \(value0))"
    case let .buildConstKeyMap(elementCount: value0):
      return "buildConstKeyMap(elementCount: \(value0))"
    case let .setAdd(relativeStackIndex: value0):
      return "setAdd(relativeStackIndex: \(value0))"
    case let .listAppend(relativeStackIndex: value0):
      return "listAppend(relativeStackIndex: \(value0))"
    case let .mapAdd(relativeStackIndex: value0):
      return "mapAdd(relativeStackIndex: \(value0))"
    case let .buildTupleUnpack(elementCount: value0):
      return "buildTupleUnpack(elementCount: \(value0))"
    case let .buildTupleUnpackWithCall(elementCount: value0):
      return "buildTupleUnpackWithCall(elementCount: \(value0))"
    case let .buildListUnpack(elementCount: value0):
      return "buildListUnpack(elementCount: \(value0))"
    case let .buildSetUnpack(elementCount: value0):
      return "buildSetUnpack(elementCount: \(value0))"
    case let .buildMapUnpack(elementCount: value0):
      return "buildMapUnpack(elementCount: \(value0))"
    case let .buildMapUnpackWithCall(elementCount: value0):
      return "buildMapUnpackWithCall(elementCount: \(value0))"
    case let .unpackSequence(elementCount: value0):
      return "unpackSequence(elementCount: \(value0))"
    case let .unpackEx(arg: value0):
      return "unpackEx(arg: \(value0))"
    case let .loadConst(value0):
      return "loadConst(\(value0)-\(type(of:value0)))"
    case let .storeName(name: value0):
      return "storeName(name: \(value0))"
    case let .loadName(name: value0):
      return "loadName(name: \(value0))"
    case let .deleteName(name: value0):
      return "deleteName(name: \(value0))"
    case let .storeAttribute(name: value0):
      return "storeAttribute(name: \(value0))"
    case let .loadAttribute(name: value0):
      return "loadAttribute(name: \(value0))"
    case let .deleteAttribute(name: value0):
      return "deleteAttribute(name: \(value0))"
    case .binarySubscript:
      return "binarySubscript"
    case .storeSubscript:
      return "storeSubscript"
    case .deleteSubscript:
      return "deleteSubscript"
    case let .storeGlobal(name: value0):
      return "storeGlobal(name: \(value0))"
    case let .loadGlobal(name: value0):
      return "loadGlobal(name: \(value0))"
    case let .deleteGlobal(name: value0):
      return "deleteGlobal(name: \(value0))"
    case let .loadFast(variable: value0):
      return "loadFast(variable: \(value0))"
    case let .storeFast(variable: value0):
      return "storeFast(variable: \(value0))"
    case let .deleteFast(variable: value0):
      return "deleteFast(variable: \(value0))"
    case let .loadCell(cell: value0):
      return "loadCell(cell: \(value0))"
    case let .storeCell(cell: value0):
      return "storeCell(cell: \(value0))"
    case let .deleteCell(cell: value0):
      return "deleteCell(cell: \(value0))"
    case let .loadFree(free: value0):
      return "loadFree(free: \(value0))"
    case let .storeFree(free: value0):
      return "storeFree(free: \(value0))"
    case let .deleteFree(free: value0):
      return "deleteFree(free: \(value0))"
    case let .loadClassFree(free: value0):
      return "loadClassFree(free: \(value0))"
    case let .loadClosure(cellOrFree: value0):
      return "loadClosure(cellOrFree: \(value0))"
    case let .makeFunction(flags: value0):
      return "makeFunction(flags: \(value0))"
    case let .callFunction(argumentCount: value0):
      return "callFunction(argumentCount: \(value0))"
    case let .callFunctionKw(argumentCount: value0):
      return "callFunctionKw(argumentCount: \(value0))"
    case let .callFunctionEx(hasKeywordArguments: value0):
      return "callFunctionEx(hasKeywordArguments: \(value0))"
    case .`return`:
      return "return"
    case .loadBuildClass:
      return "loadBuildClass"
    case let .loadMethod(name: value0):
      return "loadMethod(name: \(value0))"
    case let .callMethod(argumentCount: value0):
      return "callMethod(argumentCount: \(value0))"
    case .importStar:
      return "importStar"
    case let .importName(name: value0):
      return "importName(name: \(value0))"
    case let .importFrom(name: value0):
      return "importFrom(name: \(value0))"
    case .popExcept:
      return "popExcept"
    case .endFinally:
      return "endFinally"
    case let .setupExcept(firstExceptLabel: value0):
      return "setupExcept(firstExceptLabel: \(value0))"
    case let .setupFinally(finallyStartLabel: value0):
      return "setupFinally(finallyStartLabel: \(value0))"
    case let .raiseVarargs(type: value0):
      return "raiseVarargs(type: \(value0))"
    case let .setupWith(afterBodyLabel: value0):
      return "setupWith(afterBodyLabel: \(value0))"
    case .withCleanupStart:
      return "withCleanupStart"
    case .withCleanupFinish:
      return "withCleanupFinish"
    case .beforeAsyncWith:
      return "beforeAsyncWith"
    case .setupAsyncWith:
      return "setupAsyncWith"
    case let .jumpAbsolute(label: value0):
      return "jumpAbsolute(label: \(value0))"
    case let .popJumpIfTrue(label: value0):
      return "popJumpIfTrue(label: \(value0))"
    case let .popJumpIfFalse(label: value0):
      return "popJumpIfFalse(label: \(value0))"
    case let .jumpIfTrueOrPop(label: value0):
      return "jumpIfTrueOrPop(label: \(value0))"
    case let .jumpIfFalseOrPop(label: value0):
      return "jumpIfFalseOrPop(label: \(value0))"
    case let .formatValue(conversion: value0, hasFormat: value1):
      return "formatValue(conversion: \(value0), hasFormat: \(value1))"
    case let .buildString(elementCount: value0):
      return "buildString(elementCount: \(value0))"
    case .setupAnnotations:
      return "setupAnnotations"
    case .popBlock:
      return "popBlock"
    case let .buildSlice(type: value0):
      return "buildSlice(type: \(value0))"
    }
  }
}
