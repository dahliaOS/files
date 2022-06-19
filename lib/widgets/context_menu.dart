import 'package:flutter/material.dart';

/// [ContextMenu] provides popup menu for the [child] widget and contains [entries].
class ContextMenu extends StatelessWidget {
  /// [child] is the widget for which the context menu will be called.
  final Widget child;

  /// The [entries] are displayed in the order they are provided.
  /// They can be [ContextMenuEntry], [ContextMenuDivider], [ContextSubMenuEntry] or any other widgets inherited from PopupMenuEntry.
  final List<PopupMenuEntry> entries;

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
              _openContextMenu(context, details.globalPosition, entries)
          : null,
      onSecondaryTapUp: openOnSecondary
          ? (details) =>
              _openContextMenu(context, details.globalPosition, entries)
          : null,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// [ContextSubMenuEntry] is a [PopupMenuEntry] that displays a submenu with [entries].
class ContextSubMenuEntry extends PopupMenuEntry<String> {
  /// Using for [represents] method.
  final String id;

  /// A widget to display before the title.
  /// Typically a [Icon] widget.
  final Widget? leading;

  /// The primary content of the menu entry.
  /// Typically a [Text] widget.
  final Widget title;

  /// The [entries] are displayed in the order they are provided.
  /// They can be [ContextMenuEntry], [ContextMenuDivider], [ContextSubMenuEntry] or any other widgets inherited from PopupMenuEntry.
  final List<PopupMenuEntry> entries;

  const ContextSubMenuEntry({
    required this.id,
    this.leading,
    required this.title,
    required this.entries,
    Key? key,
  }) : super(key: key);

  @override
  _ContextSubMenuEntryState createState() => _ContextSubMenuEntryState();

  @override
  double get height => 40;

  @override
  bool represents(String? value) => id == value;
}

class _ContextSubMenuEntryState extends State<ContextSubMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get current render box of the context widget (ContextSubMenuEntry).
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        // Get the position where the submenu should be opened.
        final Offset offset =
            renderBox.localToGlobal(Offset(renderBox.size.width + 1, -8));

        _openContextMenu(context, offset, widget.entries);
      },
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                child: widget.leading!,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.title,
              ),
            ),
            IconTheme.merge(
              data: IconThemeData(
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              child: const Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}

/// [ContextSubMenuEntry] is a [PopupMenuEntry] that displays a base menu entry.
class ContextMenuEntry extends PopupMenuEntry<String> {
  /// Using for [represents] method.
  final String id;

  /// A widget to display before the title.
  /// Typically a [Icon] widget.
  final Widget? leading;

  /// The primary content of the menu entry.
  /// Typically a [Text] widget.
  final Widget title;

  /// A tap with a primary button has occurred.
  final VoidCallback onTap;

  /// Optional content to display keysequence after the title.
  /// Typically a [Text] widget.
  final Widget? shortcut;

  const ContextMenuEntry({
    required this.id,
    this.leading,
    required this.title,
    required this.onTap,
    this.shortcut,
    Key? key,
  }) : super(key: key);

  @override
  _ContextMenuEntryState createState() => _ContextMenuEntryState();

  @override
  double get height => 40;

  @override
  bool represents(String? value) => id == value;
}

class _ContextMenuEntryState extends State<ContextMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.onTap();
      },
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                child: widget.leading!,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.title,
              ),
            ),
            if (widget.shortcut != null)
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.shortcut!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Just for rename
/// A horizontal divider in a Material Design popup menu.
///
/// TODO: It is necessary to discuss whether such a decision is correct.
class ContextMenuDivider extends PopupMenuDivider {
  const ContextMenuDivider({Key? key}) : super(key: key);
}

/// Show a popup menu that contains the [entries] at [position].
void _openContextMenu(
  BuildContext context,
  Offset position,
  List<PopupMenuEntry<dynamic>> entries,
) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx,
      position.dy,
    ),
    items: entries,
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}
