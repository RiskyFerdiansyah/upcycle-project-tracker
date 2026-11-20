import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dart_application/main.dart';
import 'package:dart_application/screens/home/home_dashboard.dart';
import 'package:dart_application/theme/app_theme.dart';
import 'package:dart_application/widgets/project_card.dart';

Widget _dashboardApp() =>
    MaterialApp(theme: AppTheme.light, home: const HomeDashboard());

Future<void> _pumpUpcycleApp(WidgetTester tester) async {
  await tester.pumpWidget(const UpcycleApp());
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pumpAndSettle();
}

Finder _formEditor(int index) => find.descendant(
  of: find.byType(TextFormField).at(index),
  matching: find.byType(EditableText),
);

void main() {
  testWidgets('splash shows the brand and transitions to onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(const UpcycleApp());

    expect(find.text('Upcycle Project Tracker'), findsOneWidget);
    expect(find.byIcon(Icons.recycling_rounded), findsOneWidget);
    expect(find.text('Create less waste.\nMake more wonder.'), findsNothing);

    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    expect(find.text('Create less waste.\nMake more wonder.'), findsOneWidget);
  });

  testWidgets('onboarding Next and Get Started reach login', (tester) async {
    await _pumpUpcycleApp(tester);

    expect(find.text('Create less waste.\nMake more wonder.'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Discover creative ideas'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Small changes, shared together'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.byTooltip('Back to introduction'));
    await tester.pumpAndSettle();
    expect(find.text('Small changes, shared together'), findsOneWidget);
  });

  testWidgets('login form displays validation messages', (tester) async {
    await _pumpUpcycleApp(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(_formEditor(0), 'not-an-email');
    await tester.enterText(_formEditor(1), 'short');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Use at least 6 characters.'), findsOneWidget);
  });

  testWidgets('default demo credentials are displayed and authenticate', (
    tester,
  ) async {
    await _pumpUpcycleApp(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Email: demo@upcycle.app'), findsOneWidget);
    expect(find.text('Password: upcycle123'), findsOneWidget);
    await tester.tap(find.text('Use demo account'));
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, creator 👋'), findsOneWidget);
  });

  testWidgets('registration validates details and opens the dashboard', (
    tester,
  ) async {
    await _pumpUpcycleApp(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('New here? Create an account'));
    await tester.tap(find.text('New here? Create an account'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Create account'),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name.'), findsOneWidget);
    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Use at least 6 characters.'), findsOneWidget);
    expect(find.text('Confirm your password.'), findsOneWidget);
    expect(
      find.text('Please accept the Terms and Conditions.'),
      findsOneWidget,
    );

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Demo User');
    await tester.enterText(fields.at(1), 'demo@example.com');
    await tester.enterText(fields.at(2), 'secret123');
    await tester.enterText(fields.at(3), 'different123');
    await tester.tap(find.text('I agree to the Terms and Conditions'));
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Create account'),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match.'), findsOneWidget);

    await tester.enterText(fields.at(3), 'secret123');
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Create account'),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, creator 👋'), findsOneWidget);
  });

  testWidgets('gallery opens a tutorial and a recreation draft', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tin Can Planter'));
    await tester.pumpAndSettle();

    expect(find.text('Project tutorial'), findsOneWidget);
    expect(find.text('Materials'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Step-by-step instructions'), findsOneWidget);

    await tester.ensureVisible(find.text('Recreate project'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recreate project'));
    await tester.pumpAndSettle();

    expect(find.text('My version of Tin Can Planter'), findsOneWidget);
    await tester.tap(find.text('Save recreation'));
    await tester.pumpAndSettle();

    expect(find.text('Your recreation draft is ready.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back to gallery'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Projects'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My version of Tin Can Planter'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit project'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(EditableText).first,
      'Personal planter draft',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back to gallery'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Personal planter draft',
    );
    await tester.pumpAndSettle();
    expect(find.text('No projects found'), findsOneWidget);
    await tester.tap(find.text('My Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Personal planter draft'), findsOneWidget);
  });

  testWidgets('create project validates and adds it to the gallery', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());

    await tester.tap(find.byTooltip('Create project'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add a project image'));
    await tester.pumpAndSettle();
    expect(
      find.text('Image selection will be available in a later stage.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save project'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a project title.'), findsOneWidget);
    expect(find.text('Add a short project description.'), findsOneWidget);
    expect(find.text('Add at least one material.'), findsOneWidget);

    final titleField = find.byType(EditableText).at(0);
    final descriptionField = find.byType(EditableText).at(1);
    final materialsField = find.byType(EditableText).at(2);
    await tester.ensureVisible(titleField);
    await tester.enterText(titleField, 'Magazine Desk Tray');
    await tester.ensureVisible(descriptionField);
    await tester.enterText(
      descriptionField,
      'A useful tray made from reused paper and cardboard.',
    );
    await tester.ensureVisible(materialsField);
    await tester.enterText(materialsField, 'Cardboard, magazine pages, glue');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save project'));
    await tester.pumpAndSettle();

    expect(
      find.text('Project added to the community gallery.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Magazine Desk Tray'), findsOneWidget);

    await tester.tap(find.text('My Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Magazine Desk Tray'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Magazine Desk Tray'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('project details can open and save the edit form', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tin Can Planter'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit project'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(EditableText).first,
      'Tin Can Planter Updated',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Tin Can Planter Updated'), findsOneWidget);
    expect(find.text('Project details updated.'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to gallery'));
    await tester.pumpAndSettle();
    expect(find.text('Tin Can Planter Updated'), findsOneWidget);

    await tester.tap(find.text('My Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Tin Can Planter Updated'), findsOneWidget);
  });

  testWidgets('My Projects filters statuses and opens project details', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());
    await tester.tap(find.text('My Projects'));
    await tester.pumpAndSettle();

    expect(find.text('All your projects'), findsOneWidget);
    expect(find.byTooltip('Update project status'), findsWidgets);

    await tester.tap(find.byTooltip('Update project status').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuItem<String>).at(1));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'In Progress'));
    await tester.pumpAndSettle();
    expect(find.text('In Progress'), findsWidgets);
    expect(find.text('2 projects'), findsOneWidget);

    await tester.tap(find.byType(ProjectCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Project tutorial'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to gallery'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Your activity'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('gallery search and category filters update the results', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Potting mix');
    await tester.pumpAndSettle();
    expect(find.text('2 projects'), findsOneWidget);
    expect(find.text('Tin Can Planter Updated'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Decor'));
    await tester.pumpAndSettle();
    expect(find.text('No projects found'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Glass Jar Lantern'), findsOneWidget);
    expect(find.text('1 projects'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Other'));
    await tester.pumpAndSettle();
    expect(find.text('Magazine Desk Tray'), findsOneWidget);
  });

  testWidgets('profile account details, preferences and logout cancel work', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Your activity'), findsOneWidget);

    final accountDetailsTile = find.byKey(
      const ValueKey('profile-account-details'),
    );
    await tester.scrollUntilVisible(accountDetailsTile, 120);
    await tester.tap(accountDetailsTile);
    await tester.pumpAndSettle();
    expect(find.text('Account role'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to profile'));
    await tester.pumpAndSettle();

    final emailSwitch = find.byType(SwitchListTile).first;
    await tester.ensureVisible(emailSwitch);
    await tester.tap(emailSwitch);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(emailSwitch).value, isFalse);

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Demo User'), findsWidgets);
  });

  testWidgets('core screens build without overflow at phone and tablet sizes', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(320, 568), const Size(1280, 800)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;

      await _pumpUpcycleApp(tester);
      expect(tester.takeException(), isNull, reason: 'onboarding at $size');
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'login at $size');

      await tester.ensureVisible(find.text('New here? Create an account'));
      await tester.tap(find.text('New here? Create an account'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'register at $size');

      await tester.pumpWidget(_dashboardApp());
      expect(tester.takeException(), isNull, reason: 'dashboard at $size');
      await tester.tap(find.byTooltip('Create project'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'create form at $size');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      for (final destination in ['Explore', 'My Projects', 'Profile', 'Home']) {
        await tester.tap(find.text(destination));
        await tester.pumpAndSettle();
        expect(
          find.text(switch (destination) {
            'Explore' => 'Ideas to make and share',
            'My Projects' => 'Keep your upcycling ideas moving.',
            'Profile' => 'Your activity',
            _ => 'Hello, creator 👋',
          }),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull, reason: '$destination at $size');
      }

      await tester.tap(find.text('Explore'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ProjectCard).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'details at $size');
      await tester.tap(find.byTooltip('Edit project'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'edit form at $size');
    }
  });

  testWidgets('Profile shows account information and logs out to onboarding', (
    tester,
  ) async {
    await _pumpUpcycleApp(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Use demo account'));
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Demo User'), findsOneWidget);
    expect(find.text('Your activity'), findsOneWidget);
    expect(find.text('My contributions'), findsOneWidget);
    expect(find.text('Account settings'), findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Create less waste.\nMake more wonder.'), findsOneWidget);
  });

  testWidgets('account details edit profile and delete back to login', (
    tester,
  ) async {
    await tester.pumpWidget(_dashboardApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    final accountDetailsTile = find.byKey(
      const ValueKey('profile-account-details'),
    );
    await tester.scrollUntilVisible(accountDetailsTile, 120);
    await tester.tap(accountDetailsTile);
    await tester.pumpAndSettle();

    expect(find.text('Account details'), findsOneWidget);
    expect(find.text('Demo User'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Community Creator'), findsOneWidget);

    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Mira Tan');
    await tester.enterText(find.byType(EditableText).at(1), 'mira@example.com');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile details saved.'), findsOneWidget);
    expect(find.text('Mira Tan'), findsWidgets);
    expect(find.text('mira@example.com'), findsOneWidget);

    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    expect(find.text('Delete account?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Account details'), findsOneWidget);

    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete account'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      find.text('Your account was deleted. Register to create a new one.'),
      findsOneWidget,
    );
  });
}
