
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/appColor.dart';
import '../../../../auth/presentation/provider/auth_provider.dart';
import 'infoRow.dart';

class ProfileInfoCard extends ConsumerWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.read(authProvider).userDetails;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Info',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor500,
              ),
            ),
            const SizedBox(height: 14),
            InfoRow(
              label: 'Full Name',
              value: '${userDetails.firstName} ${userDetails.lastName}',
            ),
            const SizedBox(height: 10),
            InfoRow(label: 'Email', value: userDetails.email ?? ''),
            const SizedBox(height: 10),
            InfoRow(label: 'Phone', value: userDetails.phone ?? ''),
            const SizedBox(height: 10),
            InfoRow(label: 'Location', value: userDetails.address ?? ''),
          ],
        ),
      ),
    );
  }
}
