import 'package:files/backend/folder_provider.dart';
import 'package:files/backend/workspace.dart';
import 'package:files/widgets/context_menu.dart';
import 'package:flutter/material.dart';

typedef NewTabCallback = void Function(String);

class SidePane extends StatefulWidget {
  final List<SideDestination> destinations;
  final WorkspaceController workspace;
  final NewTabCallback onNewTab;

  const SidePane({
    required this.destinations,
    required this.workspace,
    required this.onNewTab,
    super.key,
  });

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
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 56),
          itemCount: widget.destinations.length,
          itemBuilder: (context, index) => ContextMenu(
            entries: [
              ContextMenuItem(
                child: const Text("Open"),
                onTap: () => widget.workspace
                    .changeCurrentDir(widget.destinations[index].path),
              ),
              ContextMenuItem(
                child: const Text("Open in new tab"),
                onTap: () => widget.onNewTab(widget.destinations[index].path),
              ),
              ContextMenuItem(
                child: const Text("Open in new window"),
                onTap: () {},
                enabled: false,
              ),
            ],
            child: ListTile(
              dense: true,
              leading: Icon(widget.destinations[index].icon),
              selected: widget.workspace.currentDir ==
                  widget.destinations[index].path,
              selectedTileColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              title: Text(
                widget.destinations[index].label,
              ),
              onTap: () => widget.workspace
                  .changeCurrentDir(widget.destinations[index].path),
            ),
          ),
        ),
      ),
    );
  }
}
