import 'package:flutter/material.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../widgets/action_button.dart';


class ResultActionsRow extends StatelessWidget {
  const ResultActionsRow({
    super.key,
    required this.onEdit,
    required this.onRetry,
  });

  final VoidCallback onEdit;
  final VoidCallback onRetry;



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            icon: Icons.edit_outlined,
            label: LocaleKeys.edit.t,
            onTap: onEdit,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActionButton(
            icon: Icons.refresh_outlined,
            label: LocaleKeys.try_again.t,
            onTap: onRetry,
          ),
        ),
      ],
    );
  }
}
