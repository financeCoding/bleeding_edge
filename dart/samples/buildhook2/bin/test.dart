// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:io";

/**
 * In order to generate test.foobar, make an edit to test.foo.
 */
void main() {
  printContents("test.foo");
  print("");
  printContents("test.foobar");
}

void printContents(String file) {
  print("the contents of ${file} are:");

  var f = new File(file);

  if (f.existsSync()) {
    String contents = new File(file).readAsTextSync();

    print("[${contents}]");
  } else {
    print("[]");
  }
}
