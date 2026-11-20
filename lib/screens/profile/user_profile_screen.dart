import 'package:flutter/material.dart';

import '../../data/demo_account.dart';
import '../../data/sample_projects.dart';
import '../../models/project.dart';
import '../../theme/app_theme.dart';
import '../../widgets/project_card.dart';
import 'account_details_screen.dart';
import '../project/project_details_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: UserProfileContent(onLogout: onLogout),
    );
  }
}

class UserProfileContent extends StatefulWidget {
  const UserProfileContent({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  bool _emailUpdates = true;
  bool _projectReminders = false;

  Future<void> _openProject(Project project) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ProjectDetailsScreen(project: project),
      ),
    );
  }

  void _openAccountDetails() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const AccountDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: profileRevision,
      builder: (context, _, _) {
        final completedCount = myProjects
            .where((project) => project.status == ProjectStatus.completed)
            .length;
        final inProgressCount = myProjects
            .where((project) => project.status == ProjectStatus.inProgress)
            .length;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(),
                  const SizedBox(height: 20),
                  Text(
                    'Your activity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActivityCard(
                          count: '${myProjects.length}',
                          label: 'Projects',
                          icon: Icons.folder_open_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActivityCard(
                          count: '$inProgressCount',
                          label: 'In progress',
                          icon: Icons.autorenew_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActivityCard(
                          count: '$completedCount',
                          label: 'Completed',
                          icon: Icons.check_circle_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My contributions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        '${userContributions.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (userContributions.isEmpty)
                    const _EmptyContributionsCard()
                  else
                    ...userContributions.map(
                      (project) => ProjectCard(
                        key: ValueKey('contribution-${project.id}'),
                        project: project,
                        onTap: () => _openProject(project),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Text(
                    'Account settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          ListTile(
                            key: const ValueKey('profile-account-details'),
                            leading: const Icon(Icons.person_outline_rounded),
                            title: const Text('Account details'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: _openAccountDetails,
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          SwitchListTile.adaptive(
                            secondary: const Icon(Icons.email_outlined),
                            title: const Text('Email updates'),
                            value: _emailUpdates,
                            onChanged: (value) =>
                                setState(() => _emailUpdates = value),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          SwitchListTile.adaptive(
                            secondary: const Icon(Icons.notifications_outlined),
                            title: const Text('Project reminders'),
                            value: _projectReminders,
                            onChanged: (value) =>
                                setState(() => _projectReminders = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: widget.onLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log out'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = DemoAccountStore.instance;

    return ValueListenableBuilder<int>(
      valueListenable: account.revision,
      builder: (context, _, _) {
        final initials = account.name
            .trim()
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0].toUpperCase())
            .join();

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outline),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.mint,
                child: Text(
                  initials.isEmpty ? 'U' : initials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.role,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.verified_outlined, color: AppColors.secondary),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.count,
    required this.label,
    required this.icon,
  });

  final String count;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const SizedBox(height: 5),
          Text(count, style: Theme.of(context).textTheme.titleLarge),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EmptyContributionsCard extends StatelessWidget {
  const _EmptyContributionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.eco_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Projects you create will appear here.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
