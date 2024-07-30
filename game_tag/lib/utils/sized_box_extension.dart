import 'package:flutter/widgets.dart';

extension EmptySpace on num {
  SizedBox get h => SizedBox(height: toDouble());

  SizedBox get w => SizedBox(width: toDouble());
}
