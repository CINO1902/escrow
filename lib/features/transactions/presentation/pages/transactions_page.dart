import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import '../widget/transactionCard.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with SingleTickerProviderStateMixin {
  static final _dollarFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  static final _dateFormatter = DateFormat('MMM d, yyyy');

  final List<Map<String, dynamic>> allTransactions = [
    {
      'title': 'MacBook Pro (M2 chip)',
      'amount': 898430.00,
      'status': 'Ongoing',
      'progress': 0.87,
      'buyer': 'Yankie',
      'seller': 'John',
      'date': '2023-09-12',
    },
    {
      'title': 'Two bedroom house',
      'amount': 8430.00,
      'status': 'Ongoing',
      'progress': 0.32,
      'buyer': 'Yankie',
      'seller': 'Jane',
      'date': '2023-09-10',
    },
    {
      'title': 'iPhone 13pro',
      'amount': 5552.10,
      'status': 'Completed',
      'progress': 1.0,
      'buyer': 'Yankie',
      'seller': 'Alice',
      'date': '2023-08-20',
    },
    {
      'title': 'Gucci Bag',
      'amount': 552.10,
      'status': 'Cancelled',
      'progress': 0.0,
      'buyer': 'Yankie',
      'seller': 'Bob',
      'date': '2023-07-15',
    },
  ];

  final List<String> tabs = ['All', 'Ongoing', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.kWhite,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transactions',
                        style: TextStyle(
                          color: AppColors.kBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.kprimaryColor100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: AppColors.kprimaryColor500,
                          ),
                          onPressed: () {},
                          splashRadius: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.kWhite,
                  child: TabBar(
                    labelColor: AppColors.kprimaryColor500,
                    unselectedLabelColor: AppColors.kgrayColor100,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    indicator: BoxDecoration(
                      color: AppColors.kprimaryColor100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    indicatorPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.kBorderGrey,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            List<Map<String, dynamic>> filtered = tab == 'All'
                ? allTransactions
                : allTransactions.where((tx) => tx['status'] == tab).toList();
            if (filtered.isEmpty) {
              return _buildEmptyState(tab);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final tx = filtered[index];
                return TransactionCard(
                  title: tx['title'],
                  amount: tx['amount'],
                  status: tx['status'],
                  progress: tx['progress'],
                  buyer: tx['buyer'],
                  seller: tx['seller'],
                  date: tx['date'],
                  formatter: _dollarFormatter,
                  dateFormatter: _dateFormatter,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 64, color: AppColors.kgrayColor100),
          const SizedBox(height: 16),
          Text(
            'No $tab transactions',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.kgrayColor100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
