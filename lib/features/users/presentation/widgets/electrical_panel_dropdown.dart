import 'package:flutter/material.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import '../../../electrical_panels/domain/entities/electrical_panel_entity.dart';


class ElectricalPanelDropdown extends StatelessWidget {
  final List<ElectricalPanelEntity> panels;
  final ElectricalPanelEntity? value;
  final ValueChanged<ElectricalPanelEntity?> onChanged;

  const ElectricalPanelDropdown({
    super.key,
    required this.panels,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ElectricalPanelEntity>(
      isExpanded: true,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: LocaleKeys.select_electrical_panel.t,
        prefixIcon: const Icon(
          Icons.flash_on_rounded,
          color: AppColors.primary,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      items: panels.map((panel) {
        return DropdownMenuItem<ElectricalPanelEntity>(
          value: panel,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              panel.name,
              style: AppTextStyles.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
