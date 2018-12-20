//
//  Accessors.swift
//  PMJSON
//
//  Created by Kevin Ballard on 10/9/15.
//  Copyright © 2016 Postmates.
//
//  Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
//  http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
//  <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
//  option. This file may not be copied, modified, or distributed
//  except according to those terms.
//

import class Foundation.NSDecimalNumber
import struct Foundation.Decimal

public extension JSON {
    /// Returns `true` iff the receiver is `.null`.
    var isNull: Bool {
        switch self {
        case .null: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.bool`.
    var isBool: Bool {
        switch self {
        case .bool: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.string`.
    var isString: Bool {
        switch self {
        case .string: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.int64`.
    var isInt64: Bool {
        switch self {
        case .int64: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.double`.
    var isDouble: Bool {
        switch self {
        case .double: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is a `.decimal`.
    var isDecimal: Bool {
        switch self {
        case .decimal: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.int64`, `.double`, or `.decimal`.
    /// - Note: `.decimal` is only considered a number on platforms that have `Decimal`.
    ///   On platforms where `.decimal` is a dummy value, it's not a treated as a number.
    var isNumber: Bool {
        switch self {
        case .int64, .double, .decimal: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.object`.
    var isObject: Bool {
        switch self {
        case .object: return true
        default: return false
        }
    }
    
    /// Returns `true` iff the receiver is `.array`.
    var isArray: Bool {
        switch self {
        case .array: return true
        default: return false
        }
    }
}

public extension JSON {
    /// Returns the boolean value if the receiver is `.bool`, otherwise `nil`.
    ///
    /// When setting, replaces the receiver with the given boolean value, or with
    /// null if the value is `nil`.
    var bool: Bool? {
        get {
            switch self {
            case .bool(let b): return b
            default: return nil
            }
        }
        set {
            self = newValue.map(JSON.bool) ?? nil
        }
    }
    
    /// Returns the string value if the receiver is `.string`, otherwise `nil`.
    ///
    /// When setting, replaces the receiver with the given string value, or with
    /// null if the value is `nil`.
    var string: String? {
        get {
            switch self {
            case .string(let s): return s
            default: return nil
            }
        }
        set {
            self = newValue.map(JSON.string) ?? nil
        }
    }
    
    /// Returns the 64-bit integral value if the receiver is `.int64`, `.double`, or `.decimal`, otherwise `nil`.
    /// If the receiver is `.double`, the value is truncated. If it does not fit in 64 bits, `nil` is returned.
    /// If the receiver is `.decimal`, the value is returned using `NSDecimalNumber.int64Value`. If it does not
    /// fit in 64 bits, `nil` is returned.
    ///
    /// When setting, replaces the receiver with the given integral value, or with
    /// null if the value is `nil`.
    ///
    /// - Note: `.decimal` is only supported on platforms with `Decimal`. On platforms without it,
    ///   the `.decimal` dummy value is not treated as a number.
    var int64: Int64? {
        get {
            switch self {
            case .int64(let i): return i
            case .double(let d): return convertDoubleToInt64(d)
            case .decimal(let d): return convertDecimalToInt64(d)
            default: return nil
            }
        } set {
            self = newValue.map(JSON.int64) ?? nil
        }
    }
    
    /// Returns the integral value if the receiver is `.int64`, `.double`, or `.decimal`, otherwise `nil`.
    /// If the receiver is `.double`, the value is truncated. If it does not fit in an `Int`, `nil` is returned.
    /// If the receiver is `.int64` and the value does not fit in an `Int`, `nil` is returned.
    /// If the receiver is `.decimal`, the value is returned using `NSDecimalNumber.int64Value`. If it does not
    /// fit in an `Int`, `nil` is returned.
    ///
    /// When setting, replaces the receiver with the given integral value, or with
    /// null if the value is `nil`.
    ///
    /// - Note: `.decimal` is only supported on platforms with `Decimal`. On platforms without it,
    ///   the `.decimal` dummy value is not treated as a number.
    var int: Int? {
        get {
            guard let value = self.int64 else { return nil}
            let truncated = Int(truncatingIfNeeded: value)
            guard Int64(truncated) == value else { return nil }
            return truncated
        }
        set {
            self = newValue.map({ JSON.int64(Int64($0)) }) ?? nil
        }
    }
    
    /// Returns the numeric value as a `Double` if the receiver is `.int64`, `.double`, or `.decimal`, otherwise `nil`.
    /// If the receiver is `.decimal`, the value is returned using `NSDecimalNumber.doubleValue`.
    ///
    /// When setting, replaces the receiver with the given double value, or with
    /// null if the value is `nil`.
    ///
    /// - Note: `.decimal` is only supported on platforms with `Decimal`. On platforms without it,
    ///   the `.decimal` dummy value is not treated as a number.
    var double: Double? {
        get {
            switch self {
            case .int64(let i): return Double(i)
            case .double(let d): return d
            case .decimal(let d):
                // NB: Decimal does not have any accessor to produce a Double
                return NSDecimalNumber(decimal: d).doubleValue
            default: return nil
            }
        }
        set {
            self = newValue.map(JSON.double) ?? nil
        }
    }
    
    /// Returns the object dictionary if the receiver is `.object`, otherwise `nil`.
    ///
    /// When setting, replaces the receiver with the given object value, or with
    /// null if the value is `nil`.
    var object: JSONObject? {
        get {
            switch self {
            case .object(let obj): return obj
            default: return nil
            }
        }
        set {
            self = newValue.map(JSON.object) ?? nil
        }
    }
    
    /// Returns the array if the receiver is `.array`, otherwise `nil`.
    ///
    /// When setting, replaces the receiver with the given array value, or with
    /// null if the value is `nil`.
    var array: JSONArray? {
        get {
            switch self {
            case .array(let ary): return ary
            default: return nil
            }
        }
        set {
            self = newValue.map(JSON.array) ?? nil
        }
    }
}

public extension JSON {
    /// Returns the string value if the receiver is `.string`, coerces the value to a string if
    /// the receiver is `.bool`, `.null`, `.int64`, `.double`, or `.decimal, or otherwise returns `nil`.
    ///
    /// - Note: `.decimal` is only supported on platforms with `Decimal`. On platforms without it,
    ///   the `.decimal` dummy value returns `nil`.
    var asString: String? {
        return try? toString()
    }
    
    /// Returns the 64-bit integral value if the receiver is `.int64`, `.double`, or `.decimal`, coerces the value
    /// if the receiver is `.string`, otherwise returns `nil`.
    /// If the receiver is `.double`, the value is truncated. If it does not fit in 64 bits, `nil` is returned.
    /// If the receiver is `.decimal`, the value is returned using `NSDecimalNumber.int64Value`. If it does not fit
    /// in 64 bits, `nil` is returned.
    /// If the receiver is `.string`, it must parse fully as an integral or floating-point number.
    /// If it parses as a floating-point number, it is truncated. If it does not fit in 64 bits, `nil` is returned.
    var asInt64: Int64? {
        return try? toInt64()
    }
    
    /// Returns the integral value if the receiver is `.int64`, `.double`, or `.decimal`, coerces the value
    /// if the receiver is `.string`, otherwise returns `nil`.
    /// If the receiver is `.double`, the value is truncated. If it does not fit in an `Int`, `nil` is returned.
    /// If the receiver is `.decimal`, the value is returned using `NSDecimalNumber.int64Value`. If it does not fit
    /// in an `Int`, `nil` is returned.
    /// If the receiver is `.string`, it must parse fully as an integral or floating-point number.
    /// If it parses as a floating-point number, it is truncated. If it does not fit in an `Int`, `nil` is returned.
    var asInt: Int? {
        return try? toInt()
    }
    
    /// Returns the double value if the receiver is `.int64`, `.double`, or `.decimal`, coerces the value
    /// if the receiver is `.string`, otherwise returns `nil`.
    /// If the receiver is `.string`, it must parse fully as a floating-point number.
    var asDouble: Double? {
        return try? toDouble()
    }
}

public extension JSON {
    /// If the receiver is `.object`, returns the result of subscripting the object.
    /// Otherwise, returns `nil`.
    subscript(key: String) -> JSON? {
        return self.object?[key]
    }
    
    /// If the receiver is `.array` and the index is in range of the array, returns the result of subscripting the array.
    /// Otherwise returns `nil`.
    subscript(index: Int) -> JSON? {
        guard let ary = self.array else { return nil }
        guard index >= ary.startIndex && index < ary.endIndex else { return nil }
        return ary[index]
    }
}

internal func convertDoubleToInt64(_ d: Double) -> Int64? {
    // Int64(Double(Int64.max)) asserts because it interprets it as out of bounds.
    // Int64(Double(Int64.min)) works just fine.
    if d >= Double(Int64.max) || d < Double(Int64.min) {
        return nil
    }
    return Int64(d)
}

internal func convertDecimalToInt64(_ d: Decimal) -> Int64? {
    if d > Int64.maxDecimal || d < Int64.minDecimal {
        return nil
    }
    // NB: Decimal does not have any appropriate accessor
    return NSDecimalNumber(decimal: d).int64Value
}

internal func convertDecimalToUInt64(_ d: Decimal) -> UInt64? {
    if d > UInt64.maxDecimal || d < UInt64.minDecimal {
        return nil
    }
    // NB: Decimal does not have any appropriate accessor
    return NSDecimalNumber(decimal: d).uint64Value
}
