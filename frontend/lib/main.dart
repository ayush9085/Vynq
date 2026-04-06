import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

void main() {
  runApp(const VynkApp());
}

class VynkApp extends StatelessWidget {
  const VynkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VYNK 👀',
      theme: VynkTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
