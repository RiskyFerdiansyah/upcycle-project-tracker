import 'package:flutter/material.dart';

import '../models/project.dart';
import '../theme/app_theme.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.project,
    this.onTap,
    this.showStatus = false,
    this.onStatusChanged,
    super.key,
  });

  final Project project;
  final VoidCallback? onTap;
  final bool showStatus;
  final ValueChanged<String>? onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1,
      shadowColor: AppColors.primary.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 82,
                decoration: BoxDecoration(
                  color: project.iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(project.icon, color: AppColors.primary, size: 36),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      project.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: showStatus
                          ? [
                              _ProjectTag(
                                icon: _statusIcon(project.status),
                                label: project.status,
                              ),
                              _ProjectTag(
                                icon: Icons.eco_outlined,
                                label: project.difficulty,
                              ),
                            ]
                          : [
                              _ProjectTag(
                                icon: Icons.eco_outlined,
                                label: project.difficulty,
                              ),
                              _ProjectTag(
                                icon: Icons.schedule_rounded,
                                label: project.estimatedTime,
                              ),
                            ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              if (onStatusChanged == null)
                const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.secondary,
                  size: 20,
                )
              else
                PopupMenuButton<String>(
                  tooltip: 'Update project status',
                  onSelected: onStatusChanged,
                  itemBuilder: (context) => ProjectStatus.all
                      .map(
                        (status) => PopupMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  icon: const Icon(Icons.more_vert_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(String status) => switch (status) {
    ProjectStatus.completed => Icons.check_circle_outline_rounded,
    ProjectStatus.inProgress => Icons.autorenew_rounded,
    _ => Icons.radio_button_unchecked_rounded,
  };
}

class _ProjectTag extends StatelessWidget {
  const _ProjectTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
