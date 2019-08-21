library animated_list_view_scroll;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef ItemBuilder = AnimatedListViewItem Function(
    BuildContext context, int index);
typedef AnimationBuilder = Widget Function(
    BuildContext context, int index, AnimationController controller);

class AnimatedListViewScroll extends StatefulWidget {
  final Key key;

  /// itemCount
  ///
  /// Type: [Axis]
  ///
  /// Defines the listview scrollDirection

  final Axis scrollDirection;

  /// itemCount
  ///
  /// Type: [ItemBuilder]
  ///
  /// Defines the builder of a single item
  ///
  /// This is a REQUIRED parameter and must RETURN a [AnimatedListViewItem].

  final ItemBuilder itemBuilder;

  /// itemHeight
  ///
  /// Type: [double]
  ///
  /// Defines the height of a single item in listview
  ///
  /// This is a REQUIRED parameter. The height must contains all paddings and margins of the item.

  final double itemHeight;

  /// itemCount
  ///
  /// Type: [double]
  ///
  /// Defines the count of the total items
  ///
  /// This is a REQUIRED parameter.

  final int itemCount;

  /// animationOnReverse
  ///
  /// Type: [Bool]
  ///
  /// Defines if animation must be started on reverse scroll

  final bool animationOnReverse;

  /// animationDuration
  ///
  /// Type: [Duration]
  ///
  /// Defines the time to execute an animation on scroll

  final Duration animationDuration;
  final ScrollPhysics physics;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// AnimatedListViewScroll
  ///
  /// A widget that provide a ListView builder with animation on the bottom and top executed on list scroll
  ///
  /// In this example we have an [AnimatedListViewScroll] widget that has a itemBuilder that
  /// return a [AnimatedListViewItem] with a SlideTransition animation and display the index in a text.
  ///
  /// {@tool snippet --template=animated_list_view}
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: Text('Sample Code'),
  ///     ),
  ///     body: AnimatedListViewScroll(
  ///      itemCount: 1000,
  ///      itemHeight: 60,
  ///      animationOnReverse: true,
  ///      animationDuration: Duration(milliseconds: 200),
  ///      itemBuilder: (context, index) {
  ///        return AnimatedListViewItem(
  ///          key: GlobalKey(),
  ///          index: index,
  ///          animationBuilder: (context, index, controller) {
  ///            Animation<Offset> animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(controller);
  ///            return SlideTransition(
  ///              position: animation,
  ///              child: Card(
  ///                  child: Text(index.toString()),
  ///               ),
  ///            );
  ///          },
  ///        );
  ///      },
  ///    ),
  ///  );
  ///}
  /// ```
  /// {@end-tool}
  ///
  AnimatedListViewScroll({
    this.key,
    @required this.itemBuilder,
    @required this.itemHeight,
    @required this.itemCount,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationOnReverse = false,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
  })  : assert(itemHeight != 0, 'Item height cannot be 0'),
        assert(itemBuilder != null,
            "The itemBuilder cannot be null as the docs say it is a required parameter"),
        assert(itemCount != null,
            "The itemCount cannot be null as the docs say it is a required parameter");

  @override
  _AnimatedListViewScrollState createState() => _AnimatedListViewScrollState();
}

class _AnimatedListViewScrollState extends State<AnimatedListViewScroll> {
  ScrollController _controller;
  List<AnimatedListViewItem> items = [];

  int getFirstIndexVisible(controller) {
    int itemCount = widget.itemCount;
    double scrollOffset = controller.position.pixels;
    double viewportHeight = controller.position.viewportDimension;
    double scrollRange = controller.position.maxScrollExtent -
        controller.position.minScrollExtent;
    int firstVisibleItemIndex =
        (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
    return firstVisibleItemIndex;
  }

  int getLastIndexVisible(controller) {
    double itemHeight = widget.itemHeight;
    double viewportHeight = _controller.position.viewportDimension;
    int firstIndex = getFirstIndexVisible(controller);
    return firstIndex + (viewportHeight / itemHeight).floor();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      print(getFirstIndexVisible(_controller));
      if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        if (getFirstIndexVisible(_controller) == 0) {
          for (int i = 0; i < getLastIndexVisible(_controller); i++) {
            items[i].key.currentState.forward(widget.animationOnReverse
                ? widget.animationDuration
                : Duration(milliseconds: 0));
          }
        } else {
          items[getFirstIndexVisible(_controller)].key.currentState.forward(
              widget.animationOnReverse
                  ? widget.animationDuration
                  : Duration(milliseconds: 0));
        }
      } else {
        if (_controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          items[getLastIndexVisible(_controller) + 1]
              .key
              .currentState
              .forward(widget.animationDuration);
        }
      }
      /*for (int i = getFirstIndexVisible(_controller);
          i < getLastIndexVisible(_controller);
          i++) {
        items[i].key.currentState.forward(widget.animationOnReverse
            ? widget.animationDuration
            : Duration(milliseconds: 0));
      }*/
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getFirstIndexVisible(_controller) == 0) {
        for (int i = 0; i < getLastIndexVisible(_controller) + 1; i++) {
          items[i].key.currentState.forward(widget.animationOnReverse
              ? widget.animationDuration
              : Duration(milliseconds: 0));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.key,
      controller: _controller,
      padding: EdgeInsets.all(0.0),
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        AnimatedListViewItem item = widget.itemBuilder(context, index);
        items.add(item);
        return Container(
          height: widget.itemHeight,
          child: item,
        );
      },
    );
  }
}

class AnimatedListViewItem extends StatefulWidget {
  /// index
  ///
  /// Type: [int]
  ///
  /// Defines the position in the listView
  ///
  /// This is a REQUIRED Parameter.
  ///
  final int index;

  /// animationBuilder
  ///
  /// Type: [AnimationBuilder]
  ///
  /// Defines the builder of the animation
  ///
  /// This is a REQUIRED Parameter.

  final AnimationBuilder animationBuilder;

  /// key
  ///
  /// Type: [GlobalKey]
  ///
  /// Defines the unique key of this item in the list
  ///
  /// This is a REQUIRED Parameter.

  final GlobalKey<_AnimatedListViewItemState> key;

  /// AnimatedListViewItem
  ///
  /// A widget that is required in [AnimatedListViewScroll] to work properly.
  ///
  /// In this example we have an [AnimatedListViewScroll] widget that has a itemBuilder that
  /// return a [AnimatedListViewItem] with a SlideTransition animation and display the index in a text.
  ///
  /// {@tool snippet --template=animated_list_view}
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: Text('Sample Code'),
  ///     ),
  ///     body: AnimatedListViewScroll(
  ///      itemCount: 1000,
  ///      itemHeight: 60,
  ///      animationOnReverse: true,
  ///      animationDuration: Duration(milliseconds: 200),
  ///      itemBuilder: (context, index) {
  ///        return AnimatedListViewItem(
  ///          key: GlobalKey(),
  ///          index: index,
  ///          animationBuilder: (context, index, controller) {
  ///            Animation<Offset> animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(controller);
  ///            return SlideTransition(
  ///              position: animation,
  ///              child: Card(
  ///                  child: Text(index.toString()),
  ///               ),
  ///            );
  ///          },
  ///        );
  ///      },
  ///    ),
  ///  );
  ///}
  /// ```
  /// {@end-tool}
  ///

  AnimatedListViewItem(
      {@required this.key,
      @required this.index,
      @required this.animationBuilder})
      : super(key: key);

  @override
  _AnimatedListViewItemState createState() => _AnimatedListViewItemState();
}

class _AnimatedListViewItemState extends State<AnimatedListViewItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Widget animationBuilder;

  void forward(Duration duration) {
    _controller.duration = duration;
    _controller.forward();
  }

  void reverse(Duration duration) {
    _controller.duration = duration;
    _controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, widget) {
        return widget;
      },
      child: widget.animationBuilder(context, widget.index, _controller),
    );
  }
}
