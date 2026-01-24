import 'package:flutter/material.dart';
import 'icon_container.dart';

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool trailingSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const SettingsRow({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailingSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: trailingSwitch ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            IconContainer(icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(subtitle!, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    ),
                ],
              ),
            ),
            if (trailingSwitch)
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged ?? (_) {},
                activeColor: const Color(0xFF2F80ED),
              )
            else ...[
              if (subtitle == null) const SizedBox.shrink(),
              const Icon(Icons.chevron_left, color: Colors.white30),
            ],
          ],
        ),
      ),
    );
  }
}

