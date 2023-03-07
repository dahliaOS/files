import 'dart:async';
import 'dart:io';

import 'package:files/backend/entity_info.dart';
import 'package:files/backend/fetch.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum WorkspaceView { table, grid }

class WorkspaceController with ChangeNotifier {
  WorkspaceController({required String initialDir}) {
    _resetStates();
    changeCurrentDir(initialDir);
  }

  // Scroll cache
  double lastHorizontalScrollOffset = 0.0;
  double lastVerticalScrollOffset = 0.0;

  // Private utilities
  CancelableFsFetch? _fetcher;
  StreamSubscription<FileSystemEvent>? _directoryStream;

  // Loading related
  late String _currentDir;
  List<EntityInfo>? _currentInfo;
  double? _loadingProgress;
  OSError? _lastError;

  // Sort, view and selection
  bool _ascending = true;
  bool _showHidden = false;
  SortType _sortType = SortType.name;
  WorkspaceView _view = WorkspaceView.table; // save on SharedPreferences?
  final List<EntityInfo> _selectedItems = [];

  // States
  late TableViewState _tableState;
  late GridViewState _gridState;

  // Navigation history
  final List<String> _history = [];
  int _historyOffset = 0;

  void _resetStates() {
    _tableState = const TableViewState(
      firstWidth: 480,
      secondWidth: 180,
      thirdWidth: 120,
      fourthWidth: 120,
    );
    _gridState = const GridViewState(size: 96);
  }

  Future<void> getInfoForDir(Directory dir) async {
    await _fetcher?.cancel();
    _lastError = null;
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
      sortType: _sortType,
      onFileSystemException: (value) {
        _lastError = value;
        notifyListeners();
      },
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

  SortType get sortType => _sortType;
  set sortType(SortType value) {
    _sortType = value;
    notifyListeners();
  }

  WorkspaceView get view => _view;
  set view(WorkspaceView value) {
    _view = value;
    notifyListeners();
  }

  TableViewState get tableState => _tableState;
  void setTableState(TableViewState state) {
    _tableState = state;
    notifyListeners();
  }

  GridViewState get gridState => _gridState;
  void setGridState(GridViewState state) {
    _gridState = state;
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

  List<String> get history => List.from(_history);
  int get historyOffset => _historyOffset;

  OSError? get lastError => _lastError;

  Future<void> changeCurrentDir(
    String newDir, {
    bool updateHistory = true,
  }) async {
    _currentDir = newDir;

    if (updateHistory) {
      if (_historyOffset != 0) {
        final List<String> validHistory =
            _history.reversed.toList().sublist(_historyOffset);
        _history.clear();
        _history.addAll(validHistory.reversed);
        _historyOffset = 0;
      }
      _history.add(_currentDir);
    }

    clearCurrentInfo();
    clearSelectedItems();
    await _directoryStream?.cancel();
    await getInfoForDir(Directory(newDir));
    _directoryStream =
        Directory(newDir).watch().listen(_directoryStreamListener);
  }

  void setHistoryOffset(int offset) {
    _historyOffset = 0; // hack
    changeCurrentDir(_history.reversed.toList()[offset], updateHistory: false);
    _historyOffset = offset;

    notifyListeners();
  }

  void goToPreviousHistoryEntry() => setHistoryOffset(_historyOffset + 1);
  void goToNextHistoryEntry() => setHistoryOffset(_historyOffset - 1);

  bool get canGoToPreviousHistoryEntry =>
      _history.length > 1 && _historyOffset < _history.length - 1;
  bool get canGoToNextHistoryEntry => _historyOffset != 0;

  Future<void> _directoryStreamListener(FileSystemEvent event) async {
    await getInfoForDir(Directory(currentDir));
  }

  static WorkspaceController of(BuildContext context, {bool listen = true}) {
    return Provider.of<WorkspaceController>(context, listen: listen);
  }
}

class TableViewState {
  final double firstWidth;
  final double secondWidth;
  final double thirdWidth;
  final double fourthWidth;

  const TableViewState({
    required this.firstWidth,
    required this.secondWidth,
    required this.thirdWidth,
    required this.fourthWidth,
  });

  List<double> get widths => [
        firstWidth,
        secondWidth,
        thirdWidth,
        fourthWidth,
      ];

  TableViewState copyWith({
    double? firstWidth,
    double? secondWidth,
    double? thirdWidth,
    double? fourthWidth,
  }) {
    return TableViewState(
      firstWidth: firstWidth ?? this.firstWidth,
      secondWidth: secondWidth ?? this.secondWidth,
      thirdWidth: thirdWidth ?? this.thirdWidth,
      fourthWidth: fourthWidth ?? this.fourthWidth,
    );
  }

  TableViewState applyDeltaToWidth(int index, double delta) {
    switch (index) {
      case 0:
        return copyWith(firstWidth: firstWidth + delta);
      case 1:
        return copyWith(secondWidth: secondWidth + delta);
      case 2:
        return copyWith(thirdWidth: thirdWidth + delta);
      case 3:
        return copyWith(fourthWidth: fourthWidth + delta);
    }

    throw RangeError.index(index, widths);
  }
}

class GridViewState {
  final double size;

  const GridViewState({
    required this.size,
  });
}
