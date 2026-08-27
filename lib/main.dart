import 'package:flutter/material.dart';

import 'common/color_extension.dart';
import 'view/on_boarding/startup_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookIN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        scaffoldBackgroundColor: TColor.white,
        useMaterial3: true,
      ),
      home: const StartupView(),
      // The screens are laid out for a phone. On a wide surface (web/desktop)
      // keep them in a centred phone-width frame instead of stretching them.
      builder: (context, child) => _PhoneFrame(child: child!),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  static const double maxWidth = 430;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (media.size.width <= maxWidth) return child;

    return ColoredBox(
      color: const Color(0xff2B2B2B),
      child: Center(
        child: SizedBox(
          width: maxWidth,
          child: MediaQuery(
            data: media.copyWith(
              size: Size(maxWidth, media.size.height),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
