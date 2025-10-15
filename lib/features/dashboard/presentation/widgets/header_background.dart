import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import 'header_content.dart';

class HeaderBackground extends StatelessWidget {
  final double t;
  final String userName;
  final String userAvatarUrl;
  final double balance;
  final String currency;
  final NumberFormat formatter;
  static const double kHeaderRadius = 32;
  const HeaderBackground({
    Key? key,
    required this.t,
    required this.userName,
    required this.userAvatarUrl,
    required this.balance,
    required this.currency,
    required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kprimaryColor500, AppColors.kprimaryColor700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kHeaderRadius * t),
          bottomRight: Radius.circular(kHeaderRadius * t),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: _buildCircle(
              150,
              AppColors.kprimaryColor100.withOpacity(0.15),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -30,
            child: _buildCircle(
              120,
              AppColors.kprimaryColor200.withOpacity(0.18),
            ),
          ),
          HeaderContent(
            context: context,
            t: t,
            userName: userName,
            userAvatarUrl: userAvatarUrl,
            balance: balance,
            currency: currency,
            formatter: formatter,
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
