import 'package:flutter/material.dart';

/// Use a single seed color so light & dark schemes stay in sync.
const Color _seed = Colors.blue;

/// Call this for both light & dark so they share the same tweaks.
ThemeData buildTheme(Brightness brightness) {
  // 1) Start from Material-3 defaults + dynamic ColorScheme.fromSeed().
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  );
  final scheme = base.colorScheme;

  // 2) Layer on the small “opinionated” tweaks your UI relies on.
  return base.copyWith(
    // Card look & feel (used by lists, dialogs, etc. in your app)
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHighest,
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),

    // AppBar: centered title, flat (no double shadow in M3), no surface tint
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0, surfaceTintColor: Colors.transparent),

    // SnackBars float above FAB & bottom bar
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),

    // Popup menus (the 3-dot menu in RecordingListItem)
    popupMenuTheme: PopupMenuThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: scheme.surfaceContainerHighest,
    ),

    // Dialogs (delete confirmation) – same rounded corners everywhere
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: scheme.surface,
    ),

    // ListTiles (global zero padding - keeps cards tight)
    listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),

    // FloatingActionButton matches the “container” swatch
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: scheme.primaryContainer, foregroundColor: scheme.onPrimaryContainer),
  );
}
