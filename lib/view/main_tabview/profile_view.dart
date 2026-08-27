import 'package:flutter/material.dart';

import '../../common/auth_service.dart';
import '../../common/color_extension.dart';
import '../../common/order_history_service.dart';
import '../../common_widget/round_button.dart';
import '../login/welcome_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) {
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final period = d.hour < 12 ? 'AM' : 'PM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${_months[d.month - 1]} ${d.day}, ${d.year} · $hour12:$minute $period';
  }

  void _logOut(BuildContext context) {
    AuthService.instance.logOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: TColor.textfield,
                  child: Icon(Icons.person, size: 36, color: TColor.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? "Guest",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? "Not signed in",
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              "Your Orders",
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Order>>(
              valueListenable: OrderHistoryService.instance,
              builder: (context, orders, _) {
                if (orders.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColor.textfield,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "You haven't placed an order yet.",
                      style: TextStyle(
                          color: TColor.secondaryText, fontSize: 13),
                    ),
                  );
                }

                return Column(
                  children: orders.map((order) {
                    final itemNames =
                        order.items.map((item) => item.name).join(", ");
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: TColor.textfield,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(order.placedAt),
                                style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 12),
                              ),
                              Text(
                                "\$${order.total.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            itemNames,
                            style: TextStyle(
                                color: TColor.primaryText, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 28),
            RoundButton(
              title: "Log Out",
              type: RoundButtonType.textPrimary,
              onPressed: () => _logOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
