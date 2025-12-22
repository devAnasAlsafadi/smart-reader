// Flutter
import 'package:flutter/material.dart';

// Localization
import 'package:smart_reader/core/extensions/localization_extension.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

// Core
import 'package:smart_reader/core/enum/location_mode.dart';
import 'package:smart_reader/core/theme/app_color.dart';
import 'package:smart_reader/core/theme/app_text_style.dart';
import 'package:smart_reader/core/utils/app_dimens.dart';

// Shared Widgets
import 'package:smart_reader/features/auth/presentation/widgets/my_text_field.dart';

// Local Widgets
import 'location_mode_button.dart';


class LocationModeBox extends StatelessWidget {
  final LocationMode mode;
  final TextEditingController latCtrl;
  final TextEditingController lngCtrl;
  final VoidCallback onGpsTap;
  final VoidCallback onSelectGps;
  final VoidCallback onSelectManual;

  const LocationModeBox({
    super.key,
    required this.mode,
    required this.latCtrl,
    required this.lngCtrl,
    required this.onGpsTap,
    required this.onSelectGps,
    required this.onSelectManual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                LocaleKeys.location_mode.t,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.verticalSpaceSmall),

          Row(
            children: [
              Expanded(
                child: LocationModeButton(
                  label: LocaleKeys.use_gps.t,
                  subLabel: LocaleKeys.recommended.t,
                  icon: Icons.navigation_outlined,
                  isActive: mode == LocationMode.gps,
                  onTap: onSelectGps,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LocationModeButton(
                  label: LocaleKeys.enter_manually.t,
                  subLabel:LocaleKeys.enter_coordinates.t,

                  icon: Icons.edit_outlined,
                  isActive: mode == LocationMode.manual,
                  onTap: onSelectManual,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (mode == LocationMode.gps)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onGpsTap,
                icon: const Icon(Icons.my_location),
                label:  Text(LocaleKeys.get_current_location.t),
              ),
            ),

          if (mode == LocationMode.manual) ...[
            const SizedBox(height: AppDimens.verticalSpace),
            Text(LocaleKeys.latitude.t, style: AppTextStyles.body),
            const SizedBox(height: 5),
            MyTextField(
              controller: latCtrl,
              hintText: LocaleKeys.latitude_hint.t,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              obscureText: false,
            ),
            const SizedBox(height: AppDimens.verticalSpaceSmall),
            Text(LocaleKeys.longitude.t, style: AppTextStyles.body),
            const SizedBox(height: 5),
            MyTextField(
              controller: lngCtrl,
              textInputAction: TextInputAction.next,
              hintText: LocaleKeys.longitude_hint.t,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              obscureText: false,
            ),
          ],
        ],
      ),
    );
  }
}
