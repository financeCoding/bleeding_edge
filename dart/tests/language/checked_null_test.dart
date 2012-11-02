// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class A {
  Map a;
  Comparator b;
  // This code exhibited a bug in dart2js checked mode, where the type
  // of [a] was inferred to be [Comparator] or null;
  A() : b = null, a = null;
}

main() { 
  Expect.throws(bar, (e) => e is NullPointerException);
}

bar() {
  // We would create a typed selector for the call to foo, where the
  // receiver type is a typedef. Some code in the dart2js backend were
  // not dealing correctly with typedefs and lead the compiler to
  // crash.
  new A().a.foo();
}