/*
Copyright 2019 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'package:animations/animations.dart';
import 'package:files/backend/providers.dart';
import 'package:files/backend/utils.dart';
import 'package:files/widgets/context_menu/context_menu_theme.dart';
import 'package:files/widgets/side_pane.dart';
import 'package:files/widgets/tab_strip.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initProviders();

  runApp(const Files());
}

class Files extends StatelessWidget {
  const Files({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Files',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.deepOrange,
          secondary: Colors.deepOrange,
          background: Color(0xFF161616),
          surface: Color(0xFF212121),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: const MaterialStatePropertyAll(true),
          trackVisibility: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.hovered),
          ),
          trackBorderColor: MaterialStateProperty.all(Colors.transparent),
          crossAxisMargin: 0,
          mainAxisMargin: 0,
          radius: Radius.zero,
        ),
        extensions: [ContextMenuTheme()],
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const FilesHome(),
    );
  }
}

class FilesHome extends StatefulWidget {
  const FilesHome({super.key});

  @override
  _FilesHomeState createState() => _FilesHomeState();
}

class _FilesHomeState extends State<FilesHome> {
  final List<SideDestination> sideDestinations = [];
  final List<WorkspaceController> workspaces = [];
  final PageStorageBucket bucket = PageStorageBucket();
  int currentWorkspace = 0;

  String get currentDir => workspaces[currentWorkspace].currentDir;

  @override
  void initState() {
    super.initState();
    for (final MapEntry<String, IconData> element
        in folderProvider.directories.entries) {
      sideDestinations.add(
        SideDestination(
          element.value,
          Utils.getEntityName(element.key),
          element.key,
        ),
      );
    }
    workspaces
        .add(WorkspaceController(initialDir: sideDestinations.first.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SidePane(
          destinations: sideDestinations,
          workspace: workspaces[currentWorkspace],
          onNewTab: (String tabPath) {
            workspaces.add(WorkspaceController(initialDir: tabPath));
            currentWorkspace = workspaces.length - 1;
            setState(() {});
          },
        ),
        Expanded(
          child: Material(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: TabStrip(
                    tabs: workspaces,
                    selectedTab: currentWorkspace,
                    allowClosing: workspaces.length > 1,
                    onTabChanged: (index) =>
                        setState(() => currentWorkspace = index),
                    onTabClosed: (index) {
                      workspaces.removeAt(index);
                      if (index < workspaces.length) {
                        currentWorkspace = index;
                      } else if (index - 1 >= 0) {
                        currentWorkspace = index - 1;
                      }
                      setState(() {});
                    },
                    onNewTab: () {
                      workspaces
                          .add(WorkspaceController(initialDir: currentDir));
                      currentWorkspace = workspaces.length - 1;
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: PageTransitionSwitcher(
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.scaled,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                    child: FilesWorkspace(
                      key: ValueKey(currentWorkspace),
                      controller: workspaces[currentWorkspace],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
