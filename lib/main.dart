import 'package:flutter/material.dart';
import 'app.dart';
import 'bloc_provider.dart';
import 'core/di/service_locator.dart';

void main() async {
  await setup();
  runApp(MyBlocProvider(child: const MyApp()));
}
