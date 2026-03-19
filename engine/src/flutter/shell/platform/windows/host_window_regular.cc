// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/platform/windows/host_window_regular.h"

#include <dwmapi.h>

#include "flutter/shell/platform/windows/flutter_windows_engine.h"

namespace flutter {

DWORD HostWindowRegular::WindowStyleForDecorations(
    const WindowDecorationsRequest& decorations) {
  // A fully decorated regular window uses WS_OVERLAPPEDWINDOW, which expands
  // to WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME |
  // WS_MINIMIZEBOX | WS_MAXIMIZEBOX. Assemble the style from the individual
  // decoration flags so that each decoration can be toggled independently.
  // WS_OVERLAPPED is 0; start from it for overlapped windows.
  DWORD style = WS_OVERLAPPED;
  if (decorations.has_title_bar) {
    style |= WS_CAPTION;
    // The close button requires WS_SYSMENU, which requires WS_CAPTION.
    if (decorations.has_close_button) {
      style |= WS_SYSMENU;
    }
    // The minimize and maximize buttons require WS_SYSMENU.
    if (decorations.has_minimize_button) {
      style |= WS_SYSMENU | WS_MINIMIZEBOX;
    }
    if (decorations.has_maximize_button) {
      style |= WS_SYSMENU | WS_MAXIMIZEBOX;
    }
  }
  if (decorations.is_resizable) {
    // WS_THICKFRAME (aka WS_SIZEBOX) enables resizing and draws a sizing
    // border.
    style |= WS_THICKFRAME;
  } else if (decorations.has_border) {
    // When the window is not resizable but should still have a border, use a
    // thin border.
    style |= WS_BORDER;
  }
  if (style == WS_OVERLAPPED) {
    // A window with no caption and no border must use WS_POPUP; otherwise
    // Windows forces a caption on the window.
    style = WS_POPUP;
  }
  return style;
}

void HostWindowRegular::SetDecorations(
    const WindowDecorationsRequest& decorations) {
  // Bits that SetDecorations is allowed to change. All other bits of the
  // current window style (such as WS_VISIBLE) are preserved.
  constexpr DWORD kDecorationBits =
      WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX |
      WS_THICKFRAME | WS_BORDER | WS_POPUP;
  const DWORD requested_style = WindowStyleForDecorations(decorations);
  const DWORD current_style = GetWindowLongPtr(window_handle_, GWL_STYLE);
  const DWORD new_style =
      (current_style & ~kDecorationBits) | (requested_style & kDecorationBits);
  if (new_style != current_style) {
    SetWindowLongPtr(window_handle_, GWL_STYLE, new_style);
    // MSDN: changes take effect only after SetWindowPos with SWP_FRAMECHANGED.
    SetWindowPos(window_handle_, nullptr, 0, 0, 0, 0,
                 SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE |
                     SWP_FRAMECHANGED);
  }

  // Enable or disable the DWM-drawn shadow independently of the window style.
  DWMNCRENDERINGPOLICY policy =
      decorations.has_shadow ? DWMNCRP_USEWINDOWSTYLE : DWMNCRP_DISABLED;
  DwmSetWindowAttribute(window_handle_, DWMWA_NCRENDERING_POLICY, &policy,
                        sizeof(policy));
}

HostWindowRegular::HostWindowRegular(WindowManager* window_manager,
                                     FlutterWindowsEngine* engine,
                                     const WindowSizeRequest& preferred_size,
                                     const BoxConstraints& constraints,
                                     LPCWSTR title)

    : HostWindow(window_manager, engine) {
  // TODO(knopp): Investigate sizing the window to its content with the help of
  // https://github.com/flutter/flutter/pull/173610.
  FML_CHECK(preferred_size.has_preferred_view_size);
  InitializeFlutterView(HostWindowInitializationParams{
      .archetype = WindowArchetype::kRegular,
      .window_style = WS_OVERLAPPEDWINDOW,
      .extended_window_style = 0,
      .box_constraints = constraints,
      .initial_window_rect =
          GetInitialRect(engine, preferred_size, constraints),
      .title = title,
      .owner_window = std::optional<HWND>(),
  });
}

HostWindowRegular::HostWindowRegular(
    WindowManager* window_manager,
    FlutterWindowsEngine* engine,
    const WindowSizeRequest& preferred_size,
    const BoxConstraints& constraints,
    LPCWSTR title,
    const WindowDecorationsRequest& decorations)

    : HostWindowRegular(window_manager,
                        engine,
                        preferred_size,
                        constraints,
                        title) {
  SetDecorations(decorations);
}

Rect HostWindowRegular::GetInitialRect(FlutterWindowsEngine* engine,
                                       const WindowSizeRequest& preferred_size,
                                       const BoxConstraints& constraints) {
  std::optional<Size> const window_size =
      HostWindow::GetWindowSizeForClientSize(
          *engine->windows_proc_table(),
          Size(preferred_size.preferred_view_width,
               preferred_size.preferred_view_height),
          constraints.smallest(), constraints.biggest(), WS_OVERLAPPEDWINDOW, 0,
          nullptr);
  return {{CW_USEDEFAULT, CW_USEDEFAULT},
          window_size ? *window_size : Size{CW_USEDEFAULT, CW_USEDEFAULT}};
}

}  // namespace flutter
