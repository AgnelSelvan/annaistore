
import 'dart:async';

class ThemeController {
  final _themeController = StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}

final themeController = ThemeController();