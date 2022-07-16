import 'dart:async';
import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/context_menu/context_menu.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

class FilesGrid extends StatefulWidget {
  final List<EntityCell> entities;
  final ScrollController verticalController;
  final double size;

  const FilesGrid({
    required this.entities,
    required this.verticalController,
    this.size = 96,
  });

  @override
  State<StatefulWidget> createState() => _FilesGridState();
}

class _FilesGridState extends State<FilesGrid> {
  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = WorkspaceController.of(context);

    return GestureDetector(
      onTap: () => controller.clearSelectedItems(),
      child: GridView.builder(
        controller: widget.verticalController,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: widget.size,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        itemBuilder: (context, index) => _buildCell(index),
        padding: const EdgeInsets.all(16),
        itemCount: widget.entities.length,
      ),
    );
  }

  Widget _buildCell(int index) {
    final cell = widget.entities[index];

    return Draggable<FileSystemEntity>(
      data: cell.entity.entity,
      dragAnchorStrategy: (_, __, ___) => const Offset(32, 32),
      feedback: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        child: Icon(
          cell.entity.isDirectory
              ? Icons.folder
              : Utils.iconForPath(cell.entity.path),
          color: cell.entity.isDirectory
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          size: 64,
        ),
      ),
      child: _EntityCell(cell: cell),
    );
  }
}

class EntityCell {
  final EntityInfo entity;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongTap;
  final VoidCallback? onSecondaryTap;

  const EntityCell({
    required this.entity,
    this.selected = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onSecondaryTap,
  });
}

class _EntityCell extends StatefulWidget {
  final EntityCell cell;

  const _EntityCell({
    required this.cell,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntityCellState();
}

class _EntityCellState extends State<_EntityCell> {
  Timer? _tapTimer;
  bool _awaitingDoubleTap = false;

  @override
  void initState() {
    super.initState();
    widget.cell.entity.stat.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<FileSystemEntity>(
      onWillAccept: (data) {
        if (!widget.cell.entity.isDirectory) return false;

        if (data!.path == widget.cell.entity.path) return false;

        return true;
      },
      onAccept: (data) => Utils.moveFileToDest(data, widget.cell.entity.path),
      builder: (context, candidateData, rejectedData) {
        return Material(
          color: widget.cell.selected
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
              : Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              widget.cell.onTap?.call();
              if (_awaitingDoubleTap) {
                widget.cell.onDoubleTap?.call();
                _awaitingDoubleTap = false;
                _tapTimer?.cancel();
                _tapTimer = null;
              } else {
                _awaitingDoubleTap = true;
                _tapTimer = Timer(
                  const Duration(milliseconds: 300),
                  () => _awaitingDoubleTap = false,
                );
              }
            },
            onLongPress: widget.cell.onLongTap,
            child: ContextMenu(
              entries: [
                ContextMenuEntry(
                  id: 'open',
                  title: const Text("Open"),
                  onTap: () {},
                  shortcut: const Text("Return"),
                  enabled: false,
                ),
                ContextMenuEntry(
                  id: 'open_with',
                  title: const Text("Open with other application"),
                  onTap: () {},
                ),
                const ContextMenuDivider(),
                ContextMenuEntry(
                  id: 'copy',
                  leading: const Icon(Icons.file_copy_outlined),
                  title: const Text("Copy file"),
                  onTap: () {},
                  shortcut: const Text("Ctrl+C"),
                ),
                ContextMenuEntry(
                  id: 'cut',
                  leading: const Icon(Icons.cut_outlined),
                  title: const Text("Cut file"),
                  onTap: () {},
                  shortcut: const Text("Ctrl+X"),
                ),
                ContextMenuEntry(
                  id: 'paste',
                  leading: const Icon(Icons.paste_outlined),
                  title: const Text("Paste file"),
                  shortcut: const Text("Ctrl+V"),
                  onTap: () {},
                )
              ],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.cell.entity.isDirectory
                          ? Icons.folder
                          : Utils.iconForPath(widget.cell.entity.path),
                      color: widget.cell.entity.isDirectory
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                      size: 64,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      Utils.getEntityName(widget.cell.entity.path),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
