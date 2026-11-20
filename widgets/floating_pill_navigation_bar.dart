import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FloatingPillNavigationBar extends StatelessWidget {
  const FloatingPillNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _destinations = [
    (label: 'Home', icon: Icons.home_outlined, selected: Icons.home_rounded),
    (
      label: 'Explore',
      icon: Icons.search_rounded,
      selected: Icons.explore_rounded,
    ),
    (
      label: 'My Projects',
      icon: Icons.folder_open_outlined,
      selected: Icons.folder_rounded,
    ),
    (
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selected: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      child: SizedBox(
        height: 82,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Container(
              height: 72,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: AppColors.outline),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_destinations.length, (index) {
                  final destination = _destinations[index];
                  final selected = index == selectedIndex;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Material(
                        color: selected ? AppColors.mint : Colors.transparent,
                        borderRadius: BorderRadius.circular(28),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => onDestinationSelected(index),
                          child: SizedBox.expand(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  selected
                                      ? destination.selected
                                      : destination.icon,
                                  size: 21,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.mutedText,
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    destination.label,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: selected
                                              ? AppColors.primary
                                              : AppColors.mutedText,
                                          fontWeight: selected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
