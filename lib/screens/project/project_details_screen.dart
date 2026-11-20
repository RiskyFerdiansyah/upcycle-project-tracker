import 'package:flutter/material.dart';

import '../../data/sample_projects.dart';
import '../../models/project.dart';
import '../../theme/app_theme.dart';
import '../../widgets/project_artwork.dart';
import 'create_edit_project_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({required this.project, super.key});

  final Project project;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Project _project = widget.project;
  bool _hasChanges = false;

  Future<void> _editProject() async {
    final updatedProject = await Navigator.push<Project>(
      context,
      MaterialPageRoute<Project>(
        builder: (_) => CreateEditProjectScreen(project: _project),
      ),
    );

    if (updatedProject == null || !mounted) return;

    updateExistingProject(updatedProject);
    setState(() {
      _project = updatedProject;
      _hasChanges = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Project details updated.')));
  }

  Future<void> _recreateProject() async {
    final recreatedProject = await Navigator.push<Project>(
      context,
      MaterialPageRoute<Project>(
        builder: (_) =>
            CreateEditProjectScreen(project: _project, isRecreation: true),
      ),
    );

    if (recreatedProject == null || !mounted) return;

    savePersonalProject(recreatedProject);
    saveMyProject(recreatedProject);
    setState(() => _hasChanges = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your recreation draft is ready.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project tutorial'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _hasChanges),
          tooltip: 'Back to gallery',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            onPressed: _editProject,
            tooltip: 'Edit project',
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectArtwork(project: _project, height: 230),
                  const SizedBox(height: 20),
                  Text(
                    _project.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _DetailsTag(
                        icon: Icons.eco_outlined,
                        label: _project.difficulty,
                      ),
                      _DetailsTag(
                        icon: Icons.schedule_rounded,
                        label: _project.estimatedTime,
                      ),
                      _DetailsTag(
                        icon: Icons.grid_view_rounded,
                        label: _project.category,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SectionHeading(title: 'About this project'),
                  const SizedBox(height: 8),
                  Text(
                    _project.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 22),
                  _SectionHeading(title: 'Materials'),
                  const SizedBox(height: 10),
                  _ItemChips(
                    items: _project.materials,
                    emptyMessage: 'Materials have not been added yet.',
                  ),
                  const SizedBox(height: 20),
                  _SectionHeading(title: 'Tools'),
                  const SizedBox(height: 10),
                  _ItemChips(
                    items: _project.tools,
                    emptyMessage: 'No tools listed for this project.',
                  ),
                  const SizedBox(height: 22),
                  _SectionHeading(title: 'Step-by-step instructions'),
                  const SizedBox(height: 12),
                  if (_project.steps.isEmpty)
                    Text(
                      'Instructions have not been added yet.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    ..._project.steps.indexed.map(
                      (entry) => _InstructionStep(
                        number: entry.$1 + 1,
                        instruction: entry.$2,
                      ),
                    ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _recreateProject,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Recreate project'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _DetailsTag extends StatelessWidget {
  const _DetailsTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemChips extends StatelessWidget {
  const _ItemChips({required this.items, required this.emptyMessage});

  final List<String> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Chip(
              label: Text(item),
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.outline),
              labelStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
            ),
          )
          .toList(),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({required this.number, required this.instruction});

  final int number;
  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                instruction,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
