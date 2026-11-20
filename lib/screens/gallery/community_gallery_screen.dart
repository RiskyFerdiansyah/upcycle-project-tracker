import 'package:flutter/material.dart';

import '../../data/sample_projects.dart';
import '../../models/project.dart';
import '../../theme/app_theme.dart';
import '../../widgets/project_card.dart';
import '../project/project_details_screen.dart';

class CommunityGalleryScreen extends StatelessWidget {
  const CommunityGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Gallery'),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: const CommunityGalleryContent(),
    );
  }
}

class CommunityGalleryContent extends StatefulWidget {
  const CommunityGalleryContent({super.key});

  @override
  State<CommunityGalleryContent> createState() =>
      _CommunityGalleryContentState();
}

class _CommunityGalleryContentState extends State<CommunityGalleryContent> {
  static const _categories = [
    'All',
    'Garden',
    'Fashion',
    'Storage',
    'Decor',
    'Other',
  ];

  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Project> get _filteredProjects {
    final query = _searchQuery.trim().toLowerCase();

    return sampleProjects.where((project) {
      final matchesCategory =
          _selectedCategory == 'All' || project.category == _selectedCategory;
      final searchableText =
          '${project.title} ${project.description} ${project.materials.join(' ')}'
              .toLowerCase();
      final matchesSearch = query.isEmpty || searchableText.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openProject(Project project) async {
    final wasUpdated = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ProjectDetailsScreen(project: project),
      ),
    );

    if (wasUpdated == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: sampleProjectsRevision,
      builder: (context, _, _) {
        final projects = _filteredProjects;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search projects or materials',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final selected = category == _selectedCategory;

                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      showCheckmark: false,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: selected ? AppColors.primary : AppColors.outline,
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
                      'Ideas to make and share',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    '${projects.length} projects',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.mutedText),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: projects.isEmpty
                    ? const _EmptyGalleryState()
                    : ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(top: 2, bottom: 8),
                        itemCount: projects.length,
                        itemBuilder: (context, index) => ProjectCard(
                          project: projects[index],
                          onTap: () => _openProject(projects[index]),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyGalleryState extends StatelessWidget {
  const _EmptyGalleryState();

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
                Icons.search_off_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No projects found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Try another search or choose a different category.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
