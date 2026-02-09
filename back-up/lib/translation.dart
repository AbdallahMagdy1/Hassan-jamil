import 'package:get/get.dart';

import 'global/lang/ar.dart';
import 'global/lang/en.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': ar};
}
