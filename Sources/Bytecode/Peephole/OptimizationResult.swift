import VioletCore

// MARK: - OptimizationResult

public struct OptimizationResult {

  public var instructions: Instructions
  public var instructionLines: InstructionLines
  public var constants: Constants
  public var labels: Labels

  public init(instructions: [Instruction],
                instructionLines: [SourceLine],
                constants: [CodeObject.Constant],
                labels: [CodeObject.Label]) {
    self.instructions = Instructions(values: instructions)
    self.instructionLines = InstructionLines(values: instructionLines)
    self.constants = Constants(values: constants)
    self.labels = Labels(values: labels)
  }

  public mutating func convertToPeepholeOptimizerResult() -> PeepholeOptimizer.RunResult {
    return PeepholeOptimizer.RunResult(
      instructions: self.instructions.values,
      instructionLines: self.instructionLines.values,
      constants: self.constants.values,
      labels: self.labels.values
    )
  }

  public mutating func dropReferencesToAvoidCOW() {
    self.instructions = Instructions(values: [])
    self.instructionLines = InstructionLines(values: [])
    self.constants = Constants(values: [])
    self.labels = Labels(values: [])
  }

  // swiftlint:disable function_parameter_count

  /// Write `[extendedArg0, extendedArg1, extendedArg2, instruction]` starting
  /// at `index`. This will modify both `self.instructions` and `self.instructionLines`.
  public mutating func write(index: Int,
                               extendedArg0: UInt8?,
                               extendedArg1: UInt8?,
                               extendedArg2: UInt8?,
                               instruction: Instruction,
                               line: SourceLine) {
    // swiftlint:enable function_parameter_count
    var index = index

    if let arg = extendedArg0 {
      self.instructions.values[index] = .extendedArg(arg)
      self.instructionLines[index] = line
      index += 1
    }

    if let arg = extendedArg1 {
      self.instructions.values[index] = .extendedArg(arg)
      self.instructionLines[index] = line
      index += 1
    }

    if let arg = extendedArg2 {
      self.instructions.values[index] = .extendedArg(arg)
      self.instructionLines[index] = line
      index += 1
    }

    self.instructions.values[index] = instruction
    self.instructionLines[index] = line
  }

  // MARK: - Instructions

  /// Wrapper for `[Instruction]` so that we control the modifications
  /// (for example: we will block removal in some cases).
  public struct Instructions {

    fileprivate var values: [Instruction]

    public var count: Int {
      return self.values.count
    }

    public subscript(index: Int) -> Instruction {
      get { return self.values[index] }
      set { self.values[index] = newValue }
    }

    /// Read an instruction starting from provided `index`.
    ///
    /// This is the method that you want to use if you traverse bytecode in the
    /// 'normal' order (from start to the end).
    public func get(startIndex: Int?) -> PeepholeInstruction? {
      guard let index = startIndex else {
        return nil
      }

      return PeepholeInstruction(instructions: self.values, startIndex: index)
    }

    /// Read an instruction going back from provided `index` and collecting all of
    /// the `extendedArgs`. Then read the whole instruction (with extended args).
    ///
    /// `Unaligned` means that you don't have to be at the start of an instruction
    /// to use this method.
    public func get(unalignedIndex: Int?) -> PeepholeInstruction? {
      guard let index = unalignedIndex else {
        return nil
      }

      return PeepholeInstruction(instructions: self.values, unalignedIndex: index)
    }

    /// Set the whole space taken by instruction to `nop.`
    public mutating func setToNop(instruction: PeepholeInstruction) {
      let startIndex = instruction.startIndex
      let endIndex = instruction.nextInstructionIndex ?? self.values.count
      self.setToNop(startIndex: startIndex, endIndex: endIndex)
    }

    /// Sets the instructions `startIndex..<endIndex` to `nop`.
    public mutating func setToNop(startIndex: Int, endIndex: Int?) {
      let endIndex = endIndex ?? self.values.count
      assert(startIndex <= endIndex)

      for index in startIndex..<endIndex {
        self.values[index] = .nop
      }
    }
  }

  // MARK: - Instruction lines

  /// Wrapper for `[SourceLine]` so that we control the modifications
  /// (for example: we will block removal in some cases).
  public struct InstructionLines {

    fileprivate var values: [SourceLine]

    public var count: Int {
      return self.values.count
    }

    public var last: SourceLine? {
      return self.values.last
    }

    public subscript(index: Int) -> SourceLine {
      get { return self.values[index] }
      set { self.values[index] = newValue }
    }
  }

  // MARK: - Constants

  /// Wrapper for `[CodeObject.Constant]` so that we control the modifications
  /// (for example: we will block removal).
  public struct Constants: RandomAccessCollection {

    fileprivate var values: [CodeObject.Constant]

    public var startIndex: Int {
      return self.values.startIndex
    }

    public var endIndex: Int {
      return self.values.endIndex
    }

    // We do not allow changing the value of a constant!
    // It is possible that multiple instructions are using the same constant index
    // (for example 'True/False' are reused).
    public subscript(index: Int) -> CodeObject.Constant {
      return self.values[index]
    }

    public mutating func append(_ element: CodeObject.Constant) {
      self.values.append(element)
    }
  }

  // MARK: - Labels

  /// Wrapper for `[CodeObject.Label]` so that we control the modifications
  /// (for example: we will block removal).
  public struct Labels: RandomAccessCollection {

    fileprivate var values: [CodeObject.Label]

    public var startIndex: Int {
      return self.values.startIndex
    }

    public var endIndex: Int {
      return self.values.endIndex
    }

    // We do not allow changing the labels!
    // It is possible that multiple jumps are using the same label index
    // (we do this in optimizer).
    public subscript(index: Int) -> CodeObject.Label {
      return self.values[index]
    }

    public mutating func append(_ element: CodeObject.Label) {
      self.values.append(element)
    }
  }
}
