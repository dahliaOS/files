import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry> entries;
  final bool openOnSecondary;
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

class ContextSubMenuEntry extends PopupMenuEntry<String> {
  final String id;
  final Widget text;
  final List<PopupMenuEntry> entries;
  final Widget? icon;

  const ContextSubMenuEntry({
    required this.id,
    required this.text,
    required this.entries,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  _ContextSubMenuEntryState createState() => _ContextSubMenuEntryState();

  @override
  double get height => 40;

  @override
  bool represents(String? value) => id == value;
}

// TODO: if not enough space, show from left
class _ContextSubMenuEntryState extends State<ContextSubMenuEntry> {
  final _subMenuKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _subMenuKey,
      onTap: () {
        final RenderBox renderBox =
            _subMenuKey.currentContext?.findRenderObject() as RenderBox;
        final Size size = renderBox.size;
        final Offset offset =
            renderBox.localToGlobal(Offset(size.width + 1, -8));

        _openContextMenu(context, offset, widget.entries);
      },
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                child: widget.icon!,
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
                child: widget.text,
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

class ContextMenuEntry extends PopupMenuEntry<String> {
  final String id;
  final Widget? icon;
  final Widget text;
  final VoidCallback onTap;
  final Widget? shortcut;

  const ContextMenuEntry({
    required this.id,
    this.icon,
    required this.text,
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
            if (widget.icon != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                child: widget.icon!,
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
                child: widget.text,
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
class ContextMenuDivider extends PopupMenuDivider {
  const ContextMenuDivider({Key? key}) : super(key: key);
}

void _openContextMenu(BuildContext context, Offset position,
    List<PopupMenuEntry<dynamic>> entries) {
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
