import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:files/backend/entity_info.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/double_scrollbars.dart';
import 'package:files/widgets/entity_context_menu.dart';
import 'package:files/widgets/workspace.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

typedef HeaderTapCallback = void Function(
  bool newAscending,
  int newColumnIndex,
);

typedef HeaderResizeCallback = void Function(
  int newColumnIndex,
  DragUpdateDetails details,
);

class FilesTable extends StatefulWidget {
  final List<FilesRow> rows;
  final List<FilesColumn> columns;
  final double rowHeight;
  final double rowHorizontalPadding;
  final bool ascending;
  final int columnIndex;
  final HeaderTapCallback? onHeaderCellTap;
  final HeaderResizeCallback? onHeaderResize;
  final ScrollController horizontalController;
  final ScrollController verticalController;

  const FilesTable({
    required this.rows,
    required this.columns,
    this.rowHeight = 32,
    this.rowHorizontalPadding = 8,
    this.ascending = false,
    this.columnIndex = 0,
    this.onHeaderCellTap,
    this.onHeaderResize,
    required this.horizontalController,
    required this.verticalController,
    Key? key,
  }) : super(key: key);

  @override
  State<FilesTable> createState() => _FilesTableState();
}

class _FilesTableState extends State<FilesTable> {
  /* late ScrollController xController;
  late ScrollController yController;

  @override
  void initState() {
    super.initState();
    updateController(widget.horizontalController, Axis.horizontal);
    updateController(widget.verticalController, Axis.vertical);
  }

  @override
  void didUpdateWidget(covariant FilesTable old) {
    super.didUpdateWidget(old);

    if (widget.horizontalController != old.horizontalController) {
      updateController(widget.horizontalController, Axis.horizontal);
    }

    if (widget.verticalController != old.verticalController) {
      updateController(widget.verticalController, Axis.vertical);
    }
  }

  void updateController(ScrollController? newController, Axis axis) {
    switch (axis) {
      case Axis.vertical:
        yController = newController ?? ScrollController();
        break;
      case Axis.horizontal:
        xController = newController ?? ScrollController();
        break;
    }
  } */

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = WorkspaceController.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return DoubleScrollbars(
          horizontalController: widget.horizontalController,
          verticalController: widget.verticalController,
          child: ScrollProxy(
            direction: Axis.horizontal,
            child: SingleChildScrollView(
              controller: widget.horizontalController,
              scrollDirection: Axis.horizontal,
              child: ScrollProxy(
                direction: Axis.vertical,
                child: SizedBox(
                  height: constraints.maxHeight,
                  width: layoutWidth + widget.rowHorizontalPadding * 2,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ListView.builder(
                          itemBuilder: (context, index) => _buildRow(index),
                          padding: const EdgeInsets.only(top: 36),
                          itemCount: widget.rows.length,
                          controller: widget.verticalController,
                        ),
                      ),
                      _buildHeaderRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double get layoutWidth => widget.columns.map((e) => e.normalizedWidth).sum;

  Widget _buildHeaderRow() {
    return SizedBox(
      height: 32,
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.columns.mapIndexed(
              (index, column) => _buildHeaderCell(
                column,
                index,
              ),
            ),
            Container(
              width: widget.rowHorizontalPadding,
              color: Theme.of(context).colorScheme.background,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(int index) {
    final row = widget.rows[index];

    return Draggable<FileSystemEntity>(
      child: _FilesRow(
        row: row,
        columns: widget.columns,
        horizontalPadding: widget.rowHorizontalPadding,
        size: Size(
          layoutWidth + (widget.rowHorizontalPadding * 2),
          widget.rowHeight,
        ),
      ),
      childWhenDragging: _FilesRow(
        row: row,
        columns: widget.columns,
        horizontalPadding: widget.rowHorizontalPadding,
        size: Size(
          layoutWidth + (widget.rowHorizontalPadding * 2),
          widget.rowHeight,
        ),
      ),
      data: row.entity.entity,
      dragAnchorStrategy: (draggable, context, position) {
        return const Offset(32, 32);
      },
      feedback: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        child: Icon(
          row.entity.isDirectory
              ? Icons.folder
              : Utils.iconForPath(row.entity.path),
          color: row.entity.isDirectory
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          size: 64,
        ),
      ),
    );
  }

  Widget _buildHeaderCell(FilesColumn column, int index) {
    late Widget child;

    switch (column.type) {
      case FilesColumnType.name:
        child = const Text(
          "Name",
          overflow: TextOverflow.ellipsis,
        );
        break;
      case FilesColumnType.date:
        child = const Text(
          "Date",
          overflow: TextOverflow.ellipsis,
        );
        break;
      case FilesColumnType.type:
        child = const Text(
          "Type",
          overflow: TextOverflow.ellipsis,
        );
        break;
      case FilesColumnType.size:
        child = const Text(
          "Size",
          overflow: TextOverflow.ellipsis,
        );
        break;
    }
    child = SizedBox.expand(
      child: Row(
        children: [
          Expanded(child: child),
          if (widget.columnIndex == index)
            Icon(
              widget.ascending ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
            ),
        ],
      ),
    );

    final double startPadding = index == 0 ? widget.rowHorizontalPadding : 0;

    return InkWell(
      onTap: column.allowSorting
          ? () {
              bool newAscending = widget.ascending;
              if (widget.columnIndex == index) {
                newAscending = !newAscending;
              }

              widget.onHeaderCellTap?.call(newAscending, index);
            }
          : null,
      child: Container(
        width: column.normalizedWidth + startPadding,
        constraints: BoxConstraints(minWidth: startPadding + 80),
        padding: EdgeInsetsDirectional.only(
          start: startPadding,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? widget.rowHorizontalPadding : 8,
                  end: 8,
                ),
                child: child,
              ),
            ),
            PositionedDirectional(
              end: -3,
              top: 0,
              bottom: 0,
              width: 8,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                opaque: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    widget.onHeaderResize?.call(index, details);
                  },
                  child: const VerticalDivider(width: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilesColumn {
  final double width;
  final FilesColumnType type;
  final bool allowSorting;

  double get normalizedWidth => width.clamp(80, double.infinity);

  const FilesColumn({
    required this.width,
    required this.type,
    this.allowSorting = true,
  });
}

enum FilesColumnType {
  name,
  date,
  type,
  size,
}

class FilesRow {
  final EntityInfo entity;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongTap;
  final VoidCallback? onSecondaryTap;

  const FilesRow({
    required this.entity,
    this.selected = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onSecondaryTap,
  });
}

class _FilesRow extends StatefulWidget {
  final FilesRow row;
  final List<FilesColumn> columns;
  final Size size;
  final double horizontalPadding;

  const _FilesRow({
    required this.row,
    required this.columns,
    required this.size,
    required this.horizontalPadding,
    Key? key,
  }) : super(key: key);

  @override
  _FilesRowState createState() => _FilesRowState();
}

class _FilesRowState extends State<_FilesRow> {
  Timer? _tapTimer;
  bool _awaitingDoubleTap = false;

  @override
  void initState() {
    super.initState();
    widget.row.entity.stat.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<FileSystemEntity>(
      onWillAccept: (data) {
        if (!widget.row.entity.isDirectory) return false;

        if (data!.path == widget.row.entity.path) return false;

        return true;
      },
      onAccept: (data) => Utils.moveFileToDest(data, widget.row.entity.path),
      builder: (context, candidateData, rejectedData) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              constraints:
                  BoxConstraints.tightForFinite(height: widget.size.height),
              padding: EdgeInsetsDirectional.only(
                end: (constraints.maxWidth - widget.size.width)
                    .clamp(0, double.infinity),
              ),
              child: Material(
                color: widget.row.selected
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                    : Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    widget.row.onTap?.call();
                    if (_awaitingDoubleTap) {
                      widget.row.onDoubleTap?.call();
                      _awaitingDoubleTap = false;
                      _tapTimer?.cancel();
                      _tapTimer = null;
                    } else {
                      _awaitingDoubleTap = true;
                      _tapTimer = Timer(const Duration(milliseconds: 300),
                          () => _awaitingDoubleTap = false);
                    }
                  },
                  onLongPress: widget.row.onLongTap,
                  child: EntityContextMenu(
                    onOpen: () {
                      widget.row.onTap?.call();
                      widget.row.onDoubleTap?.call();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.horizontalPadding,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: widget.columns
                            .map(
                              (column) => _buildCell(
                                widget.row.entity,
                                column,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCell(EntityInfo entity, FilesColumn column) {
    late final Widget child;

    switch (column.type) {
      case FilesColumnType.name:
        child = Row(
          children: [
            Icon(
              entity.isDirectory
                  ? Icons.folder
                  : Utils.iconForPath(entity.path),
              color: entity.isDirectory
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                Utils.getEntityName(entity.path),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
        break;
      case FilesColumnType.date:
        child = Text(
          DateFormat("HH:mm - d MMM yyyy").format(entity.stat.modified),
          overflow: TextOverflow.ellipsis,
        );
        break;
      case FilesColumnType.type:
        final String fileExtension =
            p.extension(entity.path).replaceAll(".", "").toUpperCase();
        final String fileLabel =
            fileExtension.isNotEmpty ? "File ($fileExtension)" : "File";
        child = Text(
          entity.isDirectory ? "Directory" : fileLabel,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case FilesColumnType.size:
        child = Text(
          entity.isDirectory ? "" : filesize(entity.stat.size),
          overflow: TextOverflow.ellipsis,
        );
        break;
    }

    return Container(
      width: column.normalizedWidth,
      constraints: const BoxConstraints(minWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}
