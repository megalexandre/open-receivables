import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:organizagrana/app/app.dart';
import 'package:organizagrana/shared/config/runtime_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RuntimeConfig.initialize();
  usePathUrlStrategy();
  runApp(const MainApp());
}
