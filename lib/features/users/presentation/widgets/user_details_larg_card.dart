import 'package:flutter/material.dart';
import 'package:smart_reader/core/theme/app_color.dart';

import '../../domain/entities/user_entity.dart';

class UserLargeCard extends StatelessWidget {
  final UserEntity user;

  const UserLargeCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style:  TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black87,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
               Icon(Icons.location_on_outlined,
                  size: 18, color: AppColors.blue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  user.address,
                  style:  TextStyle(
                    fontSize: 14,
                    color: AppColors.black54,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsetsDirectional.only(start: 24),
            child: Text(
              user.street,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
