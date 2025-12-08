import 'package:flutter/material.dart';
import '../../../../../core/enum/customer_filter_type.dart';

class HomeFilterChip extends StatelessWidget {
  final CustomerFilterType filter;
  final bool visible;
  final VoidCallback onClear;

  const HomeFilterChip({
    super.key,
    required this.filter,
    required this.visible,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final label = filter == CustomerFilterType.name ? "Name" : "Street";

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: visible
          ? Padding(
        key: ValueKey("chip-$label"),
        padding: const EdgeInsets.only(top: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            label: Text(label),
            deleteIcon: const Icon(Icons.close),
            onDeleted: onClear,
          ),
        ),
      )
          : const SizedBox.shrink(
        key: ValueKey("chip-empty"),
      ),
    );
  }
}
