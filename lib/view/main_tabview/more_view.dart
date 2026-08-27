import 'package:flutter/material.dart';

import '../../common/auth_service.dart';
import '../../common/color_extension.dart';
import '../login/welcome_view.dart';
import 'info_page_view.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  void _logOut(BuildContext context) {
    AuthService.instance.logOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeView()),
      (route) => false,
    );
  }

  void _openInfo(BuildContext context, String title, String body) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPageView(title: title, body: body),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                "More",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
            ),
            _MoreTile(
              icon: Icons.info_outline,
              title: "About CookIN",
              onTap: () => _openInfo(
                context,
                "About CookIN",
                "CookIN connects you with home chefs cooking real, home-made "
                    "food nearby - browse dishes, add them to your cart, and "
                    "place an order in a few taps.\n\n"
                    "This build is a demo: there's no backend, so orders, "
                    "accounts, and payments aren't real.",
              ),
            ),
            _MoreTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () => _openInfo(
                context,
                "Help & Support",
                "Frequently asked questions:\n\n"
                    "• How do I order? Tap a dish on Home or Menu, choose a "
                    "quantity, and add it to your cart.\n\n"
                    "• How do I pay? This demo doesn't process real payments - "
                    "\"Place Order\" just confirms the order locally.\n\n"
                    "• Can I track delivery? Not in this build - there's no "
                    "backend to track a real delivery.",
              ),
            ),
            _MoreTile(
              icon: Icons.description_outlined,
              title: "Terms & Privacy",
              onTap: () => _openInfo(
                context,
                "Terms & Privacy",
                "This is a demo application built for learning and "
                    "portfolio purposes. It does not collect, store, or "
                    "share any real personal data - everything you enter "
                    "stays on your device for the current session only.",
              ),
            ),
            const Divider(height: 32),
            _MoreTile(
              icon: Icons.logout,
              title: "Log Out",
              color: Colors.redAccent,
              onTap: () => _logOut(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? TColor.primary),
      title: Text(
        title,
        style: TextStyle(
            color: color ?? TColor.primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w600),
      ),
      trailing: Icon(Icons.chevron_right, color: TColor.placeholder),
      onTap: onTap,
    );
  }
}
