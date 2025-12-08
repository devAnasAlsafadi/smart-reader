import 'package:flutter/material.dart';
import '../../../../../core/enum/location_mode.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../auth/presentation/widgets/my_text_field.dart';
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
                "Location Mode",
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
                  label: "Use GPS",
                  subLabel: "Recommended",
                  icon: Icons.navigation_outlined,
                  isActive: mode == LocationMode.gps,
                  onTap: onSelectGps,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LocationModeButton(
                  label: "Enter Manually",
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
                label: const Text("Get Current Location"),
              ),
            ),

          if (mode == LocationMode.manual) ...[
            const SizedBox(height: AppDimens.verticalSpace),
            Text("Latitude", style: AppTextStyles.body),
            const SizedBox(height: 5),
            MyTextField(
              controller: latCtrl,
              hintText: "e.g. 37.7749",
              keyboardType: TextInputType.number,
              obscureText: false,
            ),
            const SizedBox(height: AppDimens.verticalSpaceSmall),
            Text("Longitude", style: AppTextStyles.body),
            const SizedBox(height: 5),
            MyTextField(
              controller: lngCtrl,
              hintText: "e.g. -122.4194",
              keyboardType: TextInputType.number,
              obscureText: false,
            ),
          ],
        ],
      ),
    );
  }
}
