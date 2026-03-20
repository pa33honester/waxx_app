import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

abstract class Utils {
  static String image = "https://i.pinimg.com/736x/2e/60/a5/2e60a5f919a6f3f54b1560cbc79ed62d.jpg";
  static void showLog(String text) => log(text);

  static void showToast(String text, [Color? color]) {
    showLog(text);
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: color ?? AppColors.grayLight,
      textColor: AppColors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void onChangeSystemColor() {
    Timer(
      const Duration(milliseconds: 300),
      () {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: AppColors.background,
            systemNavigationBarColor: AppColors.background,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
      },
    );
  }

  static List<String> size = ['X,XS,M,L,XL,XXL,3XL'];

  static Container buildDivider() {
    return Container(
      height: 1,
      color: AppColors.unselected.withValues(alpha: .5),
      margin: const EdgeInsets.symmetric(vertical: 10),
    );
  }

  static String generateRandomCode() {
    math.Random random = math.Random();
    int min = 100000; // Minimum 6-digit number
    int max = 999999; // Maximum 6-digit number
    int randomNumber = min + random.nextInt(max - min);
    return randomNumber.toString();
  }

  static String buildAddressString(String? address, String? city, String? state, String? country, String? zipCode) {
    final components = [
      address,
      city,
      state,
      country,
      zipCode,
    ].where((component) => component != null && component.isNotEmpty).toList();

    return components.join(', ');
  }

  static String getRemainingTime(String? endDate) {
    if (endDate == null) return '';

    final end = DateTime.parse(endDate);
    final now = DateTime.now();
    final remaining = end.difference(now);

    if (remaining.isNegative) return 'Ended';

    if (remaining.inDays > 1) {
      return '${remaining.inDays} days left';
    } else if (remaining.inDays == 1) {
      return '1 day left';
    } else {
      final hours = remaining.inHours.remainder(24).toString().padLeft(2, '0');
      final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes left';
    }
  }

  static String dateFormate(String dateString) {
    try {
      // Parse the API date string
      final DateTime date = DateTime.parse(dateString);

      // Format to dd/MM/yyyy hh:mm a (24-hour format with AM/PM)
      final DateFormat formatter = DateFormat('dd/MM/yyyy, hh:mm a');

      return formatter.format(date.toLocal()); // Convert to local timezone
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  static String maskName(String name) {
    if (name.isEmpty) return "";

    final random = math.Random();

    return name.split(" ").map((word) {
      if (word.length <= 2) {
        // If word is too short, return as is or mask middle
        return word.length == 2 ? word[0] + "*" : word;
      }

      // For longer words, randomly show some characters
      String result = "";
      for (int i = 0; i < word.length; i++) {
        // Show character with ~40% probability, adjust as needed
        if (random.nextDouble() < 0.4) {
          result += word[i];
        } else {
          result += "*";
        }
      }

      // Ensure at least one character is shown (not all masked)
      if (!result.contains(RegExp(r'[a-zA-Z]'))) {
        // If all masked, show a random character
        int randomIndex = random.nextInt(word.length);
        result = result.replaceRange(randomIndex, randomIndex + 1, word[randomIndex]);
      }

      return result;
    }).join(" ");
  }

  static String maskNameControlled(String name) {
    if (name.isEmpty) return "";

    final random = math.Random();

    return name.split(" ").map((word) {
      if (word.length <= 2) {
        return word.length == 2 ? word[0] + "*" : word;
      }

      // Calculate how many characters to show (30-50% of word length)
      int minShow = (word.length * 0.3).ceil();
      int maxShow = (word.length * 0.5).ceil();
      int charsToShow = minShow + random.nextInt(maxShow - minShow + 1);

      // Create list of indices to show
      List<int> indices = List.generate(word.length, (i) => i);
      indices.shuffle(random);
      Set<int> showIndices = indices.take(charsToShow).toSet();

      String result = "";
      for (int i = 0; i < word.length; i++) {
        result += showIndices.contains(i) ? word[i] : "*";
      }

      return result;
    }).join(" ");
  }
}

// >>>>>> >>>>>> Sized Box Extension <<<<<< <<<<<<

extension HeightExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
}

extension WidthExtension on num {
  SizedBox get width => SizedBox(width: toDouble());
}

class CustomFormatNumber {
  static String convert(int number) {
    if (number >= 10000000) {
      double millions = number / 1000000;
      return '${millions.toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      double thousands = number / 1000;
      return '${thousands.toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }
}
