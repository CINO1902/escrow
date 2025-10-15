import 'package:flutter/material.dart';
import '../../../../core/utils/appColor.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool locationServices = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.kprimaryColor500,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        children: [
          const _SettingsSectionHeader('Account'),
          _SettingsTile(
            icon: Icons.person_rounded,
            label: 'Personal Information',
            color: AppColors.kprimaryColor500,
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.shield_rounded,
            label: 'Security',
            subtitle: 'Password, Face ID, 2FA',
            color: AppColors.kprimaryColor700,
            onTap: () {},
          ),
          const SizedBox(height: 18),
          const _SettingsSectionHeader('Notifications'),
          _SettingsSwitchTile(
            icon: Icons.notifications_rounded,
            label: 'Push Notifications',
            subtitle: 'Receive alerts and reminders',
            color: AppColors.kprimaryColor500,
            value: pushNotifications,
            onChanged: (val) => setState(() => pushNotifications = val),
          ),
          _SettingsSwitchTile(
            icon: Icons.email_rounded,
            label: 'Email Notifications',
            subtitle: 'Receive updates via email',
            color: AppColors.kprimaryColor700,
            value: emailNotifications,
            onChanged: (val) => setState(() => emailNotifications = val),
          ),
          const SizedBox(height: 18),
          const _SettingsSectionHeader('Privacy'),
          _SettingsTile(
            icon: Icons.privacy_tip_rounded,
            label: 'Privacy Settings',
            subtitle: 'Manage your data and privacy preferences',
            color: AppColors.kprimaryColor700,
            onTap: () {},
          ),
          _SettingsSwitchTile(
            icon: Icons.location_on_rounded,
            label: 'Location Services',
            subtitle: 'Allow access to your location',
            color: AppColors.kprimaryColor500,
            value: locationServices,
            onChanged: (val) => setState(() => locationServices = val),
          ),
          const SizedBox(height: 18),
          const _SettingsSectionHeader('Appearance'),
          _SettingsTile(
            icon: Icons.palette_rounded,
            label: 'Theme',
            subtitle: 'Light theme',
            color: AppColors.kprimaryColor300,
            onTap: () {},
            trailing: const Icon(
              Icons.brightness_5_rounded,
              color: AppColors.kprimaryColor300,
            ),
          ),

          const _SettingsSectionHeader('Support'),
          _SettingsTile(
            icon: Icons.help_center_rounded,
            label: 'Help Center',
            color: AppColors.kprimaryColor500,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.feedback_rounded,
            label: 'Send Feedback',
            color: AppColors.kprimaryColor700,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: 'About',
            subtitle: 'v1.0.0',
            color: AppColors.kprimaryColor300,
            onTap: () {},
            trailing: null,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                // TODO: Handle logout
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;
  const _SettingsSectionHeader(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.kprimaryColor500,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;
  const _SettingsTile({
    Key? key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.color,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.13),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kBlack,
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              subtitle!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.kgrayColor100,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing ??
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: AppColors.kgrayColor100,
                      ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 0.7,
                color: Color(0xFFF0F1F3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitchTile({
    Key? key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kBlack,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.kgrayColor100,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.kprimaryColor500,
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.7, color: Color(0xFFF0F1F3)),
          ],
        ),
      ),
    );
  }
}
