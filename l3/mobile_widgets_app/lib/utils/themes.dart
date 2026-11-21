import 'package:material_ui/material_ui.dart';

import 'constants.dart';

class AppThemes {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
      );
}
