// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/platform/windows/host_window_regular.h"

#include "flutter/shell/platform/windows/flutter_windows_engine.h"

namespace flutter {

DWORD HostWindowRegular::WindowStyleForDecorations(
    const WindowDecorationsRequest& decorations) {
  // Start from the default regular-window style (WS_OVERLAPPEDWINDOW =
  // WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX |
  // WS_MAXIMIZEBOX) and remove styles for decorations that are disabled, so
  // that the default path is identical to the original behavior.
  DWORD style = WS_OVERLAPPEDWINDOW;
  if (!decorations.has_minimize_button) {
    style &= ~WS_MINIMIZEBOX;
  }
  if (!decorations.has_maximize_button) {
    style &= ~WS_MAXIMIZEBOX;
  }
  if (!decorations.has_close_button && !decorations.has_minimize_button &&
      !decorations.has_maximize_button) {
    // Only remove the system menu (and therefore all three buttons) when none
    // of the buttons are requested; the individual buttons require WS_SYSMENU.
    style &= ~WS_SYSMENU;
  }
  if (!decorations.has_title_bar) {
    // WS_CAPTION is required for the caption buttons; removing it also removes
    // them. WS_CAPTION = WS_BORDER | WS_DLGFRAME.
    style &= ~(WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
  }
  if (!decorations.is_resizable) {
    // WS_THICKFRAME (aka WS_SIZEBOX) enables resizing and draws a sizing
    // border. When resizing is disabled but a border is still requested,
    // replace the sizing border with a thin border.
    style &= ~WS_THICKFRAME;
    if (decorations.has_border) {
      style |= WS_BORDER;
    }
  }
  if (!decorations.has_border && !decorations.is_resizable) {
    style &= ~WS_BORDER;
  }
  // A window that has lost every overlapping-window style must use WS_POPUP;
  // otherwise Windows forces a caption on the window. WS_OVERLAPPED is 0 so
  // check for any remaining caption/border bits.
  if ((style & (WS_CAPTION | WS_THICKFRAME | WS_BORDER)) == 0) {
    style = WS_POPUP;
  }
  return style;
}

HostWindowRegular::HostWindowRegular(
    WindowManager* window_manager,
    FlutterWindowsEngine* engine,
    const WindowSizeRequest& preferred_size,
    const BoxConstraints& constraints,
    LPCWSTR title,
    const WindowDecorationsRequest& decorations)

    : HostWindow(window_manager, engine) {
  // TODO(knopp): Investigate sizing the window to its content with the help of
  // https://github.com/flutter/flutter/pull/173610.
  FML_CHECK(preferred_size.has_preferred_view_size);
  const DWORD window_style = WindowStyleForDecorations(decorations);
  InitializeFlutterView(HostWindowInitializationParams{
      .archetype = WindowArchetype::kRegular,
      .window_style = window_style,
      .extended_window_style = 0,
      .box_constraints = constraints,
      .initial_window_rect =
          GetInitialRect(engine, preferred_size, constraints, window_style),
      .title = title,
      .owner_window = std::optional<HWND>(),
      .has_shadow = decorations.has_shadow,
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
