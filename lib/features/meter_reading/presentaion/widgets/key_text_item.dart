
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_style.dart';

class KeyTextItem extends StatelessWidget {
  final String text;
  const KeyTextItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}