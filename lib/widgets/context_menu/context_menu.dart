import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/context_menu/context_menu_theme.dart';
import 'package:flutter/material.dart';

/// [ContextMenu] provides popup menu for the [child] widget and contains [entries].
class ContextMenu extends StatelessWidget {
  /// [child] is the widget for which the context menu will be called.
  final Widget child;

  /// The [entries] are displayed in the order they are provided.
  /// They can be [ContextMenuEntry], [ContextMenuDivider], [ContextSubMenuEntry] or any other widgets inherited from PopupMenuEntry.
  final List<BaseContextMenuEntry> entries;

  /// Whether the context menu will be displayed when tapped on a secondary button.
  /// This defaults to true.
  final bool openOnSecondary;

  /// Whether the context menu will be displayed when a long press gesture with a primary button has been recognized.
  /// This defaults to true.
  final bool openOnLong;

  const ContextMenu({
    required this.child,
    required this.entries,
    this.openOnSecondary = true,
    this.openOnLong = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: openOnLong
          ? (details) =>
              openContextMenu(context, details.globalPosition, entries)
          : null,
      onSecondaryTapUp: openOnSecondary
          ? (details) =>
              openContextMenu(context, details.globalPosition, entries)
          : null,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// Show a popup menu that contains the [entries] at [position].
/// Can be used without [ContextMenu] widget
void openContextMenu(
  BuildContext context,
  Offset position,
  List<PopupMenuEntry<dynamic>> entries,
) {
  final menuTheme = Theme.of(context).extension<ContextMenuTheme>()!;

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx,
      position.dy,
    ),
    items: entries,
    color: menuTheme.backgroundColor,
    shape: menuTheme.shape,
  );
}
