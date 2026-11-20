import 'package:flutter/material.dart';

import '../../data/sample_projects.dart';
import '../../models/project.dart';
import '../../theme/app_theme.dart';
import '../../widgets/floating_pill_navigation_bar.dart';
import '../../widgets/project_card.dart';
import '../gallery/community_gallery_screen.dart';
import '../my_projects/my_projects_screen.dart';
import '../profile/user_profile_screen.dart';
import '../project/create_edit_project_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  void _openGallery() => setState(() => _selectedIndex = 1);

  Future<void> _createProject() async {
    final project = await Navigator.push<Project>(
      context,
      MaterialPageRoute<Project>(
        builder: (_) => const CreateEditProjectScreen(),
      ),
    );

    if (project == null || !mounted) return;

    saveProject(project);
    saveMyProject(project);
    saveContribution(project);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project added to the community gallery.')),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can sign in again at any time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['Upcycle', 'Community Gallery', 'My Projects', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.recycling_rounded, size: 23),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titles[_selectedIndex],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: _selectedIndex == 3
            ? null
            : [
                IconButton(
                  onPressed: _createProject,
                  tooltip: 'Create project',
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeDashboardContent(onExplore: _openGallery),
          const CommunityGalleryContent(),
          const MyProjectsContent(),
          UserProfileContent(onLogout: _confirmLogout),
        ],
      ),
      bottomNavigationBar: FloatingPillNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
      ),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final featuredProjects = sampleProjects.take(3).toList();
    final completedCount = myProjects
        .where((project) => project.status == ProjectStatus.completed)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, creator 👋',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'What will you make today?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              _InspirationBanner(onExplore: onExplore),
              const SizedBox(height: 20),
              Text(
                'Your progress',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ProgressCard(
                      icon: Icons.lightbulb_outline_rounded,
                      count: '${myProjects.length}',
                      label: 'Projects tracked',
                      color: AppColors.mint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProgressCard(
                      icon: Icons.check_circle_outline_rounded,
                      count: '$completedCount',
                      label: 'Completed',
                      color: const Color(0xFFFFF0D9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Featured projects',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: onExplore,
                    child: const Text('See all'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProjects.length,
                  itemBuilder: (context, index) => SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProjectCard(project: featuredProjects[index]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _SustainabilityNote(onExplore: onExplore),
            ],
          ),
        ),
      ),
    );
  }
}

class _InspirationBanner extends StatelessWidget {
  const _InspirationBanner({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF367451)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Give old things a new life',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find a simple project and start creating.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onExplore,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  icon: const Icon(Icons.explore_outlined, size: 18),
                  label: const Text('Explore ideas'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFFDDEBDD),
              size: 42,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 23),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SustainabilityNote extends StatelessWidget {
  const _SustainabilityNote({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.public_rounded, color: AppColors.primary, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Small acts of reuse support responsible consumption.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
            ),
          ),
          IconButton(
            onPressed: onExplore,
            tooltip: 'Explore projects',
            color: AppColors.primary,
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}
