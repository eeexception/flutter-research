// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show Display;
import 'package:flutter/src/foundation/_features.dart' show isWindowingEnabled;
import 'package:flutter/src/widgets/_window.dart'
    show
        BaseWindowController,
        DialogWindow,
        DialogWindowController,
        DialogWindowControllerDelegate,
        PopupWindow,
        PopupWindowController,
        PopupWindowControllerDelegate,
        RegularWindow,
        RegularWindowController,
        RegularWindowControllerDelegate,
        SatelliteWindow,
        SatelliteWindowController,
        SatelliteWindowControllerDelegate,
        TooltipWindow,
        TooltipWindowController,
        TooltipWindowControllerDelegate,
        WindowDecorations,
        WindowScope,
        WindowingOwner,
        createDefaultWindowingOwner;
import 'package:flutter/src/widgets/_window_positioner.dart' show WindowPositioner;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'multi_view_testing.dart';

class _StubRegularWindowController extends RegularWindowController {
  _StubRegularWindowController(WidgetTester tester) : super.empty() {
    rootView = FakeView(tester.view);
  }

  @override
  Size get contentSize => Size.zero;

  @override
  String get title => 'Stub Window';

  @override
  bool get isActivated => true;

  @override
  bool get isMaximized => false;

  @override
  bool get isMinimized => false;

  @override
  bool get isFullscreen => false;

  @override
  void setSize(Size size) {}

  @override
  void setConstraints(BoxConstraints constraints) {}

  @override
  void setTitle(String title) {}

  @override
  void activate() {}

  @override
  void setMaximized(bool maximized) {}

  @override
  void setMinimized(bool minimized) {}

  @override
  void setFullscreen(bool fullscreen, {Display? display}) {}

  @override
  void destroy() {}
}

class _StubDialogWindowController extends DialogWindowController {
  _StubDialogWindowController(WidgetTester tester) : super.empty() {
    rootView = FakeView(tester.view);
  }

  @override
  BaseWindowController? get parent => null;

  @override
  Size get contentSize => Size.zero;

  @override
  String get title => 'Stub Window';

  @override
  bool get isActivated => true;

  @override
  bool get isMinimized => false;

  @override
  void setSize(Size size) {}

  @override
  void setConstraints(BoxConstraints constraints) {}

  @override
  void setTitle(String title) {}

  @override
  void activate() {}

  @override
  void setMinimized(bool minimized) {}

  @override
  void destroy() {}
}

class _StubTooltipWindowController extends TooltipWindowController {
  _StubTooltipWindowController({required this.tester}) : super.empty() {
    rootView = FakeView(tester.view);
  }

  final WidgetTester tester;

  @override
  BaseWindowController get parent => _StubRegularWindowController(tester);

  @override
  Size get contentSize => Size.zero;

  @override
  void setConstraints(BoxConstraints constraints) {}

  @override
  void updatePosition({Rect? anchorRect, WindowPositioner? positioner}) {}

  @override
  void destroy() {}
}

class _StubPopupWindowController extends PopupWindowController {
  _StubPopupWindowController({required this.tester}) : super.empty() {
    rootView = FakeView(tester.view);
  }

  final WidgetTester tester;

  @override
  BaseWindowController get parent => _StubRegularWindowController(tester);

  @override
  bool get isActivated => true;

  @override
  Size get contentSize => Size.zero;

  @override
  void activate() {}

  @override
  void setConstraints(BoxConstraints constraints) {}

  @override
  void destroy() {}
}

class _StubSatelliteWindowController extends SatelliteWindowController {
  _StubSatelliteWindowController({required this.tester}) : super.empty() {
    rootView = FakeView(tester.view);
  }

  final WidgetTester tester;

  @override
  BaseWindowController get parent => _StubRegularWindowController(tester);

  @override
  Size get contentSize => Size.zero;

  @override
  String get title => 'Stub Satellite Window';

  @override
  bool get isActivated => true;

  @override
  void setParent(BaseWindowController parent) {}

  @override
  void setSize(Size size) {}

  @override
  void setConstraints(BoxConstraints constraints) {}

  @override
  void setTitle(String title) {}

  @override
  void activate() {}

  @override
  void destroy() {}
}

/// A [WindowingOwner] that records arguments passed to its factory methods so
/// tests can verify that [RegularWindowController]'s factory and
/// [WindowingOwner.createDecoratedRegularWindowController] route correctly.
///
/// Only [createRegularWindowController] is implemented; all other factories
/// throw because the decoration API only concerns regular windows.
class _RecordingWindowingOwner extends WindowingOwner {
  _RecordingWindowingOwner(this._tester);

  final WidgetTester _tester;

  int createRegularCalls = 0;
  int createDecoratedCalls = 0;
  WindowDecorations? lastDecorations;
  Size? lastPreferredSize;
  String? lastTitle;

  @override
  RegularWindowController createRegularWindowController({
    required RegularWindowControllerDelegate delegate,
    Size? preferredSize,
    BoxConstraints? preferredConstraints,
    String? title,
  }) {
    createRegularCalls++;
    lastPreferredSize = preferredSize;
    lastTitle = title;
    return _StubRegularWindowController(_tester);
  }

  @override
  RegularWindowController createDecoratedRegularWindowController({
    required RegularWindowControllerDelegate delegate,
    Size? preferredSize,
    BoxConstraints? preferredConstraints,
    String? title,
    required WindowDecorations decorations,
  }) {
    createDecoratedCalls++;
    lastDecorations = decorations;
    return super.createDecoratedRegularWindowController(
      delegate: delegate,
      preferredSize: preferredSize,
      preferredConstraints: preferredConstraints,
      title: title,
      decorations: decorations,
    );
  }

  @override
  DialogWindowController createDialogWindowController({
    required DialogWindowControllerDelegate delegate,
    Size? preferredSize,
    BoxConstraints? preferredConstraints,
    BaseWindowController? parent,
    String? title,
  }) => throw UnimplementedError();

  @override
  TooltipWindowController createTooltipWindowController({
    required TooltipWindowControllerDelegate delegate,
    required BoxConstraints preferredConstraints,
    required bool isSizedToContent,
    required Rect anchorRect,
    required WindowPositioner positioner,
    required BaseWindowController parent,
  }) => throw UnimplementedError();

  @override
  PopupWindowController createPopupWindowController({
    required PopupWindowControllerDelegate delegate,
    required BoxConstraints preferredConstraints,
    required Rect anchorRect,
    required WindowPositioner positioner,
    required BaseWindowController parent,
  }) => throw UnimplementedError();

  @override
  SatelliteWindowController createSatelliteWindowController({
    required SatelliteWindowControllerDelegate delegate,
    required BaseWindowController parent,
    required WindowPositioner initialPositioner,
    Rect? initialAnchorRect,
    Size? preferredSize,
    BoxConstraints? preferredConstraints,
    String? title,
  }) => throw UnimplementedError();
}

void main() {
  group('Windowing', () {
    group('isWindowingEnabled is false', () {
      setUp(() {
        isWindowingEnabled = false;
      });

      test('createDefaultOwner returns a WindowingOwner', () {
        final WindowingOwner owner = createDefaultWindowingOwner();
        expect(owner, isA<WindowingOwner>());
      });

      test('default WindowingOwner throws when accessing createRegularWindowController', () {
        final WindowingOwner owner = createDefaultWindowingOwner();
        expect(
          () => owner.createRegularWindowController(delegate: RegularWindowControllerDelegate()),
          throwsUnsupportedError,
        );
      });

      test(
        'default WindowingOwner throws when accessing createDecoratedRegularWindowController',
        () {
          final WindowingOwner owner = createDefaultWindowingOwner();
          // The default implementation of createDecoratedRegularWindowController
          // delegates to createRegularWindowController, which throws on the
          // unsupported owner.
          expect(
            () => owner.createDecoratedRegularWindowController(
              delegate: RegularWindowControllerDelegate(),
              decorations: WindowDecorations.all,
            ),
            throwsUnsupportedError,
          );
        },
      );

      test('default WindowingOwner throws when accessing createDialogWindowController', () {
        final WindowingOwner owner = createDefaultWindowingOwner();
        expect(
          () => owner.createDialogWindowController(delegate: DialogWindowControllerDelegate()),
          throwsUnsupportedError,
        );
      });

      testWidgets('DialogWindow throws UnsupportedError', (WidgetTester tester) async {
        expect(
          () => DialogWindow(
            controller: _StubDialogWindowController(tester),
            child: const Text('Test'),
          ),
          throwsUnsupportedError,
        );
      });

      testWidgets('TooltipWindow throws UnsupportedError', (WidgetTester tester) async {
        expect(
          () => TooltipWindow(
            controller: _StubTooltipWindowController(tester: tester),
            child: const Text('Test'),
          ),
          throwsUnsupportedError,
        );
      });

      testWidgets('PopupWindow throws UnsupportedError', (WidgetTester tester) async {
        expect(
          () => PopupWindow(
            controller: _StubPopupWindowController(tester: tester),
            child: const Text('Test'),
          ),
          throwsUnsupportedError,
        );
      });

      testWidgets('SatelliteWindow throws UnsupportedError', (WidgetTester tester) async {
        expect(
          () => SatelliteWindow(
            controller: _StubSatelliteWindowController(tester: tester),
            child: const Text('Test'),
          ),
          throwsUnsupportedError,
        );
      });

      testWidgets('Accessing WindowScope.of throws UnsupportedError', (WidgetTester tester) async {
        await tester.pumpWidget(LookupBoundary(child: Container()));
        final BuildContext context = tester.element(find.byType(Container));

        expect(() => WindowScope.of(context), throwsUnsupportedError);
      });
    });

    group('isWindowingEnabled is true', () {
      setUp(() {
        isWindowingEnabled = true;
      });

      test('WindowDecorations.all enables every decoration', () {
        const WindowDecorations all = WindowDecorations.all;
        expect(all.hasTitleBar, isTrue);
        expect(all.hasBorder, isTrue);
        expect(all.hasCloseButton, isTrue);
        expect(all.hasMinimizeButton, isTrue);
        expect(all.hasMaximizeButton, isTrue);
        expect(all.isResizable, isTrue);
        expect(all.hasShadow, isTrue);
        // ignore: use_named_constants, intentionally verifying .all == default ctor
        expect(all, equals(const WindowDecorations()));
        // ignore: use_named_constants
        expect(all.hashCode, equals(const WindowDecorations().hashCode));
      });

      test('WindowDecorations.none disables every decoration', () {
        const WindowDecorations none = WindowDecorations.none;
        expect(none.hasTitleBar, isFalse);
        expect(none.hasBorder, isFalse);
        expect(none.hasCloseButton, isFalse);
        expect(none.hasMinimizeButton, isFalse);
        expect(none.hasMaximizeButton, isFalse);
        expect(none.isResizable, isFalse);
        expect(none.hasShadow, isFalse);
        expect(none, isNot(equals(WindowDecorations.all)));
      });

      test('WindowDecorations equality distinguishes each field', () {
        expect(
          const WindowDecorations(hasTitleBar: false),
          isNot(equals(WindowDecorations.all)),
        );
        expect(
          const WindowDecorations(hasBorder: false),
          isNot(equals(WindowDecorations.all)),
        );
        expect(
          const WindowDecorations(hasCloseButton: false),
          isNot(equals(WindowDecorations.all)),
        );
        expect(
          const WindowDecorations(hasMinimizeButton: false),
          isNot(equals(WindowDecorations.all)),
        );
        expect(
          const WindowDecorations(hasMaximizeButton: false),
          isNot(equals(WindowDecorations.all)),
        );
        expect(
          const WindowDecorations(isResizable: false),
          isNot(equals(WindowDecorations.all)),
        );
        expect(
          const WindowDecorations(hasShadow: false),
          isNot(equals(WindowDecorations.all)),
        );
      });

      test('WindowDecorations.copyWith replaces only specified fields', () {
        // copyWith with no arguments yields an identical value.
        expect(WindowDecorations.all.copyWith(), equals(WindowDecorations.all));
        expect(WindowDecorations.none.copyWith(), equals(WindowDecorations.none));
        // Combining several overrides works.
        expect(
          WindowDecorations.all.copyWith(isResizable: false, hasShadow: false),
          equals(const WindowDecorations(isResizable: false, hasShadow: false)),
        );
        // Each field can be toggled independently in either direction.
        expect(
          WindowDecorations.all.copyWith(hasTitleBar: false),
          equals(const WindowDecorations(hasTitleBar: false)),
        );
        expect(
          WindowDecorations.none.copyWith(hasTitleBar: true),
          equals(const WindowDecorations(
            hasBorder: false,
            hasCloseButton: false,
            hasMinimizeButton: false,
            hasMaximizeButton: false,
            isResizable: false,
            hasShadow: false,
          )),
        );
        expect(
          WindowDecorations.all.copyWith(hasBorder: false),
          equals(const WindowDecorations(hasBorder: false)),
        );
        expect(
          WindowDecorations.none.copyWith(hasBorder: true),
          equals(const WindowDecorations(
            hasTitleBar: false,
            hasCloseButton: false,
            hasMinimizeButton: false,
            hasMaximizeButton: false,
            isResizable: false,
            hasShadow: false,
          )),
        );
        expect(
          WindowDecorations.all.copyWith(hasCloseButton: false),
          equals(const WindowDecorations(hasCloseButton: false)),
        );
        expect(
          WindowDecorations.none.copyWith(hasCloseButton: true),
          equals(const WindowDecorations(
            hasTitleBar: false,
            hasBorder: false,
            hasMinimizeButton: false,
            hasMaximizeButton: false,
            isResizable: false,
            hasShadow: false,
          )),
        );
        expect(
          WindowDecorations.all.copyWith(hasMinimizeButton: false),
          equals(const WindowDecorations(hasMinimizeButton: false)),
        );
        expect(
          WindowDecorations.none.copyWith(hasMinimizeButton: true),
          equals(const WindowDecorations(
            hasTitleBar: false,
            hasBorder: false,
            hasCloseButton: false,
            hasMaximizeButton: false,
            isResizable: false,
            hasShadow: false,
          )),
        );
        expect(
          WindowDecorations.all.copyWith(hasMaximizeButton: false),
          equals(const WindowDecorations(hasMaximizeButton: false)),
        );
        expect(
          WindowDecorations.none.copyWith(hasMaximizeButton: true),
          equals(const WindowDecorations(
            hasTitleBar: false,
            hasBorder: false,
            hasCloseButton: false,
            hasMinimizeButton: false,
            isResizable: false,
            hasShadow: false,
          )),
        );
        expect(
          WindowDecorations.all.copyWith(isResizable: false),
          equals(const WindowDecorations(isResizable: false)),
        );
        expect(
          WindowDecorations.none.copyWith(isResizable: true),
          equals(const WindowDecorations(
            hasTitleBar: false,
            hasBorder: false,
            hasCloseButton: false,
            hasMinimizeButton: false,
            hasMaximizeButton: false,
            hasShadow: false,
          )),
        );
        expect(
          WindowDecorations.all.copyWith(hasShadow: false),
          equals(const WindowDecorations(hasShadow: false)),
        );
        expect(
          WindowDecorations.none.copyWith(hasShadow: true),
          equals(const WindowDecorations(
            hasTitleBar: false,
            hasBorder: false,
            hasCloseButton: false,
            hasMinimizeButton: false,
            hasMaximizeButton: false,
            isResizable: false,
          )),
        );
      });

      test('WindowDecorations.hashCode distinguishes each field', () {
        expect(
          const WindowDecorations(hasTitleBar: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(
          const WindowDecorations(hasBorder: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(
          const WindowDecorations(hasCloseButton: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(
          const WindowDecorations(hasMinimizeButton: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(
          const WindowDecorations(hasMaximizeButton: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(
          const WindowDecorations(isResizable: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(
          const WindowDecorations(hasShadow: false).hashCode,
          isNot(equals(WindowDecorations.all.hashCode)),
        );
        expect(WindowDecorations.none.hashCode, isNot(equals(WindowDecorations.all.hashCode)));
      });

      test('WindowDecorations.toString reflects every field', () {
        expect(
          WindowDecorations.all.toString(),
          equals(
            'WindowDecorations('
            'hasTitleBar: true, '
            'hasBorder: true, '
            'hasCloseButton: true, '
            'hasMinimizeButton: true, '
            'hasMaximizeButton: true, '
            'isResizable: true, '
            'hasShadow: true)',
          ),
        );
        expect(
          WindowDecorations.none.toString(),
          equals(
            'WindowDecorations('
            'hasTitleBar: false, '
            'hasBorder: false, '
            'hasCloseButton: false, '
            'hasMinimizeButton: false, '
            'hasMaximizeButton: false, '
            'isResizable: false, '
            'hasShadow: false)',
          ),
        );
      });

      testWidgets(
        'RegularWindowController base class exposes default decorations and a no-op setter',
        (WidgetTester tester) async {
          final controller = _StubRegularWindowController(tester);
          addTearDown(controller.dispose);

          // The stub does not override decorations/setDecorations so the
          // base-class concrete implementations are used.
          expect(controller.decorations, equals(WindowDecorations.all));

          controller.setDecorations(WindowDecorations.none);
          // The base-class setter is a no-op: the value is unchanged.
          expect(controller.decorations, equals(WindowDecorations.all));
        },
      );

      testWidgets(
        'WindowingOwner.createDecoratedRegularWindowController delegates to '
        'createRegularWindowController by default',
        (WidgetTester tester) async {
          final owner = _RecordingWindowingOwner(tester);

          final RegularWindowController controller =
              owner.createDecoratedRegularWindowController(
            delegate: RegularWindowControllerDelegate(),
            preferredSize: const Size(640, 480),
            title: 'hello',
            decorations: WindowDecorations.none,
          );
          addTearDown(controller.dispose);

          expect(owner.createDecoratedCalls, 1);
          // The default implementation calls through to the undecorated
          // factory, forwarding every argument except decorations.
          expect(owner.createRegularCalls, 1);
          expect(owner.lastDecorations, equals(WindowDecorations.none));
          expect(owner.lastPreferredSize, equals(const Size(640, 480)));
          expect(owner.lastTitle, equals('hello'));
        },
      );

      testWidgets(
        'RegularWindowController factory routes through '
        'WindowingOwner.createDecoratedRegularWindowController',
        (WidgetTester tester) async {
          final owner = _RecordingWindowingOwner(tester);
          final WindowingOwner previous = WidgetsBinding.instance.windowingOwner;
          WidgetsBinding.instance.windowingOwner = owner;
          addTearDown(() => WidgetsBinding.instance.windowingOwner = previous);

          final undecorated = RegularWindowController(title: 'default');
          addTearDown(undecorated.dispose);
          // When no decorations argument is given the factory still goes
          // through createDecoratedRegularWindowController with
          // WindowDecorations.all.
          expect(owner.createDecoratedCalls, 1);
          expect(owner.createRegularCalls, 1);
          expect(owner.lastDecorations, equals(WindowDecorations.all));
          expect(owner.lastTitle, equals('default'));

          final decorated = RegularWindowController(
            decorations: const WindowDecorations(hasTitleBar: false),
          );
          addTearDown(decorated.dispose);
          expect(owner.createDecoratedCalls, 2);
          expect(owner.createRegularCalls, 2);
          expect(
            owner.lastDecorations,
            equals(const WindowDecorations(hasTitleBar: false)),
          );
        },
      );

      testWidgets('RegularWindow does not throw', (WidgetTester tester) async {
        final controller = _StubRegularWindowController(tester);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(controller: controller, child: Container()),
        );
      });

      testWidgets('Dialog does not throw', (WidgetTester tester) async {
        final controller = _StubDialogWindowController(tester);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(controller: controller, child: Container()),
        );
      });

      testWidgets('Can access WindowScope.of for regular windows', (WidgetTester tester) async {
        final controller = _StubRegularWindowController(tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<RegularWindowController>());
      });

      testWidgets('Can access WindowScope.of for dialog windows', (WidgetTester tester) async {
        final controller = _StubDialogWindowController(tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<DialogWindowController>());
      });

      testWidgets('Can access WindowScope.of for tooltip windows', (WidgetTester tester) async {
        final controller = _StubTooltipWindowController(tester: tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<TooltipWindowController>());
      });

      testWidgets('Can access WindowScope.of for popup windows', (WidgetTester tester) async {
        final controller = _StubPopupWindowController(tester: tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<PopupWindowController>());
      });

      testWidgets('Can access WindowScope.of for satellite windows', (WidgetTester tester) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<SatelliteWindowController>());
      });

      testWidgets('Can access WindowScope.maybeOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<RegularWindowController>());
      });

      testWidgets('Can access WindowScope.maybeOf for dialog windows', (WidgetTester tester) async {
        final controller = _StubDialogWindowController(tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<DialogWindowController>());
      });

      testWidgets('Can access WindowScope.maybeOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<TooltipWindowController>());
      });

      testWidgets('Can access WindowScope.maybeOf for popup windows', (WidgetTester tester) async {
        final controller = _StubPopupWindowController(tester: tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<PopupWindowController>());
      });

      testWidgets('Can access WindowScope.maybeOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        BaseWindowController? scope;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                scope = WindowScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(scope, isA<SatelliteWindowController>());
      });

      testWidgets('Can access WindowScope.contentSizeOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.contentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.contentSizeOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.contentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.contentSizeOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.contentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.contentSizeOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.contentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.contentSizeOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.contentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.maybeContentSizeOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.maybeContentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.maybeContentSizeOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.maybeContentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.maybeContentSizeOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.maybeContentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.maybeContentSizeOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.maybeContentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.maybeContentSizeOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        Size? size;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                size = WindowScope.maybeContentSizeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(size, equals(Size.zero));
      });

      testWidgets('Can access WindowScope.titleOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.titleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals('Stub Window'));
      });

      testWidgets('Can access WindowScope.titleOf for dialog windows', (WidgetTester tester) async {
        final controller = _StubDialogWindowController(tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.titleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals('Stub Window'));
      });

      testWidgets('Can access WindowScope.titleOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.titleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals(''));
      });

      testWidgets('Can access WindowScope.titleOf for popup windows', (WidgetTester tester) async {
        final controller = _StubPopupWindowController(tester: tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.titleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals(''));
      });

      testWidgets('Can access WindowScope.titleOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.titleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals('Stub Satellite Window'));
      });

      testWidgets('Can access WindowScope.maybeTitleOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.maybeTitleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals('Stub Window'));
      });

      testWidgets('Can access WindowScope.maybeTitleOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.maybeTitleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals('Stub Window'));
      });

      testWidgets('Can access WindowScope.maybeTitleOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.maybeTitleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals(''));
      });

      testWidgets('Can access WindowScope.maybeTitleOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.maybeTitleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals(''));
      });

      testWidgets('Can access WindowScope.maybeTitleOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        String? title;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                title = WindowScope.maybeTitleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(title, equals('Stub Satellite Window'));
      });

      testWidgets('Can access WindowScope.isActivatedOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.isActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.isActivatedOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.isActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.isActivatedOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.isActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(false));
      });

      testWidgets('Can access WindowScope.isActivatedOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.isActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.isActivatedOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.isActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.maybeIsActivatedOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.maybeIsActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.maybeIsActivatedOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.maybeIsActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.maybeIsActivatedOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.maybeIsActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsActivatedOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.maybeIsActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.maybeIsActivatedOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        bool? isActivated;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isActivated = WindowScope.maybeIsActivatedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isActivated, equals(true));
      });

      testWidgets('Can access WindowScope.isMinimizedOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.isMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.isMinimizedOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.isMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.isMinimizedOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.isMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.isMinimizedOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.isMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMinimizedOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.maybeIsMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMinimizedOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.maybeIsMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMinimizedOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.maybeIsMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMinimizedOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isMinimized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMinimized = WindowScope.maybeIsMinimizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMinimized, equals(false));
      });

      testWidgets('Can access WindowScope.isMaximizedOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.isMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.isMaximizedOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.isMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.isMaximizedOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.isMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.isMaximizedOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.isMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.isMaximizedOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.isMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMaximizedOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.maybeIsMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMaximizedOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.maybeIsMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMaximizedOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.maybeIsMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMaximizedOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.maybeIsMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsMaximizedOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        bool? isMaximized;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isMaximized = WindowScope.maybeIsMaximizedOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isMaximized, equals(false));
      });

      testWidgets('Can access WindowScope.isFullscreenOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.isFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.isFullscreenOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.isFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.isFullscreenOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.isFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.isFullscreenOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.isFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.isFullscreenOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.isFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsFullscreenOf for regular windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubRegularWindowController(tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          RegularWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.maybeIsFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsFullscreenOf for dialog windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubDialogWindowController(tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          DialogWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.maybeIsFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsFullscreenOf for tooltip windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubTooltipWindowController(tester: tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          TooltipWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.maybeIsFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsFullscreenOf for popup windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubPopupWindowController(tester: tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          PopupWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.maybeIsFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('Can access WindowScope.maybeIsFullscreenOf for satellite windows', (
        WidgetTester tester,
      ) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        bool? isFullscreen;
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                isFullscreen = WindowScope.maybeIsFullscreenOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(isFullscreen, equals(false));
      });

      testWidgets('SatelliteWindow does not throw', (WidgetTester tester) async {
        final controller = _StubSatelliteWindowController(tester: tester);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithView: false,
          SatelliteWindow(controller: controller, child: Container()),
        );
      });
    });
  });
}
