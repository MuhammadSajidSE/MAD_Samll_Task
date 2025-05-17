import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Course {
  final String title;
  final String code;
  final String imagePath;
  Course({
    required this.title,
    required this.code,
    required this.imagePath,
  });

  String get getImagePath => imagePath;
  String get getTitle => title;
  String get getCode => code;
}