// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/_window.dart';

void showRegularWindowEditDialog({
  required BuildContext context,
  required RegularWindowController controller,
}) {
  showDialog(
    context: context,
    builder: (context) => _RegularWindowEditDialog(
      controller: controller,
      onClose: () => Navigator.pop(context),
    ),
  );
}

class _RegularWindowEditDialog extends StatefulWidget {
  const _RegularWindowEditDialog({
    required this.controller,
    required this.onClose,
  });

  final RegularWindowController controller;
  final VoidCallback onClose;

  @override
  State<StatefulWidget> createState() => _RegularWindowEditDialogState();
}

class _RegularWindowEditDialogState extends State<_RegularWindowEditDialog> {
  late Size initialSize;
  late String initialTitle;
  late bool initialFullscreen;
  late bool initialMaximized;
  late bool initialMinimized;
  late bool initialTitled;
  late bool initialClosable;
  late bool initialMinimizable;
  late bool initialMaximizable;
  late bool initialResizable;

  late final TextEditingController widthController;
  late final TextEditingController heightController;
  late final TextEditingController titleController;

  bool? nextIsFullscreen;
  bool? nextIsMaximized;
  bool? nextIsMinimized;
  bool? nextIsTitled;
  bool? nextIsClosable;
  bool? nextIsMinimizable;
  bool? nextIsMaximizable;
  bool? nextIsResizable;

  void _init() {
    widget.controller.addListener(_onNotification);
    initialSize = widget.controller.contentSize;
    initialTitle = widget.controller.title;
    initialFullscreen = widget.controller.isFullscreen;
    initialMaximized = widget.controller.isMaximized;
    initialMinimized = widget.controller.isMinimized;
    initialTitled = widget.controller.isTitled;
    initialClosable = widget.controller.isClosable;
    initialMinimizable = widget.controller.isMinimizable;
    initialMaximizable = widget.controller.isMaximizable;
    initialResizable = widget.controller.isResizable;

    widthController = TextEditingController(text: initialSize.width.toString());
    heightController = TextEditingController(
      text: initialSize.height.toString(),
    );
    titleController = TextEditingController(text: initialTitle);
    nextIsFullscreen = null;
    nextIsMaximized = null;
    nextIsMinimized = null;
    nextIsTitled = null;
    nextIsClosable = null;
    nextIsMinimizable = null;
    nextIsMaximizable = null;
    nextIsResizable = null;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant _RegularWindowEditDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onNotification);
      _init();
    }
  }

  void _onNotification() {
    // We listen on the state of the controller. If a value that the user
    // can edit changes from what it was initially set to, we invalidate
    // their current change and store the new "initial" value.
    if (widget.controller.contentSize != initialSize) {
      initialSize = widget.controller.contentSize;
      widthController.text = widget.controller.contentSize.width.toString();
      heightController.text = widget.controller.contentSize.height.toString();
    }
    if (widget.controller.isFullscreen != initialFullscreen) {
      setState(() {
        initialFullscreen = widget.controller.isFullscreen;
        nextIsFullscreen = null;
      });
    }
    if (widget.controller.isMaximized != initialMaximized) {
      setState(() {
        initialMaximized = widget.controller.isMaximized;
        nextIsMaximized = null;
      });
    }
    if (widget.controller.isMinimized != initialMinimized) {
      setState(() {
        initialMinimized = widget.controller.isMinimized;
        nextIsMinimized = null;
      });
    }
    if (widget.controller.isTitled != initialTitled) {
      setState(() {
        initialTitled = widget.controller.isTitled;
        nextIsTitled = null;
      });
    }
    if (widget.controller.isClosable != initialClosable) {
      setState(() {
        initialClosable = widget.controller.isClosable;
        nextIsClosable = null;
      });
    }
    if (widget.controller.isMinimizable != initialMinimizable) {
      setState(() {
        initialMinimizable = widget.controller.isMinimizable;
        nextIsMinimizable = null;
      });
    }
    if (widget.controller.isMaximizable != initialMaximizable) {
      setState(() {
        initialMaximizable = widget.controller.isMaximizable;
        nextIsMaximizable = null;
      });
    }
    if (widget.controller.isResizable != initialResizable) {
      setState(() {
        initialResizable = widget.controller.isResizable;
        nextIsResizable = null;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onNotification);
    widthController.dispose();
    heightController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    double? width = double.tryParse(widthController.text);
    double? height = double.tryParse(heightController.text);
    String? title = titleController.text.isEmpty ? null : titleController.text;
    if (width != null &&
        height != null &&
        (width != initialSize.width || height != initialSize.height)) {
      widget.controller.setSize(Size(width, height));
    }
    if (title != null && title != initialTitle) {
      widget.controller.setTitle(title);
    }
    if (nextIsFullscreen != null && nextIsFullscreen != initialFullscreen) {
      widget.controller.setFullscreen(nextIsFullscreen!);
    }
    if (nextIsMaximized != null && nextIsMaximized != initialMaximized) {
      widget.controller.setMaximized(nextIsMaximized!);
    }
    if (nextIsMinimized != null && nextIsMinimized != initialMinimized) {
      widget.controller.setMinimized(nextIsMinimized!);
    }
    if (nextIsTitled != null && nextIsTitled != initialTitled) {
      widget.controller.setTitled(nextIsTitled!);
    }
    if (nextIsClosable != null && nextIsClosable != initialClosable) {
      widget.controller.setClosable(nextIsClosable!);
    }
    if (nextIsMinimizable != null && nextIsMinimizable != initialMinimizable) {
      widget.controller.setMinimizable(nextIsMinimizable!);
    }
    if (nextIsMaximizable != null && nextIsMaximizable != initialMaximizable) {
      widget.controller.setMaximizable(nextIsMaximizable!);
    }
    if (nextIsResizable != null && nextIsResizable != initialResizable) {
      widget.controller.setResizable(nextIsResizable!);
    }

    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Window Properties'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widthController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Width'),
          ),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Height'),
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          CheckboxListTile(
            title: const Text('Fullscreen'),
            value: nextIsFullscreen ?? initialFullscreen,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsFullscreen = value);
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Maximized'),
            value: nextIsMaximized ?? initialMaximized,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsMaximized = value);
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Minimized'),
            value: nextIsMinimized ?? initialMinimized,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsMinimized = value);
              }
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text('Decoration Style Flags',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          CheckboxListTile(
            title: const Text('Titled'),
            value: nextIsTitled ?? initialTitled,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsTitled = value);
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Closable'),
            value: nextIsClosable ?? initialClosable,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsClosable = value);
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Minimizable'),
            value: nextIsMinimizable ?? initialMinimizable,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsMinimizable = value);
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Maximizable'),
            value: nextIsMaximizable ?? initialMaximizable,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsMaximizable = value);
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Resizable'),
            value: nextIsResizable ?? initialResizable,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() => nextIsResizable = value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => widget.onClose(), child: Text('Cancel')),
        TextButton(onPressed: () => _onSave(), child: Text('Save')),
      ],
    );
  }
}
