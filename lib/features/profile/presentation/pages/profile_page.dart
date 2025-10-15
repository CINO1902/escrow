import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/appColor.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
// import '../../wallet/presentation/pages/wallet_page.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import 'account_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  final String userName = 'Yankie Mensah';
  final String userEmail = 'yankie.mensah@email.com';
  final String userStatus = 'Escrow User';
  final String userAvatarUrl = 'https://randomuser.me/api/portraits/men/1.jpg';
  final double walletBalance = 2500.00;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(authProvider).userDetails;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        backgroundColor: AppColors.kBackgroundColor,
      ),
      backgroundColor: AppColors.kBackgroundColor,
      body: ListView(
        children: [
          // Profile Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: ClipRRect(
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
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: AppColors.kErrorColor500),
                  ),
                ),
                title: Text(
                  '${userDetails.firstName ?? ''} ${userDetails.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  userStatus,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.kgrayColor100,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.qr_code,
                    color: AppColors.kprimaryColor500,
                    size: 28,
                  ),
                  onPressed: () {},
                  tooltip: 'Show QR',
                ),
                onTap: () {}, // Could open profile edit
              ),
            ),
          ),

          // Wallet & Transactions Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              'Wallet & Transactions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor700,
              ),
            ),
          ),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Wallet',
                subtitle: '\$${walletBalance.toStringAsFixed(2)}',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => WalletPage()));
                },
              ),
              _SettingsTile(
                icon: Icons.add_circle_outline,
                label: 'Deposit Funds',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.remove_circle_outline,
                label: 'Withdraw Funds',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.history_rounded,
                label: 'Wallet History',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.swap_horiz_rounded,
                label: 'Transaction History',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.pending_actions_rounded,
                label: 'Pending Transactions',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.gavel_rounded,
                label: 'Disputes/Resolutions',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
            ],
          ),

          // Account & Security Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 2),
            child: Text(
              'Account & Security',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor700,
              ),
            ),
          ),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.person,
                label: 'Account',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => AccountPage()));
                },
              ),
              _SettingsTile(
                icon: Icons.verified_user_rounded,
                label: 'KYC/Identity Verification',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.email_rounded,
                label: 'Change Email',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.phone_rounded,
                label: 'Change Phone Number',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.security_rounded,
                label: 'Two-Factor Authentication',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.shield_rounded,
                label: 'Security Center',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
            ],
          ),

          // Marketplace Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 2),
            child: Text(
              'Marketplace',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor700,
              ),
            ),
          ),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.list_alt_rounded,
                label: 'My Listings',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.bookmark_border_rounded,
                label: 'Saved/Bookmarked Items',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.star_border_rounded,
                label: 'My Reviews & Ratings',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.group_add_rounded,
                label: 'Invite Friends / Referral Program',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
            ],
          ),

          // Support & Legal Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 2),
            child: Text(
              'Support & Legal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor700,
              ),
            ),
          ),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.support_agent_rounded,
                label: 'Contact Support',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.help_outline,
                label: 'FAQs',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_rounded,
                label: 'Terms of Service',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_rounded,
                label: 'Privacy Policy',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.report_problem_rounded,
                label: 'Report a Problem',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
            ],
          ),

          // App Settings Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 2),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor700,
              ),
            ),
          ),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.brightness_6_rounded,
                label: 'Theme',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                label: 'Language',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                subtitle: 'v1.0.0',
                iconColor: AppColors.kprimaryColor500,
                onTap: () {},
              ),
            ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  ref.read(authProvider).logout();
                  context.push('/login');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: List.generate(
            children.length * 2 - 1,
            (i) => i.isEven
                ? children[i ~/ 2]
                : const Divider(
                    height: 0,
                    thickness: 0.7,
                    color: Color(0xFFE0E0E0),
                    indent: 16,
                    endIndent: 16,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color iconColor;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 20),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.kgrayColor100,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.kgrayColor100,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 0,
    );
  }
}
