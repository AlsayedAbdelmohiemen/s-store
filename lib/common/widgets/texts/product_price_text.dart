import 'package:flutter/material.dart';

class SProductPriceText extends StatelessWidget {
  const SProductPriceText(
      {super.key,
      this.currencySign = '\$',
      required this.price,
      this.isLarge = false,
      this.lineThrough = false,
      this.maxLines = 1});
  final String currencySign, price;
  final bool isLarge;
  final bool lineThrough;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.titleLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
