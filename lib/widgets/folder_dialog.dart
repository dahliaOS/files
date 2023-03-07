import 'package:flutter/material.dart';

class FolderDialog extends StatefulWidget {
  const FolderDialog({super.key});

  @override
  State<FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends State<FolderDialog> {
  final TextEditingController controller = TextEditingController();
  final RegExp folderValidator = RegExp(
    r'^[^\s^\x00-\x1f\\?*:"";<>|\/][^\x00-\x1f\\?*:"";<>|\/]*[^\s^\x00-\x1f\\?*:"";<>|\/.]+$',
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Folder"),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Folder name",
        ),
        controller: controller,
        onSubmitted: (value) {
          Navigator.pop(context, value);
        },
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, __) => TextButton(
            onPressed:
                value.text.isNotEmpty && folderValidator.hasMatch(value.text)
                    ? () => Navigator.of(context).pop(controller.text)
                    : null,
            child: const Text("Create"),
          ),
        ),
      ],
    );
  }
}
