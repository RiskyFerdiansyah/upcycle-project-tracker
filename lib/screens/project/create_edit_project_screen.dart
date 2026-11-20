import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../theme/app_theme.dart';

class CreateEditProjectScreen extends StatefulWidget {
  const CreateEditProjectScreen({
    this.project,
    this.isRecreation = false,
    super.key,
  });

  final Project? project;
  final bool isRecreation;

  bool get isEditing => project != null && !isRecreation;

  @override
  State<CreateEditProjectScreen> createState() =>
      _CreateEditProjectScreenState();
}

class _CreateEditProjectScreenState extends State<CreateEditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _materialsController;
  late final TextEditingController _toolsController;
  late final TextEditingController _stepsController;
  late final TextEditingController _timeController;
  String _selectedDifficulty = 'Easy';

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _titleController = TextEditingController(
      text: project == null
          ? ''
          : widget.isRecreation
          ? 'My version of ${project.title}'
          : project.title,
    );
    _descriptionController = TextEditingController(
      text: project?.description ?? '',
    );
    _materialsController = TextEditingController(
      text: project?.materials.join(', ') ?? '',
    );
    _toolsController = TextEditingController(
      text: project?.tools.join(', ') ?? '',
    );
    _stepsController = TextEditingController(
      text: project?.steps.join('\n') ?? '',
    );
    _timeController = TextEditingController(text: project?.estimatedTime ?? '');
    _selectedDifficulty = project?.difficulty ?? 'Easy';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _materialsController.dispose();
    _toolsController.dispose();
    _stepsController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  List<String> _splitItems(String value) => value
      .split(RegExp(r'[,;\n]'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  void _showImageMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image selection will be available in a later stage.'),
      ),
    );
  }

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;

    final original = widget.project;
    final project = Project(
      id: widget.isEditing
          ? original!.id
          : 'project-${DateTime.now().microsecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: original?.category ?? 'Other',
      materials: _splitItems(_materialsController.text),
      tools: _splitItems(_toolsController.text),
      steps: _stepsController.text
          .split('\n')
          .map((step) => step.trim())
          .where((step) => step.isNotEmpty)
          .toList(),
      difficulty: _selectedDifficulty,
      status: widget.isRecreation
          ? ProjectStatus.notStarted
          : original?.status ?? ProjectStatus.notStarted,
      estimatedTime: _timeController.text.trim().isEmpty
          ? original?.estimatedTime ?? 'Not set'
          : _timeController.text.trim(),
      icon: original?.icon ?? Icons.recycling_rounded,
      iconBackground: original?.iconBackground ?? AppColors.mint,
    );

    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = widget.isEditing
        ? 'Edit project'
        : widget.isRecreation
        ? 'Recreate project'
        : 'Create project';

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.isRecreation
                                ? 'Make it your own'
                                : 'Share a new idea',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.isRecreation
                                ? 'Adjust the details for your version of this project.'
                                : 'Add the details people need to make your upcycling project.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 18),
                          _ProjectImagePlaceholder(onTap: _showImageMessage),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _titleController,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Project title',
                              hintText: 'e.g. Tin Can Planter',
                              prefixIcon: Icon(Icons.title_rounded),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter a project title.';
                              }
                              if (value.trim().length < 3) {
                                return 'Use at least 3 characters.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _descriptionController,
                            minLines: 3,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'Briefly describe what you will make.',
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Add a short project description.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _materialsController,
                            minLines: 2,
                            maxLines: 4,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Materials',
                              hintText: 'Separate items with commas',
                              prefixIcon: Icon(Icons.inventory_2_outlined),
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (_splitItems(value ?? '').isEmpty) {
                                return 'Add at least one material.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _toolsController,
                            minLines: 1,
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Tools (optional)',
                              hintText: 'e.g. Scissors, ruler',
                              prefixIcon: Icon(Icons.handyman_outlined),
                            ),
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDifficulty,
                            decoration: const InputDecoration(
                              labelText: 'Difficulty',
                              prefixIcon: Icon(Icons.speed_rounded),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Easy',
                                child: Text('Easy'),
                              ),
                              DropdownMenuItem(
                                value: 'Medium',
                                child: Text('Medium'),
                              ),
                              DropdownMenuItem(
                                value: 'Hard',
                                child: Text('Hard'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedDifficulty = value);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _timeController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Estimated time (optional)',
                              hintText: 'e.g. 30 min',
                              prefixIcon: Icon(Icons.schedule_rounded),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _stepsController,
                            minLines: 3,
                            maxLines: 8,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Instructions (optional)',
                              hintText: 'Write one step per line',
                              prefixIcon: Icon(Icons.format_list_numbered),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveProject,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        widget.isEditing
                            ? 'Save changes'
                            : widget.isRecreation
                            ? 'Save recreation'
                            : 'Save project',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectImagePlaceholder extends StatelessWidget {
  const _ProjectImagePlaceholder({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 154,
        decoration: BoxDecoration(
          color: AppColors.mint.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a project image',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 2),
            Text(
              'Tap to choose a photo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
