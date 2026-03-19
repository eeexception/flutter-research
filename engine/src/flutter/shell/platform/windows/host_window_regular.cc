// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/platform/windows/host_window_regular.h"

#include "flutter/shell/platform/windows/flutter_windows_engine.h"

namespace flutter {

DWORD HostWindowRegular::BuildWindowStyle(bool titled,
                                          bool closable,
                                          bool minimizable,
                                          bool maximizable,
                                          bool resizable) {
  DWORD style = WS_OVERLAPPED;
  if (titled) style |= WS_CAPTION;
  if (closable) style |= WS_SYSMENU;
  if (minimizable) style |= WS_MINIMIZEBOX;
  if (maximizable) style |= WS_MAXIMIZEBOX;
  if (resizable) style |= WS_THICKFRAME;
  if (style == WS_OVERLAPPED) style = WS_POPUP;
  return style;
}

HostWindowRegular::HostWindowRegular(WindowManager* window_manager,
                                     FlutterWindowsEngine* engine,
                                     const WindowSizeRequest& preferred_size,
                                     const BoxConstraints& constraints,
                                     LPCWSTR title,
                                     bool titled,
                                     bool closable,
                                     bool minimizable,
                                     bool maximizable,
                                     bool resizable)

    : HostWindow(window_manager, engine) {
  // TODO(knopp): Investigate sizing the window to its content with the help of
  // https://github.com/flutter/flutter/pull/173610.
  FML_CHECK(preferred_size.has_preferred_view_size);
  DWORD const window_style =
      BuildWindowStyle(titled, closable, minimizable, maximizable, resizable);
  InitializeFlutterView(HostWindowInitializationParams{
      .archetype = WindowArchetype::kRegular,
      .window_style = window_style,
      .extended_window_style = 0,
      .box_constraints = constraints,
      .initial_window_rect =
          GetInitialRect(engine, preferred_size, constraints, window_style),
      .title = title,
      .owner_window = std::optional<HWND>(),
  });
}

Rect HostWindowRegular::GetInitialRect(FlutterWindowsEngine* engine,
                                       const WindowSizeRequest& preferred_size,
                                       const BoxConstraints& constraints,
                                       DWORD window_style) {
  std::optional<Size> const window_size =
      HostWindow::GetWindowSizeForClientSize(
          *engine->windows_proc_table(),
          Size(preferred_size.preferred_view_width,
               preferred_size.preferred_view_height),
          constraints.smallest(), constraints.biggest(), window_style, 0,
          nullptr);
  return {{CW_USEDEFAULT, CW_USEDEFAULT},
          window_size ? *window_size : Size{CW_USEDEFAULT, CW_USEDEFAULT}};
}

}  // namespace flutter
