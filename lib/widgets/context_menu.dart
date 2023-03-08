import 'package:flutter/material.dart';

class ContextMenu extends StatefulWidget {
  final List<BaseContextMenuItem> entries;
  final Widget child;
  final bool openOnLongPress;
  final bool openOnSecondaryPress;

  const ContextMenu({
    required this.entries,
    required this.child,
    this.openOnLongPress = true,
    this.openOnSecondaryPress = true,
    super.key,
  });

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  late Offset lastPosition;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: widget.entries.map((e) => e.buildWrapper(context)).toList(),
      builder: (context, controller, child) {
        return GestureDetector(
          onSecondaryTapUp: (details) =>
              controller.open(position: details.localPosition),
          onLongPressDown: (details) => lastPosition = details.localPosition,
          onLongPress: () => controller.open(position: lastPosition),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _EnabledBuilder extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const _EnabledBuilder({
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: child,
      ),
    );
  }
}

abstract class BaseContextMenuItem {
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;

  const BaseContextMenuItem({
    required this.child,
    this.enabled = true,
    this.leading,
    this.trailing,
  });

  Widget buildWrapper(BuildContext context) =>
      _EnabledBuilder(enabled: enabled, child: build(context));

  Widget build(BuildContext context);
  Widget? buildLeading(BuildContext context) => leading;
  Widget? buildTrailing(BuildContext context) => trailing;
}

class SubmenuMenuItem extends BaseContextMenuItem {
  final List<BaseContextMenuItem> menuChildren;

  const SubmenuMenuItem({
    required super.child,
    required this.menuChildren,
    super.leading,
    super.enabled,
  }) : super(trailing: null);

  @override
  Widget? buildTrailing(BuildContext context) {
    return const Icon(Icons.chevron_right, size: 16);
  }

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      menuChildren: menuChildren.map((e) => e.buildWrapper(context)).toList(),
      leadingIcon: buildLeading(context),
      trailingIcon: buildTrailing(context),
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      child: child,
    );
  }
}

class ContextMenuItem extends BaseContextMenuItem {
  final VoidCallback? onTap;
  final MenuSerializableShortcut? shortcut;

  const ContextMenuItem({
    required super.child,
    this.onTap,
    super.leading,
    super.trailing,
    this.shortcut,
    super.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final Widget? leading = buildLeading(context);

    return MenuItemButton(
      leadingIcon: leading != null
          ? IconTheme.merge(
              data: Theme.of(context).iconTheme.copyWith(size: 16),
              child: leading,
            )
          : null,
      trailingIcon: buildTrailing(context),
      onPressed: onTap,
      shortcut: shortcut,
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      child: child,
    );
  }
}

class RadioMenuItem<T> extends ContextMenuItem {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool toggleable;

  const RadioMenuItem({
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.toggleable = false,
    required super.child,
    super.trailing,
    super.shortcut,
    super.enabled,
  }) : super(leading: null, onTap: null);

  @override
  VoidCallback? get onTap => onChanged == null
      ? null
      : () {
          if (toggleable && groupValue == value) {
            onChanged!.call(null);
            return;
          }
          onChanged!.call(value);
        };

  @override
  Widget? buildTrailing(BuildContext context) {
    return ExcludeFocus(
      child: IgnorePointer(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: Checkbox.width,
            maxWidth: Checkbox.width,
          ),
          child: Radio<T>(
            groupValue: groupValue,
            value: value,
            onChanged: onChanged,
            toggleable: toggleable,
          ),
        ),
      ),
    );
  }
}

class CheckboxMenuItem extends ContextMenuItem {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;

  const CheckboxMenuItem({
    required this.value,
    this.onChanged,
    this.tristate = false,
    required super.child,
    super.trailing,
    super.shortcut,
    super.enabled,
  }) : super(leading: null, onTap: null);

  @override
  VoidCallback? get onTap => onChanged == null
      ? null
      : () {
          switch (value) {
            case false:
              onChanged!.call(true);
              break;
            case true:
              onChanged!.call(tristate ? null : false);
              break;
            case null:
              onChanged!.call(false);
              break;
          }
        };

  @override
  Widget? buildTrailing(BuildContext context) {
    return ExcludeFocus(
      child: IgnorePointer(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: Checkbox.width,
            maxWidth: Checkbox.width,
          ),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            tristate: tristate,
          ),
        ),
      ),
    );
  }
}

class ContextMenuDivider extends BaseContextMenuItem {
  const ContextMenuDivider() : super(child: const SizedBox());

  @override
  Widget build(BuildContext context) => const Divider();
}
