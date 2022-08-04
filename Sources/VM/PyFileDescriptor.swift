import Foundation
import FileSystem
import VioletObjects

/// Adapter between `FileSystem.FileDescriptor` and `PyFileDescriptorType`.
///
/// Basically it will call a method on provided `FileDescriptor`
/// and then in case of exception it will convert it to Python error.
public struct PyFileDescriptor: CustomStringConvertible, PyFileDescriptorType {

  private let fd: FileDescriptor
  /// Path for error messages
  private let path: String?

  public var description: String {
    return self.fd.description
  }

  public init(fd: FileDescriptor, path: String?) {
    self.fd = fd
    self.path = path
  }

  // MARK: - Raw

  public var raw: Int32 {
    return self.fd.raw
  }

  // MARK: - Read

  public func readLine(_ py: Py) -> PyResultGen<Data> {
    do {
      let data = try self.fd.readLine()
      return .value(data)
    } catch {
      return self.toOSError(py, error)
    }
  }

  public func readToEnd(_ py: Py) -> PyResultGen<Data> {
    do {
      let data = try self.fd.readToEnd()
      return .value(data)
    } catch {
      return self.toOSError(py, error)
    }
  }

  public func read(_ py: Py, count: Int) -> PyResultGen<Data> {
    do {
      let data = try self.fd.read(upToCount: count)
      return .value(data)
    } catch {
      return self.toOSError(py, error)
    }
  }

  // MARK: - Write

  public func write<T: DataProtocol>(_ py: Py, data: T) -> PyBaseException? {
    do {
      try self.fd.write(contentsOf: data)
      return nil
    } catch {
      return self.toOSError(py, error)
    }
  }

  // MARK: - Flush

  public func flush(_ py: Py) -> PyBaseException? {
    do {
      try self.fd.synchronize()
      return nil
    } catch {
      return self.toOSError(py, error)
    }
  }

  // MARK: - Offset

  public func offset(_ py: Py) -> PyResultGen<UInt64> {
    do {
      let result = try self.fd.offset()
      return .value(result)
    } catch {
      return self.toOSError(py, error)
    }
  }

  // MARK: - Seek

  public func seekToEnd(_ py: Py) -> PyResultGen<UInt64> {
    do {
      let result = try self.fd.seekToEnd()
      return .value(result)
    } catch {
      return self.toOSError(py, error)
    }
  }

  public func seek(_ py: Py, offset: UInt64) -> PyBaseException? {
    do {
      try self.fd.seek(toOffset: offset)
      return nil
    } catch {
      return self.toOSError(py, error)
    }
  }

  // MARK: - Close

  public func close(_ py: Py) -> PyBaseException? {
    do {
      try self.fd.close()
      return nil
    } catch {
      return self.toOSError(py, error)
    }
  }

  // MARK: - Error

  public func toOSError<T>(_ py: Py, _ error: Error) -> PyResultGen<T> {
    let osError: PyBaseException = self.toOSError(py, error)
    return .error(osError)
  }

  public func toOSError(_ py: Py, _ error: Error) -> PyBaseException {
    if let descriptorError = error as? FileDescriptor.Error {
      let errno = descriptorError.errno
      if let p = self.path {
        let error = py.newOSError(errno: errno, path: p)
        return error.asBaseException
      }

      let error = py.newOSError(errno: errno)
      return error.asBaseException
    }

    var message = "unknown IO error"
    if let p = self.path {
      message.append(" (file: \(p))")
    }

    let error = py.newOSError(message: message)
    return error.asBaseException
  }
}
