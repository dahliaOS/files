import 'dart:async';
import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/fetch.dart';
import 'package:files/backend/path_parts.dart';
import 'package:files/widgets/breadcrumbs_bar.dart';
import 'package:files/widgets/table.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FilesWorkspace extends StatefulWidget {
  final WorkspaceController controller;

  const FilesWorkspace({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _FilesWorkspaceState createState() => _FilesWorkspaceState();
}

class _FilesWorkspaceState extends State<FilesWorkspace> {
  /* TO KEEP */
  late final CachingScrollController horizontalController;
  late final CachingScrollController verticalController;

  WorkspaceController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    horizontalController = CachingScrollController(
        initialScrollOffset: controller.lastHorizontalScrollOffset);
    verticalController = CachingScrollController(
        initialScrollOffset: controller.lastVerticalScrollOffset);
    controller.addListener(onControllerUpdate);
  }

  @override
  void dispose() {
    controller.lastHorizontalScrollOffset =
        horizontalController.lastPosition.pixels;
    controller.lastVerticalScrollOffset =
        verticalController.lastPosition.pixels;
    controller.removeListener(onControllerUpdate);
    super.dispose();
  }

  void onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: BreadcrumbsBar(
            path: PathParts.parse(controller.currentDir),
            onBreadcrumbPress: (value) {
              controller.currentDir =
                  PathParts.parse(controller.currentDir).toPath(value);
            },
            onPathSubmitted: (path) async {
              final bool exists = await Directory(path).exists();

              if (exists) {
                controller.currentDir = path;
              } else {
                setState(() {});
              }
            },
            leading: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_upward,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    PathParts backDir = PathParts.parse(controller.currentDir);
                    controller.currentDir =
                        backDir.toPath(backDir.parts.length - 1);
                  });
                },
                splashRadius: 16,
              ),
            ],
            actions: [
              PopupMenuButton<String>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                offset: const Offset(0, 50),
                onSelected: (value) {
                  if (value == 'showHidden') {
                    controller.showHidden = !controller.showHidden;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'showHidden',
                    child: SwitchListTile(
                      title: const Text('Show hidden files'),
                      value: controller.showHidden,
                      onChanged: (value) {
                        setState(() {
                          controller.showHidden = value;
                          controller.currentDir = controller.currentDir;
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.create_new_folder_outlined,
                  color: Colors.white,
                ),
                tooltip: "New folder",
                onPressed: () async {
                  final PathParts currentDir =
                      PathParts.parse(controller.currentDir);
                  currentDir.parts.add("sussy");
                  await Directory(currentDir.toPath()).create();
                },
                splashRadius: 16,
              ),
            ],
            loadingProgress: controller.loadingProgress,
          ),
        ),
        Expanded(
          child: ChangeNotifierProvider.value(
            value: controller,
            child: body,
          ),
        ),
        SizedBox(
          height: 32,
          child: Material(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text("${controller.currentInfo?.length ?? 0} items"),
                  const Spacer(),
                  Text(selectedItemsLabel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String get selectedItemsLabel {
    if (controller.selectedItems.isEmpty) return "";

    late String itemLabel;

    if (controller.selectedItems.length == 1) {
      itemLabel = "item";
    } else {
      itemLabel = "items";
    }

    String baseString =
        "${controller.selectedItems.length} selected $itemLabel";

    if (controller.selectedItems.every((element) => element.isFile)) {
      int totalSize = controller.selectedItems.fold(
          0, (previousValue, element) => previousValue + element.stat.size);
      baseString += " ${filesize(totalSize)}";
    }

    return baseString;
  }

  Widget get body {
    return Builder(
      builder: (context) {
        if (controller.currentInfo != null) {
          if (controller.currentInfo!.isNotEmpty) {
            return FilesTable(
              rows: controller.currentInfo!
                  .map(
                    (entity) => FilesRow(
                      entity: entity,
                      selected: controller.selectedItems.contains(entity),
                      onTap: () {
                        bool selected =
                            controller.selectedItems.contains(entity);
                        final Set<LogicalKeyboardKey> keysPressed =
                            RawKeyboard.instance.keysPressed;
                        final bool multiSelect = keysPressed.contains(
                              LogicalKeyboardKey.controlLeft,
                            ) ||
                            keysPressed.contains(
                              LogicalKeyboardKey.controlRight,
                            );

                        if (!multiSelect) controller.clearSelectedItems();

                        if (!selected && multiSelect) {
                          controller.addSelectedItem(entity);
                        } else if (selected && multiSelect) {
                          controller.removeSelectedItem(entity);
                        } else {
                          controller.addSelectedItem(entity);
                        }
                        setState(() {});
                      },
                      onDoubleTap: () {
                        if (entity.isDirectory) {
                          controller.currentDir = entity.path;
                        } else {
                          launch(entity.path);
                        }
                      },
                    ),
                  )
                  .toList(),
              columns: [
                FilesColumn(
                  width: controller.columnWidths[0],
                  type: FilesColumnType.name,
                ),
                FilesColumn(
                  width: controller.columnWidths[1],
                  type: FilesColumnType.date,
                ),
                FilesColumn(
                  width: controller.columnWidths[2],
                  type: FilesColumnType.type,
                  allowSorting: false,
                ),
                FilesColumn(
                  width: controller.columnWidths[3],
                  type: FilesColumnType.size,
                ),
              ],
              ascending: controller.ascending,
              columnIndex: controller.columnIndex,
              onHeaderCellTap: (newAscending, newColumnIndex) {
                if (controller.columnIndex == newColumnIndex) {
                  controller.ascending = newAscending;
                } else {
                  controller.ascending = true;
                  controller.columnIndex = newColumnIndex;
                }
                controller.changeCurrentDir(controller.currentDir);
              },
              onHeaderResize: (newColumnIndex, details) {
                controller.addToColumnWidth(
                  newColumnIndex,
                  details.primaryDelta!,
                );
              },
              horizontalController: horizontalController,
              verticalController: verticalController,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 80,
                  ),
                  Text(
                    "This Folder is Empty",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 4),
          );
        }
      },
    );
  }
}

class WorkspaceController with ChangeNotifier {
  WorkspaceController({required String initialDir}) {
    currentDir = initialDir;
  }

  double lastHorizontalScrollOffset = 0.0;
  double lastVerticalScrollOffset = 0.0;
  late String _currentDir;
  final List<double> _columnWidths = [480, 180, 120, 120];
  bool _ascending = true;
  bool _showHidden = false;
  int _columnIndex = 0;
  final List<EntityInfo> _selectedItems = [];
  List<EntityInfo>? _currentInfo;
  double? _loadingProgress;
  CancelableFsFetch? _fetcher;
  StreamSubscription<FileSystemEvent>? directoryStream;

  Future<void> getInfoForDir(Directory dir) async {
    await _fetcher?.cancel();
    _fetcher = CancelableFsFetch(
      directory: dir,
      onFetched: (data) {
        _currentInfo = data;
        notifyListeners();
      },
      onProgressChange: (value) {
        _loadingProgress = value;
        notifyListeners();
      },
      showHidden: _showHidden,
      ascending: _ascending,
      columnIndex: _columnIndex,
      onFileSystemException: (value) {},
    );
    await _fetcher!.startFetch();
  }

  List<EntityInfo>? get currentInfo =>
      _currentInfo != null ? List.unmodifiable(_currentInfo!) : null;
  double? get loadingProgress => _loadingProgress;

  void clearCurrentInfo() {
    _currentInfo = null;
    notifyListeners();
  }

  String get currentDir => _currentDir;
  set currentDir(String value) {
    _currentDir = value;
    changeCurrentDir(_currentDir);
    notifyListeners();
  }

  bool get ascending => _ascending;
  set ascending(bool value) {
    _ascending = value;
    notifyListeners();
  }

  bool get showHidden => _showHidden;
  set showHidden(bool value) {
    _showHidden = value;
    notifyListeners();
  }

  int get columnIndex => _columnIndex;
  set columnIndex(int value) {
    _columnIndex = value;
    notifyListeners();
  }

  List<double> get columnWidths => List.unmodifiable(_columnWidths);
  void setColumnWidth(int index, double width) {
    _columnWidths[index] = width;
    notifyListeners();
  }

  void addToColumnWidth(int index, double delta) {
    _columnWidths[index] += delta;
    notifyListeners();
  }

  List<EntityInfo> get selectedItems => List.unmodifiable(_selectedItems);
  void addSelectedItem(EntityInfo info) {
    _selectedItems.add(info);
    notifyListeners();
  }

  void removeSelectedItem(EntityInfo info) {
    _selectedItems.remove(info);
    notifyListeners();
  }

  void clearSelectedItems() {
    _selectedItems.clear();
    notifyListeners();
  }

  void changeCurrentDir(String newDir) async {
    clearCurrentInfo();
    clearSelectedItems();
    await directoryStream?.cancel();
    await getInfoForDir(Directory(newDir));
    directoryStream =
        Directory(newDir).watch().listen(_directoryStreamListener);
  }

  void _directoryStreamListener(FileSystemEvent event) async {
    await getInfoForDir(Directory(currentDir));
  }

  static WorkspaceController of(BuildContext context, {bool listen = true}) {
    return Provider.of<WorkspaceController>(context, listen: listen);
  }
}

class CachingScrollController extends ScrollController {
  CachingScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) : super(
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
          debugLabel: debugLabel,
        );

  bool _inited = false;
  late ScrollPosition lastPosition;

  @override
  void attach(ScrollPosition position) {
    lastPosition = position;
    super.attach(position);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    late final double initialPixels;

    if (!_inited) {
      initialPixels = initialScrollOffset;
      _inited = true;
    } else {
      initialPixels = 0;
    }

    return ScrollPositionWithSingleContext(
      physics: physics,
      context: context,
      initialPixels: initialPixels,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}
