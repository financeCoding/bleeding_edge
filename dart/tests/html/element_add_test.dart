// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file

library ElementAddTest;
import '../../pkg/unittest/lib/unittest.dart';
import '../../pkg/unittest/lib/html_config.dart';
import 'dart:html';
part 'util.dart';

main() {
  useHtmlConfiguration();

  var isSpanElement = predicate((x) => x is SpanElement, 'is a SpanElemt');
  var isDivElement = predicate((x) => x is DivElement, 'is a DivElement');
  var isText = predicate((x) => x is Text, 'is a Text');

  void expectNoSuchMethod(void fn()) =>
    expect(fn, throwsNoSuchMethodError);

  group('addHTML', () {
    test('htmlelement', () {
      var el = new DivElement();
      el.addHTML('<span></span>');
      expect(el.elements.length, equals(1));
      var span = el.elements[0];
      expect(span, isSpanElement);

      el.addHTML('<div></div>');
      expect(el.elements.length, equals(2));
      // Validate that the first item is still first.
      expect(el.elements[0], equals(span));
      expect(el.elements[1], isDivElement);
    });

    test('documentFragment', () {
      var fragment = new DocumentFragment();
      fragment.addHTML('<span>something</span>');
      expect(fragment.elements.length, equals(1));
      expect(fragment.elements[0], isSpanElement);
    });
  });

  group('addText', () {
    test('htmlelement', () {
      var el = new DivElement();
      el.addText('foo');
      // No elements were created.
      expect(el.elements.length, equals(0));
      // One text node was added.
      expect(el.nodes.length, equals(1));
    });

    test('documentFragment', () {
      var fragment = new DocumentFragment();
      fragment.addText('foo');
      // No elements were created.
      expect(fragment.elements.length, equals(0));
      // One text node was added.
      expect(fragment.nodes.length, equals(1));
    });
  });

  group('insertAdjacentElement', () {
    test('beforebegin', () {
      var parent = new DivElement();
      var child = new DivElement();
      var newChild = new SpanElement();
      parent.elements.add(child);

      child.insertAdjacentElement('beforebegin', newChild);

      expect(parent.elements.length, 2);
      expect(parent.elements[0], isSpanElement);
    });

    test('afterend', () {
      var parent = new DivElement();
      var child = new DivElement();
      var newChild = new SpanElement();
      parent.elements.add(child);

      child.insertAdjacentElement('afterend', newChild);

      expect(parent.elements.length, 2);
      expect(parent.elements[1], isSpanElement);
    });

    test('afterbegin', () {
      var parent = new DivElement();
      var child = new DivElement();
      var newChild = new SpanElement();
      parent.elements.add(child);

      parent.insertAdjacentElement('afterbegin', newChild);

      expect(parent.elements.length, 2);
      expect(parent.elements[0], isSpanElement);
    });

    test('beforeend', () {
      var parent = new DivElement();
      var child = new DivElement();
      var newChild = new SpanElement();
      parent.elements.add(child);

      parent.insertAdjacentElement('beforeend', newChild);

      expect(parent.elements.length, 2);
      expect(parent.elements[1], isSpanElement);
    });
  });

  group('insertAdjacentHTML', () {
    test('beforebegin', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      child.insertAdjacentHTML('beforebegin', '<span></span>');

      expect(parent.elements.length, 2);
      expect(parent.elements[0], isSpanElement);
    });

    test('afterend', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      child.insertAdjacentHTML('afterend', '<span></span>');

      expect(parent.elements.length, 2);
      expect(parent.elements[1], isSpanElement);
    });

    test('afterbegin', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      parent.insertAdjacentHTML('afterbegin', '<span></span>');

      expect(parent.elements.length, 2);
      expect(parent.elements[0], isSpanElement);
    });

    test('beforeend', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      parent.insertAdjacentHTML('beforeend', '<span></span>');

      expect(parent.elements.length, 2);
      expect(parent.elements[1], isSpanElement);
    });
  });

  group('insertAdjacentText', () {
    test('beforebegin', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      child.insertAdjacentText('beforebegin', 'test');

      expect(parent.nodes.length, 2);
      expect(parent.nodes[0], isText);
    });

    test('afterend', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      child.insertAdjacentText('afterend', 'test');

      expect(parent.nodes.length, 2);
      expect(parent.nodes[1], isText);
    });

    test('afterbegin', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      parent.insertAdjacentText('afterbegin', 'test');

      expect(parent.nodes.length, 2);
      expect(parent.nodes[0], isText);
    });

    test('beforeend', () {
      var parent = new DivElement();
      var child = new DivElement();
      parent.elements.add(child);

      parent.insertAdjacentText('beforeend', 'test');

      expect(parent.nodes.length, 2);
      expect(parent.nodes[1], isText);
    });
  });
}
