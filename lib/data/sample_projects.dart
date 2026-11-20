import 'package:flutter/material.dart';

import '../models/project.dart';

final sampleProjects = <Project>[
  Project(
    id: 'tin-can-planter',
    title: 'Tin Can Planter',
    description: 'Turn a clean tin can into a cheerful home for small plants.',
    category: 'Garden',
    materials: ['Tin can', 'Potting mix', 'Small plant'],
    tools: ['Scissors', 'Paintbrush'],
    steps: [
      'Wash and dry the can, then remove its label.',
      'Ask an adult to make a few drainage holes in the base.',
      'Decorate the outside with paint or paper and let it dry.',
      'Add potting mix and a small plant.',
    ],
    difficulty: 'Easy',
    estimatedTime: '30 min',
    icon: Icons.local_florist_rounded,
    iconBackground: Color(0xFFE3F0E1),
    status: ProjectStatus.completed,
  ),
  Project(
    id: 'tshirt-tote-bag',
    title: 'T-shirt Tote Bag',
    description: 'Give an old T-shirt a second life as a reusable tote.',
    category: 'Fashion',
    materials: ['Old T-shirt', 'Scissors'],
    tools: ['Fabric marker', 'Ruler'],
    steps: [
      'Lay the T-shirt flat and smooth out the fabric.',
      'Cut off both sleeves and trim a wider opening at the neckline.',
      'Cut short strips along the bottom edge of the shirt.',
      'Tie matching front and back strips together to close the bag.',
    ],
    difficulty: 'Easy',
    estimatedTime: '20 min',
    icon: Icons.shopping_bag_outlined,
    iconBackground: Color(0xFFFCEBD9),
    status: ProjectStatus.inProgress,
  ),
  Project(
    id: 'cardboard-organizer',
    title: 'Cardboard Organizer',
    description: 'Make a tidy desk organiser from a sturdy cardboard box.',
    category: 'Storage',
    materials: ['Cardboard', 'Paper wrap', 'Glue'],
    tools: ['Scissors', 'Ruler', 'Pencil'],
    steps: [
      'Measure and trim the box to the height you want.',
      'Cut cardboard dividers to fit inside the box.',
      'Cover the outside and dividers with reused paper.',
      'Glue the dividers in place and leave the organiser to dry.',
    ],
    difficulty: 'Easy',
    estimatedTime: '45 min',
    icon: Icons.inventory_2_outlined,
    iconBackground: Color(0xFFECE7D9),
    status: ProjectStatus.notStarted,
  ),
  Project(
    id: 'glass-jar-lantern',
    title: 'Glass Jar Lantern',
    description: 'Decorate a spare jar to make a soft light for your room.',
    category: 'Decor',
    materials: ['Glass jar', 'Twine', 'LED candle'],
    tools: ['Scissors', 'Craft glue'],
    steps: [
      'Wash the jar and remove any labels.',
      'Wrap twine around the jar and secure the ends with craft glue.',
      'Let the glue dry completely.',
      'Place an LED candle inside the jar.',
    ],
    difficulty: 'Medium',
    estimatedTime: '40 min',
    icon: Icons.light_mode_outlined,
    iconBackground: Color(0xFFFFF1CF),
  ),
  Project(
    id: 'bottle-watering-spike',
    title: 'Bottle Watering Spike',
    description: 'Reuse a plastic bottle to help water a small potted plant.',
    category: 'Garden',
    materials: ['Plastic bottle', 'Cotton cord', 'Potting mix'],
    tools: ['Scissors', 'Awl'],
    steps: [
      'Clean the bottle and remove its label.',
      'Ask an adult to make a small hole in the bottle cap.',
      'Thread cotton cord through the cap and fill the bottle with water.',
      'Place the bottle near a potted plant so the cord can feed water slowly.',
    ],
    difficulty: 'Easy',
    estimatedTime: '25 min',
    icon: Icons.water_drop_outlined,
    iconBackground: Color(0xFFDDEEF1),
  ),
];

final myProjects = <Project>[
  sampleProjects[0],
  sampleProjects[1],
  sampleProjects[2],
];
final personalProjects = <Project>[];
final userContributions = <Project>[];
final ValueNotifier<int> sampleProjectsRevision = ValueNotifier(0);
final ValueNotifier<int> myProjectsRevision = ValueNotifier(0);
final ValueNotifier<int> profileRevision = ValueNotifier(0);

void saveProject(Project project) {
  _saveToList(sampleProjects, project);
  sampleProjectsRevision.value++;
}

void saveMyProject(Project project) {
  _saveToList(myProjects, project);
  myProjectsRevision.value++;
  profileRevision.value++;
}

void saveContribution(Project project) {
  _saveToList(userContributions, project);
  profileRevision.value++;
}

void savePersonalProject(Project project) {
  _saveToList(personalProjects, project);
}

void updateExistingProject(Project project) {
  if (sampleProjects.any((item) => item.id == project.id)) {
    saveProject(project);
  }
  if (myProjects.any((item) => item.id == project.id)) {
    saveMyProject(project);
  }
  if (personalProjects.any((item) => item.id == project.id)) {
    savePersonalProject(project);
  }
  if (userContributions.any((item) => item.id == project.id)) {
    saveContribution(project);
  }
}

void updateProjectStatus(Project project, String status) {
  final updatedProject = project.withStatus(status);
  if (sampleProjects.any((item) => item.id == project.id)) {
    saveProject(updatedProject);
  }
  if (personalProjects.any((item) => item.id == project.id)) {
    savePersonalProject(updatedProject);
  }
  saveMyProject(updatedProject);
  if (userContributions.any((item) => item.id == project.id)) {
    saveContribution(updatedProject);
  }
}

void _saveToList(List<Project> projects, Project project) {
  final existingIndex = projects.indexWhere((item) => item.id == project.id);
  if (existingIndex == -1) {
    projects.insert(0, project);
  } else {
    projects[existingIndex] = project;
  }
}
