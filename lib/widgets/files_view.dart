import 'package:files/widgets/grid.dart';
import 'package:files/widgets/table.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/cupertino.dart';

class FilesView extends StatelessWidget {
  final List<FileCell> gridDelegates;
  final List<FilesRow> tableDelegates;

  // Come up with a way to save the scroll without interacting with _FilesWorkspaceState
  // ScrollControlled.addListener or key: PageStorageKey(controller) ?
  final ScrollController horizontalController;
  final ScrollController verticalController;

  const FilesView({
    required this.gridDelegates,
    required this.tableDelegates,
    required this.horizontalController,
    required this.verticalController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = WorkspaceController.of(context);

    return GestureDetector(
      onTap: WorkspaceController.of(context, listen: false).clearSelectedItems,
      child: Builder(
        builder: (context) {
          switch (controller.view) {
            case WorkspaceView.grid:
              return FilesGrid(cells: gridDelegates);
            case WorkspaceView.table:
            default:
              return FilesTable(
                rows: tableDelegates,
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
          }
        },
      ),
    );
  }
}
