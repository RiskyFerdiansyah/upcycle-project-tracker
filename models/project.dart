import 'package:flutter/material.dart';

abstract final class ProjectStatus {
  static const notStarted = 'Not Started';
  static const inProgress = 'In Progress';
  static const completed = 'Completed';

  static const all = [notStarted, inProgress, completed];
}

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.materials,
    required this.tools,
    required this.steps,
    required this.difficulty,
    required this.estimatedTime,
    required this.icon,
    required this.iconBackground,
    this.status = ProjectStatus.notStarted,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> materials;
  final List<String> tools;
  final List<String> steps;
  final String difficulty;
  final String estimatedTime;
  final IconData icon;
  final Color iconBackground;
  final String status;

  Project withStatus(String value) => Project(
    id: id,
    title: title,
    description: description,
    category: category,
    materials: materials,
    tools: tools,
    steps: steps,
    difficulty: difficulty,
    estimatedTime: estimatedTime,
    icon: icon,
    iconBackground: iconBackground,
    status: value,
  );
}
