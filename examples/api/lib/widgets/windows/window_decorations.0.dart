// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(mattkae): remove invalid_use_of_internal_member ignore comment when this API is stable.
// See: https://github.com/flutter/flutter/issues/177586
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/_window.dart';

/// Flutter code sample for [WindowDecorations].

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Create a window that keeps its border and shadow, but hides the
    // system-provided title bar and window buttons. This allows the
    // application to draw its own custom title bar inside the content area.
    final RegularWindowController controller = RegularWindowController(
      preferredSize: const Size(640, 480),
      title: 'Window Decorations Sample',
      decorations: const WindowDecorations(
        hasTitleBar: false,
        hasCloseButton: false,
        hasMinimizeButton: false,
        hasMaximizeButton: false,
      ),
    );
    runWidget(
      WindowManager(
        child: RegularWindow(
          controller: controller,
          child: WindowDecorationsExampleApp(controller: controller),
        ),
      ),
    );
  } on UnsupportedError catch (e) {
    // TODO(mattkae): Remove this catch block when windowing is supported in tests.
    // For now, we need to catch the error so that the API smoke tests pass.
    runApp(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Text(
              e.message ?? 'Unsupported',
              textDirection: TextDirection.ltr,
            ),
          );
        },
      ),
    );
  }
}

class WindowDecorationsExampleApp extends StatelessWidget {
  const WindowDecorationsExampleApp({super.key, required this.controller});

  final RegularWindowController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WindowDecorationsExample(controller: controller),
    );
  }
}

class WindowDecorationsExample extends StatefulWidget {
  const WindowDecorationsExample({super.key, required this.controller});

  final RegularWindowController controller;

  @override
  State<WindowDecorationsExample> createState() =>
      _WindowDecorationsExampleState();
}

class _WindowDecorationsExampleState extends State<WindowDecorationsExample> {
  late WindowDecorations _decorations;

  @override
  void initState() {
    super.initState();
    _decorations = widget.controller.decorations;
  }

  void _update(WindowDecorations next) {
    widget.controller.setDecorations(next);
    setState(() {
      _decorations = next;
    });
  }

  Widget _toggle({
    required String title,
    required bool value,
    required WindowDecorations Function(bool) update,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (bool next) => _update(update(next)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // A simple custom title bar drawn inside the content area.
          Container(
            height: 32,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Custom Title Bar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  icon: const Icon(Icons.close),
                  onPressed: widget.controller.destroy,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _toggle(
                  title: 'Title bar',
                  value: _decorations.hasTitleBar,
                  update: (bool v) => _decorations.copyWith(hasTitleBar: v),
                ),
                _toggle(
                  title: 'Border',
                  value: _decorations.hasBorder,
                  update: (bool v) => _decorations.copyWith(hasBorder: v),
                ),
                _toggle(
                  title: 'Close button',
                  value: _decorations.hasCloseButton,
                  update: (bool v) => _decorations.copyWith(hasCloseButton: v),
                ),
                _toggle(
                  title: 'Minimize button',
                  value: _decorations.hasMinimizeButton,
                  update: (bool v) =>
                      _decorations.copyWith(hasMinimizeButton: v),
                ),
                _toggle(
                  title: 'Maximize button',
                  value: _decorations.hasMaximizeButton,
                  update: (bool v) =>
                      _decorations.copyWith(hasMaximizeButton: v),
                ),
                _toggle(
                  title: 'Resizable',
                  value: _decorations.isResizable,
                  update: (bool v) => _decorations.copyWith(isResizable: v),
                ),
                _toggle(
                  title: 'Shadow',
                  value: _decorations.hasShadow,
                  update: (bool v) => _decorations.copyWith(hasShadow: v),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Presets'),
                  subtitle: Wrap(
                    spacing: 8,
                    children: <Widget>[
                      FilledButton(
                        onPressed: () => _update(WindowDecorations.all),
                        child: const Text('All decorations'),
                      ),
                      FilledButton(
                        onPressed: () => _update(WindowDecorations.none),
                        child: const Text('No decorations'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
