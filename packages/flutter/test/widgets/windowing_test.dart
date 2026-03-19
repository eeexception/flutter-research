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
        RegularWindow,
        RegularWindowController,
        RegularWindowControllerDelegate,
        SatelliteWindow,
        SatelliteWindowController,
        TooltipWindow,
        TooltipWindowController,
        WindowScope,
        WindowingOwner,
        createDefaultWindowingOwner;
import 'package:flutter/src/widgets/_window_positioner.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'multi_view_testing.dart';

class _StubRegularWindowController extends RegularWindowController {
  _StubRegularWindowController(
    WidgetTester tester, {
    bool titled = true,
    bool closable = true,
    bool minimizable = true,
    bool maximizable = true,
    bool resizable = true,
  }) : _isTitled = titled,
       _isClosable = closable,
       _isMinimizable = minimizable,
       _isMaximizable = maximizable,
       _isResizable = resizable,
       super.empty() {
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

  bool _isTitled;
  @override
  bool get isTitled => _isTitled;
  @override
  void setTitled(bool titled) {
    _isTitled = titled;
    notifyListeners();
  }

  bool _isClosable;
  @override
  bool get isClosable => _isClosable;
  @override
  void setClosable(bool closable) {
    _isClosable = closable;
    notifyListeners();
  }

  bool _isMinimizable;
  @override
  bool get isMinimizable => _isMinimizable;
  @override
  void setMinimizable(bool minimizable) {
    _isMinimizable = minimizable;
    notifyListeners();
  }

  bool _isMaximizable;
  @override
  bool get isMaximizable => _isMaximizable;
  @override
  void setMaximizable(bool maximizable) {
    _isMaximizable = maximizable;
    notifyListeners();
  }

  bool _isResizable;
  @override
  bool get isResizable => _isResizable;
  @override
  void setResizable(bool resizable) {
    _isResizable = resizable;
    notifyListeners();
  }

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
  _StubDialogWindowController(
    WidgetTester tester, {
    bool resizable = true,
  }) : _isResizable = resizable,
       super.empty() {
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

  bool _isResizable;
  @override
  bool get isResizable => _isResizable;
  @override
  void setResizable(bool resizable) {
    _isResizable = resizable;
    notifyListeners();
  }

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

/// A lightweight mutable [RegularWindowController] for pure unit tests
/// (no widget tree / no [WidgetTester] needed).
class _MutableRegularWindowController extends RegularWindowController {
  _MutableRegularWindowController({
    bool titled = true,
    bool closable = true,
    bool minimizable = true,
    bool maximizable = true,
    bool resizable = true,
  }) : _isTitled = titled,
       _isClosable = closable,
       _isMinimizable = minimizable,
       _isMaximizable = maximizable,
       _isResizable = resizable,
       super.empty();

  @override Size get contentSize => Size.zero;
  @override String get title => '';
  @override bool get isActivated => false;
  @override bool get isMaximized => false;
  @override bool get isMinimized => false;
  @override bool get isFullscreen => false;
  @override void setSize(Size size) {}
  @override void setConstraints(BoxConstraints constraints) {}
  @override void setTitle(String title) {}
  @override void activate() {}
  @override void setMaximized(bool maximized) {}
  @override void setMinimized(bool minimized) {}
  @override void setFullscreen(bool fullscreen, {Display? display}) {}
  @override void destroy() {}

  bool _isTitled;
  @override bool get isTitled => _isTitled;
  @override void setTitled(bool titled) { _isTitled = titled; notifyListeners(); }

  bool _isClosable;
  @override bool get isClosable => _isClosable;
  @override void setClosable(bool closable) { _isClosable = closable; notifyListeners(); }

  bool _isMinimizable;
  @override bool get isMinimizable => _isMinimizable;
  @override void setMinimizable(bool minimizable) { _isMinimizable = minimizable; notifyListeners(); }

  bool _isMaximizable;
  @override bool get isMaximizable => _isMaximizable;
  @override void setMaximizable(bool maximizable) { _isMaximizable = maximizable; notifyListeners(); }

  bool _isResizable;
  @override bool get isResizable => _isResizable;
  @override void setResizable(bool resizable) { _isResizable = resizable; notifyListeners(); }
}

/// A lightweight mutable [DialogWindowController] for pure unit tests.
class _MutableDialogWindowController extends DialogWindowController {
  _MutableDialogWindowController({
    bool resizable = true,
  }) : _isResizable = resizable,
       super.empty();

  @override BaseWindowController? get parent => null;
  @override Size get contentSize => Size.zero;
  @override String get title => '';
  @override bool get isActivated => false;
  @override bool get isMinimized => false;
  @override void setSize(Size size) {}
  @override void setConstraints(BoxConstraints constraints) {}
  @override void setTitle(String title) {}
  @override void activate() {}
  @override void setMinimized(bool minimized) {}
  @override void destroy() {}

  bool _isResizable;
  @override bool get isResizable => _isResizable;
  @override void setResizable(bool resizable) { _isResizable = resizable; notifyListeners(); }
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

      // ============================================================
      // Window decoration style flags — comprehensive tests
      // ============================================================

      group('Decoration style flags for RegularWindow', () {
        // --- Default values ---

        testWidgets('all flags default to true', (WidgetTester tester) async {
          final controller = _StubRegularWindowController(tester);
          addTearDown(controller.dispose);

          bool? titled, closable, minimizable, maximizable, resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  closable = WindowScope.isClosableOf(context);
                  minimizable = WindowScope.isMinimizableOf(context);
                  maximizable = WindowScope.isMaximizableOf(context);
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isTrue);
          expect(closable, isTrue);
          expect(minimizable, isTrue);
          expect(maximizable, isTrue);
          expect(resizable, isTrue);
        });

        // --- Non-default initial values ---

        testWidgets('can create window with all flags set to false', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(
            tester,
            titled: false,
            closable: false,
            minimizable: false,
            maximizable: false,
            resizable: false,
          );
          addTearDown(controller.dispose);

          bool? titled, closable, minimizable, maximizable, resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  closable = WindowScope.isClosableOf(context);
                  minimizable = WindowScope.isMinimizableOf(context);
                  maximizable = WindowScope.isMaximizableOf(context);
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isFalse);
          expect(closable, isFalse);
          expect(minimizable, isFalse);
          expect(maximizable, isFalse);
          expect(resizable, isFalse);
        });

        testWidgets('can create window with mixed flag values', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(
            tester,
            titled: true,
            closable: false,
            minimizable: true,
            maximizable: false,
            resizable: true,
          );
          addTearDown(controller.dispose);

          bool? titled, closable, minimizable, maximizable, resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  closable = WindowScope.isClosableOf(context);
                  minimizable = WindowScope.isMinimizableOf(context);
                  maximizable = WindowScope.isMaximizableOf(context);
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isTrue);
          expect(closable, isFalse);
          expect(minimizable, isTrue);
          expect(maximizable, isFalse);
          expect(resizable, isTrue);
        });

        // --- Runtime mutation updates controller state ---

        test('setTitled updates isTitled getter', () {
          // Use a minimal test — no widget tree needed for controller state.
          // We can't use testWidgets here since _Stub needs a tester,
          // but we can verify the ChangeNotifier behavior directly.
          final notifications = <void>[];
          final controller = _MutableRegularWindowController(titled: true);
          addTearDown(controller.dispose);
          controller.addListener(() => notifications.add(null));

          expect(controller.isTitled, isTrue);

          controller.setTitled(false);
          expect(controller.isTitled, isFalse);
          expect(notifications, hasLength(1));

          controller.setTitled(true);
          expect(controller.isTitled, isTrue);
          expect(notifications, hasLength(2));
        });

        test('setClosable updates isClosable getter and notifies listeners', () {
          final notifications = <void>[];
          final controller = _MutableRegularWindowController(closable: true);
          addTearDown(controller.dispose);
          controller.addListener(() => notifications.add(null));

          expect(controller.isClosable, isTrue);

          controller.setClosable(false);
          expect(controller.isClosable, isFalse);
          expect(notifications, hasLength(1));
        });

        test('setMinimizable updates isMinimizable getter and notifies listeners', () {
          final notifications = <void>[];
          final controller = _MutableRegularWindowController(minimizable: true);
          addTearDown(controller.dispose);
          controller.addListener(() => notifications.add(null));

          expect(controller.isMinimizable, isTrue);

          controller.setMinimizable(false);
          expect(controller.isMinimizable, isFalse);
          expect(notifications, hasLength(1));
        });

        test('setMaximizable updates isMaximizable getter and notifies listeners', () {
          final notifications = <void>[];
          final controller = _MutableRegularWindowController(maximizable: true);
          addTearDown(controller.dispose);
          controller.addListener(() => notifications.add(null));

          expect(controller.isMaximizable, isTrue);

          controller.setMaximizable(false);
          expect(controller.isMaximizable, isFalse);
          expect(notifications, hasLength(1));
        });

        test('setResizable updates isResizable getter and notifies listeners', () {
          final notifications = <void>[];
          final controller = _MutableRegularWindowController(resizable: true);
          addTearDown(controller.dispose);
          controller.addListener(() => notifications.add(null));

          expect(controller.isResizable, isTrue);

          controller.setResizable(false);
          expect(controller.isResizable, isFalse);
          expect(notifications, hasLength(1));
        });

        test('all five flags can be toggled independently', () {
          final controller = _MutableRegularWindowController(
            titled: true,
            closable: true,
            minimizable: true,
            maximizable: true,
            resizable: true,
          );
          addTearDown(controller.dispose);

          // Toggle each flag independently and verify isolation.
          controller.setTitled(false);
          expect(controller.isTitled, isFalse);
          expect(controller.isClosable, isTrue);
          expect(controller.isMinimizable, isTrue);
          expect(controller.isMaximizable, isTrue);
          expect(controller.isResizable, isTrue);

          controller.setClosable(false);
          expect(controller.isTitled, isFalse);
          expect(controller.isClosable, isFalse);
          expect(controller.isMinimizable, isTrue);
          expect(controller.isMaximizable, isTrue);
          expect(controller.isResizable, isTrue);

          controller.setMinimizable(false);
          expect(controller.isMinimizable, isFalse);
          expect(controller.isMaximizable, isTrue);
          expect(controller.isResizable, isTrue);

          controller.setMaximizable(false);
          expect(controller.isMaximizable, isFalse);
          expect(controller.isResizable, isTrue);

          controller.setResizable(false);
          expect(controller.isResizable, isFalse);

          // All false now — toggle all back to true.
          controller.setTitled(true);
          controller.setClosable(true);
          controller.setMinimizable(true);
          controller.setMaximizable(true);
          controller.setResizable(true);

          expect(controller.isTitled, isTrue);
          expect(controller.isClosable, isTrue);
          expect(controller.isMinimizable, isTrue);
          expect(controller.isMaximizable, isTrue);
          expect(controller.isResizable, isTrue);
        });

        test('flags can be toggled multiple times', () {
          final controller = _MutableRegularWindowController(titled: true);
          addTearDown(controller.dispose);
          final notifications = <void>[];
          controller.addListener(() => notifications.add(null));

          expect(controller.isTitled, isTrue);

          controller.setTitled(false);
          expect(controller.isTitled, isFalse);

          controller.setTitled(true);
          expect(controller.isTitled, isTrue);

          controller.setTitled(false);
          expect(controller.isTitled, isFalse);

          expect(notifications, hasLength(3));
        });

        // --- WindowScope reads correct initial values for non-default flags ---

        testWidgets('WindowScope reads isTitled=false from controller', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(tester, titled: false);
          addTearDown(controller.dispose);

          bool? titled;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isFalse);
        });

        testWidgets('WindowScope reads isClosable=false from controller', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(tester, closable: false);
          addTearDown(controller.dispose);

          bool? closable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  closable = WindowScope.isClosableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(closable, isFalse);
        });

        testWidgets('WindowScope reads isMinimizable=false from controller', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(tester, minimizable: false);
          addTearDown(controller.dispose);

          bool? minimizable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  minimizable = WindowScope.isMinimizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(minimizable, isFalse);
        });

        testWidgets('WindowScope reads isMaximizable=false from controller', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(tester, maximizable: false);
          addTearDown(controller.dispose);

          bool? maximizable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  maximizable = WindowScope.isMaximizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(maximizable, isFalse);
        });

        testWidgets('WindowScope reads isResizable=false from controller', (
          WidgetTester tester,
        ) async {
          final controller = _StubRegularWindowController(tester, resizable: false);
          addTearDown(controller.dispose);

          bool? resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            RegularWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(resizable, isFalse);
        });

        // --- maybe variants return null without WindowScope ---

        testWidgets('maybeIsTitledOf returns null when no WindowScope ancestor', (
          WidgetTester tester,
        ) async {
          bool? result;
          await tester.pumpWidget(
            LookupBoundary(
              child: Builder(
                builder: (BuildContext context) {
                  result = WindowScope.maybeIsTitledOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(result, isNull);
        });

        testWidgets('maybeIsClosableOf returns null when no WindowScope ancestor', (
          WidgetTester tester,
        ) async {
          bool? result;
          await tester.pumpWidget(
            LookupBoundary(
              child: Builder(
                builder: (BuildContext context) {
                  result = WindowScope.maybeIsClosableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(result, isNull);
        });

        testWidgets('maybeIsMinimizableOf returns null when no WindowScope ancestor', (
          WidgetTester tester,
        ) async {
          bool? result;
          await tester.pumpWidget(
            LookupBoundary(
              child: Builder(
                builder: (BuildContext context) {
                  result = WindowScope.maybeIsMinimizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(result, isNull);
        });

        testWidgets('maybeIsMaximizableOf returns null when no WindowScope ancestor', (
          WidgetTester tester,
        ) async {
          bool? result;
          await tester.pumpWidget(
            LookupBoundary(
              child: Builder(
                builder: (BuildContext context) {
                  result = WindowScope.maybeIsMaximizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(result, isNull);
        });

        testWidgets('maybeIsResizableOf returns null when no WindowScope ancestor', (
          WidgetTester tester,
        ) async {
          bool? result;
          await tester.pumpWidget(
            LookupBoundary(
              child: Builder(
                builder: (BuildContext context) {
                  result = WindowScope.maybeIsResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(result, isNull);
        });
      });

      group('Decoration style flags for DialogWindow', () {
        testWidgets('isResizableOf defaults to true for dialog', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester);
          addTearDown(controller.dispose);

          bool? resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(resizable, isTrue);
        });

        testWidgets('dialog can be created with resizable=false', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester, resizable: false);
          addTearDown(controller.dispose);

          bool? resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(resizable, isFalse);
        });

        test('setResizable updates isResizable getter and notifies listeners', () {
          final notifications = <void>[];
          final controller = _MutableDialogWindowController(resizable: true);
          addTearDown(controller.dispose);
          controller.addListener(() => notifications.add(null));

          expect(controller.isResizable, isTrue);

          controller.setResizable(false);
          expect(controller.isResizable, isFalse);
          expect(notifications, hasLength(1));

          // Toggle back
          controller.setResizable(true);
          expect(controller.isResizable, isTrue);
          expect(notifications, hasLength(2));
        });

        testWidgets('WindowScope reads dialog resizable=false', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester, resizable: false);
          addTearDown(controller.dispose);

          bool? resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(resizable, isFalse);
        });

        // Dialog always returns fixed values for flags it doesn't own
        testWidgets('isTitledOf always returns true for dialog windows', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester);
          addTearDown(controller.dispose);

          bool? titled;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isTrue);
        });

        testWidgets('isClosableOf always returns true for dialog windows', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester);
          addTearDown(controller.dispose);

          bool? closable;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  closable = WindowScope.isClosableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(closable, isTrue);
        });

        testWidgets('isMinimizableOf always returns false for dialog windows', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester);
          addTearDown(controller.dispose);

          bool? minimizable;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  minimizable = WindowScope.isMinimizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(minimizable, isFalse);
        });

        testWidgets('isMaximizableOf always returns false for dialog windows', (
          WidgetTester tester,
        ) async {
          final controller = _StubDialogWindowController(tester);
          addTearDown(controller.dispose);

          bool? maximizable;
          await tester.pumpWidget(
            wrapWithView: false,
            DialogWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  maximizable = WindowScope.isMaximizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(maximizable, isFalse);
        });
      });

      group('Decoration style flags for non-configurable window types', () {
        testWidgets('tooltip windows return false for all decoration flags', (
          WidgetTester tester,
        ) async {
          final controller = _StubTooltipWindowController(tester: tester);
          addTearDown(controller.dispose);

          bool? titled, closable, minimizable, maximizable, resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            TooltipWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  closable = WindowScope.isClosableOf(context);
                  minimizable = WindowScope.isMinimizableOf(context);
                  maximizable = WindowScope.isMaximizableOf(context);
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isFalse);
          expect(closable, isFalse);
          expect(minimizable, isFalse);
          expect(maximizable, isFalse);
          expect(resizable, isFalse);
        });

        testWidgets('popup windows return false for all decoration flags', (
          WidgetTester tester,
        ) async {
          final controller = _StubPopupWindowController(tester: tester);
          addTearDown(controller.dispose);

          bool? titled, closable, minimizable, maximizable, resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            PopupWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  closable = WindowScope.isClosableOf(context);
                  minimizable = WindowScope.isMinimizableOf(context);
                  maximizable = WindowScope.isMaximizableOf(context);
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isFalse);
          expect(closable, isFalse);
          expect(minimizable, isFalse);
          expect(maximizable, isFalse);
          expect(resizable, isFalse);
        });

        testWidgets('satellite windows return true for titled, closable, resizable and false for min/max', (
          WidgetTester tester,
        ) async {
          final controller = _StubSatelliteWindowController(tester: tester);
          addTearDown(controller.dispose);

          bool? titled, closable, minimizable, maximizable, resizable;
          await tester.pumpWidget(
            wrapWithView: false,
            SatelliteWindow(
              controller: controller,
              child: Builder(
                builder: (BuildContext context) {
                  titled = WindowScope.isTitledOf(context);
                  closable = WindowScope.isClosableOf(context);
                  minimizable = WindowScope.isMinimizableOf(context);
                  maximizable = WindowScope.isMaximizableOf(context);
                  resizable = WindowScope.isResizableOf(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(titled, isTrue);
          expect(closable, isTrue);
          expect(minimizable, isFalse);
          expect(maximizable, isFalse);
          expect(resizable, isTrue);
        });
      });

      group('_WindowingOwnerUnsupported with new parameters', () {
        test('createRegularWindowController with decoration flags still throws when windowing disabled', () {
          isWindowingEnabled = false;
          final WindowingOwner owner = createDefaultWindowingOwner();
          expect(
            () => owner.createRegularWindowController(
              delegate: RegularWindowControllerDelegate(),
              titled: false,
              closable: false,
              minimizable: false,
              maximizable: false,
              resizable: false,
            ),
            throwsUnsupportedError,
          );
        });

        test('createDialogWindowController with resizable flag still throws when windowing disabled', () {
          isWindowingEnabled = false;
          final WindowingOwner owner = createDefaultWindowingOwner();
          expect(
            () => owner.createDialogWindowController(
              delegate: DialogWindowControllerDelegate(),
              resizable: false,
            ),
            throwsUnsupportedError,
          );
        });
      });
    });
  });
}
