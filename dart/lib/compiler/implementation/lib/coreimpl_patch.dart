// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Patch file for dart:core's Date class.

patch class DateImplementation {
  patch DateImplementation(int years,
                           [int month = 1,
                            int day = 1,
                            int hour = 0,
                            int minute = 0,
                            int second = 0,
                            int millisecond = 0,
                            bool isUtc = false])
      : this.isUtc = checkNull(isUtc),
        millisecondsSinceEpoch = Primitives.valueFromDecomposedDate(
            years, month, day, hour, minute, second, millisecond, isUtc) {
    Primitives.lazyAsJsDate(this);
  }

  patch DateImplementation.now()
      : isUtc = false,
        millisecondsSinceEpoch = Primitives.dateNow() {
    Primitives.lazyAsJsDate(this);
  }

  patch String get timeZoneName() {
    if (isUtc) return "UTC";
    return Primitives.getTimeZoneName(this);
  }

  patch Duration get timeZoneOffset() {
    if (isUtc) return new Duration(0);
    return new Duration(minutes: Primitives.getTimeZoneOffsetInMinutes(this));
  }

  patch int get year() => Primitives.getYear(this);

  patch int get month() => Primitives.getMonth(this);

  patch int get day() => Primitives.getDay(this);

  patch int get hour() => Primitives.getHours(this);

  patch int get minute() => Primitives.getMinutes(this);

  patch int get second() => Primitives.getSeconds(this);

  patch int get millisecond() => Primitives.getMilliseconds(this);

  patch int get weekday() => Primitives.getWeekday(this);
}