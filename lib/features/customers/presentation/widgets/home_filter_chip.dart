// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/enum/customer_filter_type.dart';

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
    final label = filter == CustomerFilterType.name
        ? LocaleKeys.filter_name.t
        : LocaleKeys.filter_street.t;

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
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: visible
          ? Padding(
        key: ValueKey('chip-$label'),
        padding: const EdgeInsets.only(top: 8),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Chip(
            label: Text(label),
            deleteIcon: const Icon(Icons.close),
            onDeleted: onClear,
          ),
        ),
      )
          : const SizedBox.shrink(
        key: ValueKey('chip-empty'),
      ),
    );
  }
}

