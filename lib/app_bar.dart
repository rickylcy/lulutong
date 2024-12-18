import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onEditJobs;
  final VoidCallback onViewJobs;
  final VoidCallback onOptimizeRoute;
  final VoidCallback onProfile;

  const AppBarComponent({
    super.key,
    required this.title,
    required this.onEditJobs,
    required this.onViewJobs,
    required this.onOptimizeRoute,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.local_shipping),
          const SizedBox(width: 10),
          Expanded(
            child: AutoSizeText(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: "Edit Jobs",
          onPressed: onEditJobs,
        ),
        IconButton(
          icon: const Icon(Icons.visibility),
          tooltip: "View Jobs",
          onPressed: onViewJobs,
        ),
        IconButton(
          icon: const Icon(Icons.route),
          tooltip: "Optimize Route",
          onPressed: onOptimizeRoute,
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: "Profile",
          onPressed: onProfile,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
