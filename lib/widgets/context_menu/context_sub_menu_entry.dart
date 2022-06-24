import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:flutter/material.dart';

/// [ContextSubMenuEntry] is a [PopupMenuEntry] that displays a submenu with [entries].
class ContextSubMenuEntry extends BaseContextMenuEntry {
  /// The [entries] are displayed in the order they are provided.
  /// They can be [ContextMenuEntry], [ContextMenuDivider], [ContextSubMenuEntry] or any other widgets inherited from PopupMenuEntry.
  final List<PopupMenuEntry> entries;

  const ContextSubMenuEntry({
    required String id,
    required Widget title,
    required this.entries,
    Widget? leading,
    bool enabled = true,
    Key? key,
  }) : super(
          id: id,
          leading: leading,
          title: title,
          enabled: enabled,
          key: key,
        );

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
      onTap: widget.enabled
          ? () {
              // Get current render box of the context widget (ContextSubMenuEntry).
              final RenderBox renderBox =
                  context.findRenderObject()! as RenderBox;
              // Get the position where the submenu should be opened.
              final Offset offset =
                  renderBox.localToGlobal(Offset(renderBox.size.width + 1, -8));

              _openContextMenu(context, offset, widget.entries);
            }
          : null,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color: widget.enabled
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.3),
                ),
                child: widget.leading!,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color: widget.enabled
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.3),
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.title,
              ),
            ),
            IconTheme.merge(
              data: IconThemeData(
                size: 20,
                color: widget.enabled
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              child: const Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
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
