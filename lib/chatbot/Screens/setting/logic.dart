import 'package:get/get.dart';

class SettingLogic extends GetxController {
  List<Map<String, dynamic>> settings = [
    {
      'title': 'Restore',
      'icon': 'assets/images/restore.svg',
    },
    {
      'title': 'Help',
      'icon': 'assets/images/help.svg',
    },
    {
      'title': 'Rate Us',
      'icon': 'assets/images/rateus.svg',
    },
    {
      'title': 'Support',
      'icon': 'assets/images/support.svg',
    },
    {
      'title': 'More Apps',
      'icon': 'assets/images/moreapps.svg',
    },
    {
      'title': 'Terms & Conditions',
      'icon': 'assets/images/terms.svg',
    },
    {
      'title': 'Privacy Policy',
      'icon': 'assets/images/privacy.svg',
    },
  ].obs;
}
