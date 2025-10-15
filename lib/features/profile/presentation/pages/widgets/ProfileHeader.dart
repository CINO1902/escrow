import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/utils/appColor.dart';
import '../../../../auth/presentation/provider/auth_provider.dart';

class ProfileHeader extends ConsumerWidget {
  final String userAvatarUrl;
  final VoidCallback onEdit;
  const ProfileHeader({
    Key? key,

    required this.userAvatarUrl,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.read(authProvider).userDetails;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kprimaryColor500, AppColors.kprimaryColor700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.only(top: 56, bottom: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              userDetails.profileImage ?? '',
            ),
            radius: 48,
          ),
          const SizedBox(height: 16),
          Text(
            '${userDetails.firstName ?? ''} ${userDetails.lastName ?? ''}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.kWhite,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            userDetails.email ?? '',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.kprimaryColor100,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
