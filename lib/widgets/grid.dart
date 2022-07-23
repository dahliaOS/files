import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/context_menu/context_menu.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

typedef EntityCallback = void Function(EntityInfo entity);
typedef DropAcceptCallback = void Function(String path);

class FilesGrid extends StatelessWidget {
  final List<EntityInfo> entities;
  final EntityCallback? onEntityTap;
  final EntityCallback? onEntityDoubleTap;
  final EntityCallback? onEntityLongTap;
  final EntityCallback? onEntitySecondaryTap;
  final DropAcceptCallback? onDropAccept;
  final double size;

  const FilesGrid({
    required this.entities,
    this.onEntityTap,
    this.onEntityDoubleTap,
    this.onEntityLongTap,
    this.onEntitySecondaryTap,
    this.onDropAccept,
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
            mainAxisExtent: size,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: entities.length,
          controller: scrollController,
          itemBuilder: (context, index) => Draggable<FileSystemEntity>(
            data: entities[index].entity,
            dragAnchorStrategy: (_, __, ___) => const Offset(32, 32),
            feedback: SizedBox(
              width: size,
              height: size,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
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
              ),
            ),
            child: FileCell(
              entity: entities[index],
              selected: controller.selectedItems.contains(entities[index]),
              onTap: onEntityTap,
              onDoubleTap: onEntityDoubleTap,
              onLongTap: onEntityLongTap,
              onSecondaryTap: onEntitySecondaryTap,
              onDropAccept: onDropAccept,
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
  final EntityCallback? onTap;
  final EntityCallback? onDoubleTap;
  final EntityCallback? onLongTap;
  final EntityCallback? onSecondaryTap;
  final DropAcceptCallback? onDropAccept;

  const FileCell({
    required this.entity,
    this.selected = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onSecondaryTap,
    this.onDropAccept,
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
      onAccept: (_) => onDropAccept?.call(entity.path),
      builder: (context, _, __) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          onTap: () => onTap?.call(entity),
          onDoubleTap: () {
            onTap?.call(entity);
            onDoubleTap?.call(entity);
          },
          onLongPress: () => onLongTap?.call(entity),
          child: ContextMenu(
            entries: [
              ContextMenuEntry(
                id: 'open',
                title: const Text("Open"),
                onTap: () {
                  onTap?.call(entity);
                  onDoubleTap?.call(entity);
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
        DefaultTextStyle(
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          child: Text(name),
        ),
      ],
    );
  }
}
