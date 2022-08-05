import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/entity_context_menu.dart';
import 'package:files/widgets/timed_inkwell.dart';
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = WorkspaceController.of(context);
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () =>
          WorkspaceController.of(context, listen: false).clearSelectedItems(),
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
          itemBuilder: (context, index) {
            final EntityInfo entityInfo = entities[index];

            return Draggable<FileSystemEntity>(
              data: entityInfo.entity,
              dragAnchorStrategy: (_, __, ___) => const Offset(32, 32),
              feedback: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Cell(
                    name: Utils.getEntityName(entityInfo.entity.path),
                    icon: entityInfo.isDirectory
                        ? Icons.folder
                        : Utils.iconForPath(entityInfo.path),
                    iconColor: entityInfo.isDirectory
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                ),
              ),
              child: FileCell(
                entity: entityInfo,
                selected: controller.selectedItems.contains(entityInfo),
                onTap: onEntityTap,
                onDoubleTap: onEntityDoubleTap,
                onLongTap: onEntityLongTap,
                onSecondaryTap: onEntitySecondaryTap,
                onDropAccept: onDropAccept,
              ),
            );
          },
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
    super.key,
  });

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
        child: TimedInkwell(
          onTap: () => onTap?.call(entity),
          onDoubleTap: () {
            onTap?.call(entity);
            onDoubleTap?.call(entity);
          },
          onLongPress: () => onLongTap?.call(entity),
          child: EntityContextMenu(
            onOpen: () {
              onTap?.call(entity);
              onDoubleTap?.call(entity);
            },
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
    super.key,
  });

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
          maxLines: 1,
          textAlign: TextAlign.center,
          child: Text(name),
        ),
      ],
    );
  }
}
