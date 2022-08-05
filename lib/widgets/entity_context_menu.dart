import 'package:files/widgets/context_menu/context_menu.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:flutter/material.dart';

class EntityContextMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback? onOpen;
  final VoidCallback? onOpenWith;
  final VoidCallback? onCopy;
  final VoidCallback? onCut;
  final VoidCallback? onPaste;

  const EntityContextMenu({
    required this.child,
    this.onOpen,
    this.onOpenWith,
    this.onCopy,
    this.onCut,
    this.onPaste,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenu(
      entries: [
        ContextMenuEntry(
          id: 'open',
          title: const Text("Open"),
          onTap: onOpen,
          shortcut: const Text("Return"),
        ),
        ContextMenuEntry(
          id: 'open_with',
          title: const Text("Open with other application"),
          onTap: onOpenWith,
          enabled: false,
        ),
        const ContextMenuDivider(),
        ContextMenuEntry(
          id: 'copy',
          leading: const Icon(Icons.file_copy_outlined),
          title: const Text("Copy file"),
          onTap: onCopy,
          shortcut: const Text("Ctrl+C"),
        ),
        ContextMenuEntry(
          id: 'cut',
          leading: const Icon(Icons.cut_outlined),
          title: const Text("Cut file"),
          onTap: onCut,
          shortcut: const Text("Ctrl+X"),
        ),
        ContextMenuEntry(
          id: 'paste',
          leading: const Icon(Icons.paste_outlined),
          title: const Text("Paste file"),
          onTap: onPaste,
          shortcut: const Text("Ctrl+V"),
        )
      ],
      child: child,
    );
  }
}
