import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import '../widgets/header_background.dart';
import '../../../transactions/presentation/pages/new_transaction_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final String userName = 'Yankie';
  final String userAvatarUrl = 'https://randomuser.me/api/portraits/men/1.jpg';
  final double balance = 50000.00;
  final String currency = 'USD';
  final String currencySymbol = '\$';

  static final _dollarFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  final List<Map<String, dynamic>> ongoingTransactions = [
    {
      'title': 'MacBook Pro(M2 chip), MacBook Pro(M2 chip',
      'amount': 898430.00,
      'progress': 0.87,
    },
    {'title': 'Two bedroom house', 'amount': 8430.00, 'progress': 0.32},
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {
      'title': 'iPhone 13pro',
      'amount': 5552.10,
      'isCredit': true,
      'date': '12/09/2023',
      'time': '09:33AM',
      'subtitle': 'Payment received',
    },
    {
      'title': 'Gucci Bag',
      'amount': 552.10,
      'isCredit': false,
      'date': '12/09/2023',
      'time': '09:33AM',
      'subtitle': 'Money sent',
    },
    {
      'title': 'Gucci Bag',
      'amount': 552.10,
      'isCredit': false,
      'date': '12/09/2023',
      'time': '09:33AM',
      'subtitle': 'Money sent',
    },
    {
      'title': 'Gucci Bag',
      'amount': 552.10,
      'isCredit': false,
      'date': '12/09/2023',
      'time': '09:33AM',
      'subtitle': 'Money sent',
    },
    {
      'title': 'Gucci Bag',
      'amount': 552.10,
      'isCredit': false,
      'date': '12/09/2023',
      'time': '09:33AM',
      'subtitle': 'Money sent',
    },
    {
      'title': 'Gucci Bag',
      'amount': 552.10,
      'isCredit': false,
      'date': '12/09/2023',
      'time': '09:33AM',
      'subtitle': 'Money sent',
    },
  ];

  static const double kExpandedHeaderHeight = 270;
  static const double kCollapsedHeaderHeight = kToolbarHeight + 32;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: kExpandedHeaderHeight,
          automaticallyImplyLeading: false,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final double t =
                  ((constraints.maxHeight - kCollapsedHeaderHeight) /
                          (kExpandedHeaderHeight - kCollapsedHeaderHeight))
                      .clamp(0.0, 1.0);

              return Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  HeaderBackground(
                    t: t,
                    userName: userName,
                    userAvatarUrl: userAvatarUrl,
                    balance: balance,
                    currency: currency,
                    formatter: _dollarFormatter,
                  ),
                ],
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildOngoingTransactions(),
                const SizedBox(height: 24),
                _buildRecentTransactions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kprimaryColor100,
              foregroundColor: AppColors.kprimaryColor700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('New Transaction'),
            onPressed: () {
              context.push('/new-transaction');
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kprimaryColor50,
              foregroundColor: AppColors.kprimaryColor700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.group_add_outlined),
            label: const Text('Join Transaction'),
            onPressed: () {
              context.push('/join-transaction');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOngoingTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ongoing Transactions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.kBlack,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ongoingTransactions.map((tx) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 180,
                    maxWidth: 250,
                  ),
                  child: IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        // color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(color: AppColors.kBorderGrey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _dollarFormatter.format(tx['amount']),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kprimaryColor700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: tx['progress'],
                            backgroundColor: AppColors.kprimaryColor50,
                            color: AppColors.kprimaryColor500,
                            minHeight: 6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(tx['progress'] * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.kgrayColor100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.kBlack,
              ),
            ),
            Text(
              'See all',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.kprimaryColor500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: recentTransactions.map((tx) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(
                      255,
                      239,
                      239,
                      239,
                    ), // Or use your custom color
                    width: 1.0, // Adjust width as needed
                  ),
                ),
                // color: AppColors.kWhite,
                // borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: AppColors.kBorderGrey),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: tx['isCredit']
                          ? AppColors.kSuccessColor50
                          : AppColors.kErrorColor50,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      tx['isCredit']
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: tx['isCredit']
                          ? AppColors.ksuccessColor300
                          : AppColors.kErrorColor300,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${tx['subtitle']} on ${tx['date']} - ${tx['time']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.kgrayColor100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${tx['isCredit'] ? '+' : '-'}${_dollarFormatter.format(tx['amount'])}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: tx['isCredit']
                          ? AppColors.ksuccessColor300
                          : AppColors.kErrorColor300,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
