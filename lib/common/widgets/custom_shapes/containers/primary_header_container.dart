import 'package:flutter/material.dart';
import 'package:s_store/common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edge_widget.dart';

class SPrimaryHeaderContainer extends StatelessWidget {
  const SPrimaryHeaderContainer({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SCurvedEdgeWidget(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SColors.primary,
              Color(0xFF4338CA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: SCircularContainer(
                backgroundColor: SColors.textWhite.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: SCircularContainer(
                backgroundColor: SColors.textWhite.withValues(alpha: 0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
