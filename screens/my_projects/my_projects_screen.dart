import 'package:flutter/material.dart';

import '../../data/sample_projects.dart';
import '../../models/project.dart';
import '../../theme/app_theme.dart';
import '../../widgets/project_card.dart';
import '../project/project_details_screen.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: const MyProjectsContent(),
    );
  }
}

class MyProjectsContent extends StatefulWidget {
  const MyProjectsContent({super.key});

  @override
  State<MyProjectsContent> createState() => _MyProjectsContentState();
}

class _MyProjectsContentState extends State<MyProjectsContent> {
  static const _filters = ['All', ...ProjectStatus.all];
  String _selectedFilter = 'All';

  List<Project> _projectsForFilter() {
    if (_selectedFilter == 'All') return List.of(myProjects);
    return myProjects
        .where((project) => project.status == _selectedFilter)
        .toList();
  }

  Future<void> _openProject(Project project) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ProjectDetailsScreen(project: project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: myProjectsRevision,
      builder: (context, _, _) {
        final projects = _projectsForFilter();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep your upcycling ideas moving.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final selected = filter == _selectedFilter;

                        return ChoiceChip(
                          label: Text(filter),
                          selected: selected,
                          showCheckmark: false,
                          onSelected: (_) =>
                              setState(() => _selectedFilter = filter),
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : AppColors.outline,
                          ),
                          labelStyle: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: selected ? Colors.white : AppColors.text,
                              ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedFilter == 'All'
                              ? 'All your projects'
                              : _selectedFilter,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        '${projects.length} projects',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: projects.isEmpty
                        ? _EmptyProjectsState(filter: _selectedFilter)
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 2, bottom: 8),
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              final project = projects[index];
                              return ProjectCard(
                                key: ValueKey(project.id),
                                project: project,
                                showStatus: true,
                                onTap: () => _openProject(project),
                                onStatusChanged: (status) =>
                                    updateProjectStatus(project, status),
                              );
                            },
                          ),
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

class _EmptyProjectsState extends StatelessWidget {
  const _EmptyProjectsState({required this.filter});

  final String filter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              filter == 'All' ? 'No projects yet' : 'No $filter projects',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Create a project or recreate an idea from the gallery to see it here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
