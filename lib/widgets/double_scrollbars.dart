import 'package:flutter/material.dart';

class DoubleScrollbars extends StatelessWidget {
  final ScrollController horizontalController;
  final ScrollController verticalController;
  final Widget child;

  const DoubleScrollbars({
    required this.horizontalController,
    required this.verticalController,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ScrollNotificationIsolater(
        child: Scrollbar(
          controller: verticalController,
          isAlwaysShown: true,
          child: _ScrollReceiver(
            direction: Axis.vertical,
            child: ScrollNotificationIsolater(
              child: Scrollbar(
                controller: horizontalController,
                isAlwaysShown: true,
                child: _ScrollReceiver(
                  direction: Axis.horizontal,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollReceiver extends StatefulWidget {
  final Axis direction;
  final Widget child;

  const _ScrollReceiver({
    required this.direction,
    required this.child,
  });

  @override
  _ScrollReceiverState createState() => _ScrollReceiverState();
}

class _ScrollReceiverState extends State<_ScrollReceiver> {
  void notify(ScrollNotification notification) {
    notification.dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.direction) {
      case Axis.vertical:
        return VerticalScrollReceiver._(state: this, child: widget.child);
      case Axis.horizontal:
        return HorizontalScrollReceiver._(state: this, child: widget.child);
    }
  }
}

class _ScrollReceiverInheritedWidget extends InheritedWidget {
  final _ScrollReceiverState state;

  const _ScrollReceiverInheritedWidget({
    required this.state,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class HorizontalScrollReceiver extends _ScrollReceiverInheritedWidget {
  const HorizontalScrollReceiver._({
    required _ScrollReceiverState state,
    required Widget child,
  }) : super(state: state, child: child);

  static _ScrollReceiverState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<HorizontalScrollReceiver>()!
        .state;
  }
}

class VerticalScrollReceiver extends _ScrollReceiverInheritedWidget {
  const VerticalScrollReceiver._({
    required _ScrollReceiverState state,
    required Widget child,
  }) : super(state: state, child: child);

  static _ScrollReceiverState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<VerticalScrollReceiver>()!
        .state;
  }
}

class ScrollProxy extends StatelessWidget {
  final Axis direction;
  final Widget child;

  const ScrollProxy({
    required this.direction,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        late final _ScrollReceiverState provider;

        switch (direction) {
          case Axis.vertical:
            provider = VerticalScrollReceiver.of(context);
            break;
          case Axis.horizontal:
            provider = HorizontalScrollReceiver.of(context);
            break;
        }

        provider.notify(notification);
        return true;
      },
      child: child,
    );
  }
}

class ScrollNotificationIsolater extends StatelessWidget {
  final Widget child;

  const ScrollNotificationIsolater({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => true,
      child: child,
    );
  }
}
