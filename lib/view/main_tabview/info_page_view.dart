import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

/// A simple static text page, used for About/Help/Terms-style content.
class InfoPageView extends StatelessWidget {
  final String title;
  final String body;

  const InfoPageView({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        surfaceTintColor: TColor.white,
        elevation: 0,
        iconTheme: IconThemeData(color: TColor.primaryText),
        title: Text(title,
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          body,
          style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5),
        ),
      ),
    );
  }
}
