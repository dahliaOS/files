import 'package:collection/collection.dart';
import 'package:files/widgets/context_menu.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

class SidePane extends StatefulWidget {
  final List<SideDestination> destinations;
  final WorkspaceController workspace;
  final void Function(String tabPath) onNewTab;

  const SidePane({
    required this.destinations,
    required this.workspace,
    required this.onNewTab,
    Key? key,
  }) : super(key: key);

  @override
  _SidePaneState createState() => _SidePaneState();
}

class _SidePaneState extends State<SidePane> {
  @override
  void initState() {
    super.initState();
    widget.workspace.addListener(updateOnDirChange);
  }

  @override
  void didUpdateWidget(covariant SidePane old) {
    super.didUpdateWidget(old);
    if (widget.workspace != old.workspace) {
      old.workspace.removeListener(updateOnDirChange);
      widget.workspace.addListener(updateOnDirChange);
    }
  }

  @override
  void dispose() {
    widget.workspace.removeListener(updateOnDirChange);
    super.dispose();
  }

  void updateOnDirChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 304,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.only(top: 56),
          children: widget.destinations
              .mapIndexed(
                (index, d) => ContextMenu(
                  entries: [
                    ContextMenuEntry(
                      id: 'open',
                      text: const Text("Open"),
                      onTap: () => widget.workspace.currentDir =
                          widget.destinations[index].path,
                    ),
                    ContextMenuEntry(
                      id: 'open_in_new_tab',
                      text: const Text("Open in new tab"),
                      onTap: () => widget.onNewTab(widget.destinations[index].path),
                    ),
                    ContextMenuEntry(
                      id: 'open_in_new_window',
                      text: const Text("Copy in new window"),
                      onTap: () {},
                    ),
                  ],
                  child: ListTile(
                    dense: true,
                    leading: Icon(widget.destinations[index].icon),
                    selected: widget.workspace.currentDir ==
                        widget.destinations[index].path,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    title: Text(
                      widget.destinations[index].label,
                    ),
                    onTap: () => widget.workspace.currentDir =
                        widget.destinations[index].path,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class SideDestination {
  final IconData icon;
  final String label;
  final String path;

  const SideDestination(this.icon, this.label, this.path);
}
