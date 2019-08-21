# :star2: AnimatedListViewScroll

Provides a listview with animation on the scroll

## :dart: Installing

```yaml
dependencies:
  animated_list_view_scroll: any
```

### :inbox_tray: Import

```dart
import 'package:animated_list_view_scroll/animated_list_view_scroll.dart';
```

## :video_game: How To Use

```dart
AnimatedListViewScroll(
        itemCount: 1000, //REQUIRED
        itemHeight: 60, //REQUIRED (Total height of a single item must contains optional padding or margin)
        animationOnReverse: true,
        animationDuration: Duration(milliseconds: 200),
        itemBuilder: (context, index) {
          return AnimatedListViewItem(
            key: GlobalKey(), //REQUIRED
            index: index, //REQUIRED
            animationBuilder: (context, index, controller) {
              Animation<Offset> animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(controller);
              return SlideTransition(
                position: animation,
                child: Container(
                  height: 60,
                  child: Card(
                    child: Text(index.toString()),
                  ),
                ),
              );
            },
          );
        },
      );
```
      
## 🚀 Showcase

![Example](https://github.com/MarcoMihaiCondrache/animated_list_view_scroll/blob/master/example.gif)

## :construction: Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.

### :exclamation: Note

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

## :page_with_curl: License

Apache 2.0 [License](https://github.com/MarcoMihaiCondrache/animated_list_view_scroll/blob/master/LICENSE)