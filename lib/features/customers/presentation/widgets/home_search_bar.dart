import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_reader/generated/locale_keys.g.dart';

import '../../../auth/presentation/widgets/my_text_field.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChange;
  final VoidCallback onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChange,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: controller,
            hintText: LocaleKeys.search.tr(),
            focusNode: focusNode,
            obscureText: false,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.search),
            onChange: onChange,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.filter_alt),
          ),
        ),
      ],
    );
  }
}
