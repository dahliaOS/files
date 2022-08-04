import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/entity_context_menu.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

typedef DropAcceptCallback = void Function(String path);

class FilesGrid extends StatelessWidget {
  final List<FileCell> cells;
  final double size;

  const FilesGrid({
    required this.cells,
    this.size = 96,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
      controller: scrollController,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size,
          mainAxisExtent: size,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        padding: const EdgeInsets.all(16),
        itemCount: cells.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          final EntityInfo entity = cells[index].entity;
          return Draggable<FileSystemEntity>(
            data: entity.entity,
            dragAnchorStrategy: (_, __, ___) => const Offset(32, 32),
            feedback: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
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
            child: cells[index],
          );
        },
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
          onTap: onTap,
          onDoubleTap: () {
            onTap?.call();
            onDoubleTap?.call();
          },
          onLongPress: onLongTap,
          child: EntityContextMenu(
            onOpen: () {
              onTap?.call();
              onDoubleTap?.call();
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
