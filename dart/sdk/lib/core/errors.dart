// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Error {
  const Error();
}

/**
 * Error thrown by the runtime system when an assert statement fails.
 */
class AssertionError implements Error {
}

/**
 * Error thrown by the runtime system when a type assertion fails.
 */
class TypeError implements AssertionError {
}

/**
 * Error thrown by the runtime system when a cast operation fails.
 */
class CastError implements Error {
}

/**
 * Error thrown when a function is passed an unacceptable argument.
 */
class ArgumentError implements Error {
  final message;

  /** The [message] describes the erroneous argument. */
  const ArgumentError([this.message]);

  String toString() {
    if (message != null) {
      return "Illegal argument(s): $message";
    }
    return "Illegal argument(s)";
  }
}

/**
 * Exception thrown because of an index outside of the valid range.
 *
 * Temporarily implements [IndexOutOfRangeException] for backwards compatiblity.
 */
class RangeError extends ArgumentError implements IndexOutOfRangeException {
  // TODO(lrn): This constructor should be called only with string values.
  // It currently isn't in all cases.
  /**
   * Create a new [RangeError] with the given [message].
   *
   * Temporarily made const for backwards compatibilty.
   */
  const RangeError(var message) : super(message);

  /** Create a new [RangeError] with a message for the given [value]. */
  RangeError.value(num value) : super("value $value");

  String toString() => "RangeError: $message";
}

/**
 * Temporary backwards compatibilty class.
 *
 * This class allows code throwing the old [IndexOutOfRangeException] to
 * work until they change to the new [RangeError] name.
 * Constructor of [RangeError] is const only to support this interface.
 */
interface IndexOutOfRangeException extends Exception default RangeError {
  const IndexOutOfRangeException(var message);
}


/**
 * Temporary backwards compatibility class.
 *
 * Removed when users have had time to change to using [ArgumentError].
 */
class IllegalArgumentException extends ArgumentError {
  const IllegalArgumentException([argument = ""]) : super(argument);
}

/**
 * Error thrown when control reaches the end of a switch case.
 *
 * The Dart specification requires this error to be thrown when
 * control reaches the end of a switch case (except the last case
 * of a switch) without meeting a break or similar end of the control
 * flow.
 */
class FallThroughError implements Error {
  const FallThroughError();
}

class AbstractClassInstantiationError implements Error {
  final String _className;
  const AbstractClassInstantiationError(String this._className);
  String toString() => "Cannot instantiate abstract class: '$_className'";
}

/**
 * Error thrown by the default implementation of [:noSuchMethod:] on [Object].
 */
class NoSuchMethodError implements Error {
  final Object _receiver;
  final String _memberName;
  final List _arguments;
  final Map<String,Dynamic> _namedArguments;
  final List _existingArgumentNames;

  /**
   * Create a [NoSuchMethodError] corresponding to a failed method call.
   *
   * The first parameter to this constructor is the receiver of the method call.
   * That is, the object on which the method was attempted called.
   * The second parameter is the name of the called method or accessor.
   * The third parameter is a list of the positional arguments that the method
   * was called with.
   * The fourth parameter is a map from [String] names to the values of named
   * arguments that the method was called with.
   * The optional [exisitingArgumentNames] is the expected parameters of a
   * method with the same name on the receiver, if available. This is
   * the method that would have been called if the parameters had matched.
   */
  const NoSuchMethodError(Object this._receiver,
                          String this._memberName,
                          List this._arguments,
                          Map<String,Dynamic> this._namedArguments,
                          [List existingArgumentNames = null])
      : this._existingArgumentNames = existingArgumentNames;

  String toString() {
    StringBuffer sb = new StringBuffer();
    int i = 0;
    if (_arguments != null) {
      for (; i < _arguments.length; i++) {
        if (i > 0) {
          sb.add(", ");
        }
        sb.add(safeToString(_arguments[i]));
      }
    }
    if (_namedArguments != null) {
      _namedArguments.forEach((String key, var value) {
        if (i > 0) {
          sb.add(", ");
        }
        sb.add(key);
        sb.add(": ");
        sb.add(safeToString(value));
        i++;
      });
    }
    if (_existingArgumentNames === null) {
      return "NoSuchMethodError : method not found: '$_memberName'\n"
          "Receiver: ${safeToString(_receiver)}\n"
          "Arguments: [$sb]";
    } else {
      String actualParameters = sb.toString();
      sb = new StringBuffer();
      for (int i = 0; i < _existingArgumentNames.length; i++) {
        if (i > 0) {
          sb.add(", ");
        }
        sb.add(_existingArgumentNames[i]);
      }
      String formalParameters = sb.toString();
      return "NoSuchMethodError: incorrect number of arguments passed to "
          "method named '$_memberName'\n"
          "Receiver: ${safeToString(_receiver)}\n"
          "Tried calling: $_memberName($actualParameters)\n"
          "Found: $_memberName($formalParameters)";
    }
  }

  static String safeToString(Object object) {
    if (object is int || object is double || object is bool || null == object) {
      return object.toString();
    }
    if (object is String) {
      // TODO(ahe): Remove backslash when http://dartbug.com/4995 is fixed.
      const backslash = '\\';
      String escaped = object
        .replaceAll('$backslash', '$backslash$backslash')
        .replaceAll('\n', '${backslash}n')
        .replaceAll('\r', '${backslash}r')
        .replaceAll('"',  '$backslash"');
      return '"$escaped"';
    }
    return _objectToString(object);
  }

  external static String _objectToString(Object object);
}


/**
 * The operation was not allowed by the object.
 *
 * This [Error] is thrown when a class cannot implement
 * one of the methods in its signature.
 */
class UnsupportedError implements Error {
  final String message;
  UnsupportedError(this.message);
  String toString() => "Unsupported operation: $message";
}


/**
 * Thrown by operations that have not been implemented yet.
 *
 * This [Error] is thrown by unfinished code that hasn't yet implemented
 * all the features it needs.
 *
 * If a class is not intending to implement the feature, it should throw
 * an [UnsupportedError] instead. This error is only intended for
 * use during development.
 *
 * This class temporarily implements [Exception] for backwards compatibility.
 * The constructor is temporarily const to support [NotImplementedException].
 */
class UnimplementedError implements UnsupportedError, NotImplementedException {
  final String message;
  const UnimplementedError([String this.message]);
  String toString() => (this.message !== null
                        ? "UnimplementedError: $message"
                        : "UnimplementedError");
}


/** Temporary class added for backwards compatibility. Will be removed. */
interface NotImplementedException extends Exception default UnimplementedError {
  const NotImplementedException([String message]);
}


/**
 * The operation was not allowed by the current state of the object.
 *
 * This is a generic error used for a variety of different erroneous
 * actions. The message should be descriptive.
 */
class StateError implements Error {
  final String message;
  StateError(this.message);
  String toString() => "Bad state: $message";
}


class OutOfMemoryError implements Error {
  const OutOfMemoryError();
  String toString() => "Out of Memory";
}

class StackOverflowError implements Error {
  const StackOverflowError();
  String toString() => "Stack Overflow";
}
