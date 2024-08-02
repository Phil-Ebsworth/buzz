import 'package:flutter/widgets.dart';
import 'package:buzz/app/app.dart';
import 'package:buzz/home/home.dart';
import 'package:buzz/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
