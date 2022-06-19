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
          ? (details) => _openContextMenu(context, details.globalPosition)
          : null,
      onSecondaryTapUp: openOnSecondary
          ? (details) => _openContextMenu(context, details.globalPosition)
          : null,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  void _openContextMenu(BuildContext context, Offset position) {
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
}

/// Just for rename
class ContextMenuDivider extends PopupMenuDivider {
  const ContextMenuDivider({Key? key}) : super(key: key);
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
    return SizedBox(
      height: widget.height,
      width: 370,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          widget.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                IconTheme.merge(
                  data: IconThemeData(
                    size: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                  child: widget.icon!,
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                  child: widget.text,
                ),
              ),
              if (widget.shortcut != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                    child: widget.shortcut!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
