import 'package:files/widgets/context_menu/context_menu.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/context_menu/context_menu_theme.dart';
import 'package:flutter/material.dart';

/// [ContextSubMenuEntry] is a [PopupMenuEntry] that displays a submenu with [entries].
class ContextSubMenuEntry extends BaseContextMenuEntry {
  /// The [entries] are displayed in the order they are provided.
  /// They can be [ContextMenuEntry], [ContextMenuDivider], [ContextSubMenuEntry] or any other widgets inherited from PopupMenuEntry.
  final List<BaseContextMenuEntry> entries;

  const ContextSubMenuEntry({
    required super.id,
    required super.title,
    required this.entries,
    super.leading,
    super.enabled = true,
    super.key,
  });

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
    final ContextMenuTheme menuTheme =
        Theme.of(context).extension<ContextMenuTheme>()!;

    return InkWell(
      onTap: widget.enabled
          ? () {
              // Get current render box of the context widget (ContextSubMenuEntry).
              final RenderBox renderBox =
                  context.findRenderObject()! as RenderBox;
              // Get the position where the submenu should be opened.
              final Offset offset =
                  renderBox.localToGlobal(Offset(renderBox.size.width + 1, -8));

              openContextMenu(context, offset, widget.entries);
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
                  size: menuTheme.iconSize,
                  color: widget.enabled
                      ? menuTheme.iconColor
                      : menuTheme.disabledIconColor,
                ),
                child: widget.leading!,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: menuTheme.fontSize,
                  color: widget.enabled
                      ? menuTheme.textColor
                      : menuTheme.disabledTextColor,
                ),
                overflow: TextOverflow.ellipsis,
                child: widget.title,
              ),
            ),
            IconTheme.merge(
              data: IconThemeData(
                size: menuTheme.iconSize,
                color: widget.enabled
                    ? menuTheme.iconColor
                    : menuTheme.disabledIconColor,
              ),
              child: const Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}
