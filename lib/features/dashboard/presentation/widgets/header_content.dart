import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/appColor.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class HeaderContent extends ConsumerWidget {
  final BuildContext context;
  final double t;
  final String userName;
  final String userAvatarUrl;
  final double balance;
  final String currency;
  final NumberFormat formatter;

  const HeaderContent({
    Key? key,
    required this.context,
    required this.t,
    required this.userName,
    required this.userAvatarUrl,
    required this.balance,
    required this.currency,
    required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(authProvider).userDetails;
    final double withdrawT = ((t - 0.7) / 0.3).clamp(0.0, 1.0);
    final double balanceT = ((t - 0.4) / 0.3).clamp(0.0, 1.0);
    final double labelT = (t / 0.4).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 40 + 6 * t,
                      width: 40 + 6 * t,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.kprimaryColor500,
                                  value: progress.progress,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          imageUrl: userDetails.profileImage ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: AppColors.kErrorColor500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6 + 6 * t),
                    Text(
                      'Hello ${userDetails.firstName}',
                      style: TextStyle(
                        fontSize: 14 + 4 * t,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kWhite,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 35 + 16 * t,
                  height: 35 + 16 * t,
                  decoration: BoxDecoration(
                    color: AppColors.kprimaryColor50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.kprimaryColor500,
                      size: 20 + 8 * t,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 35 * t),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (labelT > 0)
                    Opacity(
                      opacity: labelT,
                      child: Transform.scale(
                        scale: math.max(labelT, 0.7),
                        child: const Text(
                          'Current balance',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.kprimaryColor100,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (balanceT > 0)
                    Opacity(
                      opacity: balanceT,
                      child: Transform.scale(
                        scale: math.max(balanceT, 0.7),
                        child: Column(
                          children: [
                            Text(
                              formatter.format(balance),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.kWhite,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currency,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.kprimaryColor100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (withdrawT > 0)
                    Opacity(
                      opacity: withdrawT,
                      child: Transform.scale(
                        scale: math.max(withdrawT, 0.7),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: 140,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kprimaryColor500,
                                foregroundColor: AppColors.kprimaryColor500,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Withdraw',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
