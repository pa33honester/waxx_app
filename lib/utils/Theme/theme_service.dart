import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final getStorage = GetStorage();

// class ThemeService {
//   final _key = "isDarkMode";
//   // final lightToDark = getStorage.read("isDarkMode");
//
//   _saveThemeToBox(bool isDarkMode) => getStorage.write(_key, isDarkMode);
//
//   bool _loadThemeFromBox() => getStorage.read(_key) ?? false;
//   ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
//
//   void switchTheme() {
//     Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
//     _saveThemeToBox(!_loadThemeFromBox());
//   }
// }
