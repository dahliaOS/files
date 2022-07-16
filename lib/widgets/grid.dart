import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/context_menu/context_menu.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

typedef EntityTapCallback = void Function(int index);
typedef EntityDoubleTapCallback = void Function(int index);
typedef EntityLongTapCallback = void Function(int index);
typedef EntitySecondaryTapCallback = void Function(int index);

class FilesGrid extends StatelessWidget {
  final List<EntityInfo> entities;
  final EntityTapCallback? onEntityTap;
  final EntityDoubleTapCallback? onEntityDoubleTap;
  final EntityLongTapCallback? onEntityLongTap;
  final EntitySecondaryTapCallback? onEntitySecondaryTap;
  final double size;

  const FilesGrid({
    required this.entities,
    this.onEntityTap,
    this.onEntityDoubleTap,
    this.onEntityLongTap,
    this.onEntitySecondaryTap,
    this.size = 96,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = WorkspaceController.of(context);
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () => controller.clearSelectedItems(),
      child: Scrollbar(
        controller: scrollController,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: size,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: entities.length,
          controller: scrollController,
          itemBuilder: (context, index) => Draggable<FileSystemEntity>(
            data: entities[index].entity,
            dragAnchorStrategy: (_, __, ___) => const Offset(32, 32),
            feedback: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              child: Cell(
                name: Utils.getEntityName(entities[index].path),
                icon: entities[index].isDirectory
                    ? Icons.folder
                    : Utils.iconForPath(entities[index].path),
                iconColor: entities[index].isDirectory
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
            ),
            child: FileCell(
              entity: entities[index],
              selected: controller.selectedItems.contains(entities[index]),
              onTap: () => onEntityTap?.call(index),
              onDoubleTap: () => onEntityDoubleTap?.call(index),
              onLongTap: () => onEntityLongTap?.call(index),
              onSecondaryTap: () => onEntitySecondaryTap?.call(index),
            ),
          ),
        ),
      ),
    );
  }
}

class FileCell extends StatelessWidget {
  final EntityInfo entity;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongTap;
  final VoidCallback? onSecondaryTap;

  const FileCell({
    required this.entity,
    this.selected = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onSecondaryTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<FileSystemEntity>(
      onWillAccept: (data) {
        if (!entity.isDirectory) return false;

        if (data!.path == entity.path) return false;

        return true;
      },
      onAccept: (data) => Utils.moveFileToDest(data, entity.path),
      builder: (context, candidateData, rejectedData) => Material(
        color: selected
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
            : Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onDoubleTap: () {
            onTap?.call();
            onDoubleTap?.call();
          },
          onLongPress: onLongTap,
          child: ContextMenu(
            entries: [
              ContextMenuEntry(
                id: 'open',
                title: const Text("Open"),
                onTap: () {
                  onTap?.call();
                  onDoubleTap?.call();
                },
                shortcut: const Text("Return"),
              ),
              ContextMenuEntry(
                id: 'open_with',
                title: const Text("Open with other application"),
                onTap: () {},
                enabled: false,
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
              child: Cell(
                name: Utils.getEntityName(entity.path),
                icon: entity.isDirectory
                    ? Icons.folder
                    : Utils.iconForPath(entity.path),
                iconColor: entity.isDirectory
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Cell extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color? iconColor;

  const Cell({
    required this.name,
    required this.icon,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 64,
        ),
        const SizedBox(width: 16),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
