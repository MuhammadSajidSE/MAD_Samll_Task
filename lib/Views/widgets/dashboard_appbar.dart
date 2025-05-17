import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
                      ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Jayvie',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '19‑02031‑t',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        SvgPicture.asset(
          'assets/icons/checklist.svg',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 16),
        SvgPicture.asset(
          'assets/icons/chat.svg',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 16),
        SvgPicture.asset(
          'assets/icons/notification.svg',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
