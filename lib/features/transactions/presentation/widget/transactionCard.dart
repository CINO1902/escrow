
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/appColor.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final String status;
  final double progress;
  final String buyer;
  final String seller;
  final String date;
  final NumberFormat formatter;
  final DateFormat dateFormatter;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.status,
    required this.progress,
    required this.buyer,
    required this.seller,
    required this.date,
    required this.formatter,
    required this.dateFormatter,
  }) : super(key: key);

  Color get statusColor {
    switch (status) {
      case 'Ongoing':
        return AppColors.kprimaryColor500;
      case 'Completed':
        return AppColors.ksuccessColor300;
      case 'Cancelled':
        return AppColors.kErrorColor300;
      default:
        return AppColors.kgrayColor100;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'Ongoing':
        return Icons.timelapse_rounded;
      case 'Completed':
        return Icons.check_circle_rounded;
      case 'Cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = dateFormatter.format(DateTime.parse(date));
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.kBorderGrey),
          boxShadow: [
            BoxShadow(
              color: AppColors.kprimaryColor100.withOpacity(0.13),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical accent bar
              Container(width: 6, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(statusIcon, color: statusColor, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kprimaryColor100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              formatter.format(amount),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.kprimaryColor700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildPartyAvatar(buyer),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.swap_horiz,
                            color: AppColors.kgrayColor100,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          _buildPartyAvatar(seller),
                          const SizedBox(width: 10),
                          Text(
                            'Buyer',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.kgrayColor100,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            buyer,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.kBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Seller',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.kgrayColor100,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            seller,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.kBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (status == 'Ongoing') ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.kprimaryColor50,
                            color: AppColors.kprimaryColor500,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(progress * 100).toInt()}% complete',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.kgrayColor100,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.kgrayColor100,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.kgrayColor100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartyAvatar(String name) {
    // Use initials as avatar for mockup
    String initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.kprimaryColor100,
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.kprimaryColor700,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
