import 'package:flutter/material.dart';

import '../../common/cart_service.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class FoodDetailView extends StatefulWidget {
  final Map item;

  const FoodDetailView({super.key, required this.item});

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  int quantity = 1;

  double get price => (widget.item["price"] as num?)?.toDouble() ?? 9.99;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  item["image"].toString(),
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundColor: TColor.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: TColor.primaryText),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"].toString(),
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (item["rate"] != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/img/rate.png",
                                width: 12, height: 12, fit: BoxFit.cover),
                            const SizedBox(width: 4),
                            Text(item["rate"].toString(),
                                style: TextStyle(
                                    color: TColor.primary, fontSize: 13)),
                          ],
                        ),
                      if (item["type"] != null)
                        Text(item["type"].toString(),
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 13)),
                      if (item["food_type"] != null)
                        Text(item["food_type"].toString(),
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "\$${price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      if (item["original_price"] != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          "\$${(item["original_price"] as num).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 15,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Quantity",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: TColor.primary,
                      ),
                      Text(
                        "$quantity",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                        color: TColor.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoundButton(
                    title:
                        "Add to Cart · \$${(price * quantity).toStringAsFixed(2)}",
                    onPressed: () {
                      CartService.instance.add(
                        item["name"].toString(),
                        item["image"].toString(),
                        price,
                        quantity: quantity,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Added ${item["name"]} to your cart")),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
