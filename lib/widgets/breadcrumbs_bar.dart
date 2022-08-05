import 'dart:io';

import 'package:files/backend/path_parts.dart';
import 'package:files/backend/utils.dart';
import 'package:flutter/material.dart';

class BreadcrumbsBar extends StatefulWidget {
  final PathParts path;
  final ValueChanged<int>? onBreadcrumbPress;
  final ValueChanged<String>? onPathSubmitted;
  final List<Widget>? leading;
  final List<Widget>? actions;
  final double? loadingProgress;

  const BreadcrumbsBar({
    required this.path,
    this.onBreadcrumbPress,
    this.onPathSubmitted,
    this.leading,
    this.actions,
    this.loadingProgress,
    super.key,
  });

  @override
  State<BreadcrumbsBar> createState() => _BreadcrumbsBarState();
}

class _BreadcrumbsBarState extends State<BreadcrumbsBar> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _updateText();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant BreadcrumbsBar old) {
    super.didUpdateWidget(old);

    if (widget.path != old.path) {
      _updateText();
      setState(() {});
    }
  }

  void _updateText() {
    controller.text = widget.path.toPath();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: SizedBox.expand(
          child: Row(
            children: [
              if (widget.leading != null) const SizedBox(width: 8),
              if (widget.leading != null) ...widget.leading!,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _LoadingIndicator(
                      progress: widget.loadingProgress,
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        child: Container(
                          height: double.infinity,
                          alignment: AlignmentDirectional.centerStart,
                          child: focusNode.hasFocus
                              ? TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    isCollapsed: true,
                                  ),
                                  focusNode: focusNode,
                                  controller: controller,
                                  style: const TextStyle(fontSize: 14),
                                  onSubmitted: widget.onPathSubmitted,
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return _buildItemChip(
                                        index,
                                        widget.path.root,
                                      );
                                    } else {
                                      return _buildItemChip(
                                        index,
                                        widget.path.parts[index - 1],
                                      );
                                    }
                                  },
                                  itemCount: widget.path.parts.length + 1,
                                  separatorBuilder: (context, index) =>
                                      const VerticalDivider(width: 2),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.actions != null) ...widget.actions!,
              if (widget.actions != null) const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemChip(int index, String part) {
    return SizedBox(
      height: double.infinity,
      child: DragTarget<FileSystemEntity>(
        onAccept: (data) =>
            Utils.moveFileToDest(data, widget.path.toPath(index)),
        builder: (context, candidateData, rejectedData) {
          return InkWell(
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
                  child: Text(part),
                ),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
            onTap: () => widget.onBreadcrumbPress?.call(index),
          );
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatefulWidget {
  final double? progress;
  final Widget child;

  const _LoadingIndicator({
    required this.progress,
    required this.child,
  });

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController progressController;

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.progress != null ? 1 : 0,
    );
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: widget.progress,
    );
  }

  @override
  void didUpdateWidget(covariant _LoadingIndicator old) {
    super.didUpdateWidget(old);

    _updateController(old);
  }

  Future<void> _updateController(_LoadingIndicator old) async {
    if (widget.progress != old.progress) {
      if (widget.progress != null && old.progress == null) {
        fadeController.forward();
        progressController.animateTo(widget.progress!);
      } else if (widget.progress == null && old.progress != null) {
        await fadeController.reverse();
        progressController.value = 0;
      } else if (widget.progress != null && old.progress != null) {
        if (widget.progress! > old.progress!) {
          progressController.animateTo(widget.progress!);
        } else if (widget.progress! < old.progress!) {
          progressController.animateBack(widget.progress!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([progressController, fadeController]),
      builder: (context, child) {
        return CustomPaint(
          painter: _LoadingIndicatorPainter(
            progress: progressController.value,
            opacity: fadeController.value,
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _LoadingIndicatorPainter extends CustomPainter {
  final double progress;
  final double opacity;
  final Color color;

  const _LoadingIndicatorPainter({
    required this.progress,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect baseRect = Offset.zero & size;
    final Rect drawingRect = Offset.zero &
        Size(
          size.width * progress,
          size.height,
        );

    canvas.drawRect(
      baseRect,
      Paint()..color = color.withOpacity(opacity * 0.2),
    );

    canvas.drawRect(
      drawingRect,
      Paint()..color = color.withOpacity(opacity * 0.6),
    );
  }

  @override
  bool shouldRepaint(covariant _LoadingIndicatorPainter old) {
    return progress != old.progress ||
        opacity != old.opacity ||
        color.value != old.color.value;
  }
}
