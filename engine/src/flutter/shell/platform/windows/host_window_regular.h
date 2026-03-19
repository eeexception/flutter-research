// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_SHELL_PLATFORM_WINDOWS_HOST_WINDOW_REGULAR_H_
#define FLUTTER_SHELL_PLATFORM_WINDOWS_HOST_WINDOW_REGULAR_H_

#include "host_window.h"

namespace flutter {
class HostWindowRegular : public HostWindow {
 public:
  // Creates a regular window.
  HostWindowRegular(WindowManager* window_manager,
                    FlutterWindowsEngine* engine,
                    const WindowSizeRequest& preferred_size,
                    const BoxConstraints& constraints,
                    LPCWSTR title);

  // Creates a regular window with the given |decorations|. Delegates to the
  // regular constructor and then applies the decorations.
  HostWindowRegular(WindowManager* window_manager,
                    FlutterWindowsEngine* engine,
                    const WindowSizeRequest& preferred_size,
                    const BoxConstraints& constraints,
                    LPCWSTR title,
                    const WindowDecorationsRequest& decorations);

  // Changes the system-drawn decorations on this window to match
  // |decorations|. Can be called at creation time or at runtime. With
  // all-default decorations this is a no-op.
  void SetDecorations(const WindowDecorationsRequest& decorations) override;

 private:
  static Rect GetInitialRect(FlutterWindowsEngine* engine,
                             const WindowSizeRequest& preferred_size,
                             const BoxConstraints& constraints);

  // Returns the Win32 window style corresponding to the requested
  // decorations.
  static DWORD WindowStyleForDecorations(
      const WindowDecorationsRequest& decorations);
};
}  // namespace flutter

#endif  // FLUTTER_SHELL_PLATFORM_WINDOWS_HOST_WINDOW_REGULAR_H_
