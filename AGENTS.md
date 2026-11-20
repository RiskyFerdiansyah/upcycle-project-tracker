# AGENTS.md — Upcycle Project Tracker

## 1. Role
Act as the lead Flutter developer for the Upcycle Project Tracker. Work collaboratively with the user, explain important changes clearly, and keep the implementation suitable for a student PMD practical project.

## 2. Project purpose
Upcycle Project Tracker is an open educational and community-based upcycling platform supporting UN Sustainable Development Goal 12 (Responsible Consumption and Production).

The platform brings together:
- An educational environment for teachers/lecturers and students.
- A public community environment for people to discover, create, share, and recreate upcycling projects.
- A shared Community Gallery connecting public and educational projects.

## 3. Technology and current scope
- Flutter and Dart.
- Material UI components / Material 3.
- For PMD Practical 1, use hard-coded sample data in Dart lists.
- Do not add database or backend integration at this stage.
- Keep the code readable and explainable by beginner-level Flutter students.
- Do not assume that Machine Learning must run inside the Flutter app.

## 4. Design system
Use this visual direction consistently unless the user approves a change:
- Forest Green (primary): `#245C43`
- Sage Green (secondary): `#6D9B75`
- Mint (surface): `#DDEBDD`
- Off White (background): `#F7F7F0`
- Warm Orange (accent): `#E8A95B`

Design characteristics:
- Modern, clean, minimal and friendly.
- Rounded cards and controls.
- Subtle shadows and clear spacing.
- Consistent typography and icon style.
- Responsive layouts for different mobile screen sizes.
- Prioritise accessibility, readability and simple navigation.

## 5. Planned screens
The agreed initial screen plan is:
1. Onboarding (2–3 intro pages).
2. Login.
3. Register.
4. Home Dashboard.
5. Community Project Gallery (main feature; scrolling list).
6. Project Details and Tutorial.
7. Create / Edit Project (form).
8. My Projects / personal progress tracking.
9. User Profile.

The five mandatory PMD Practical 1 screen categories must be covered: Onboarding; Login and Register; Dashboard; Main Feature Screen; Create/Edit Screen. Additional screens support the wider project concept.

## 6. Navigation direction
After authentication, use a simple bottom navigation structure:
- Home
- Explore
- My Projects
- Profile

Use Navigator navigation for secondary/detail/form screens where appropriate. Provide working back navigation.

## 7. PMD Practical 1 requirements
The app implementation and report must demonstrate where these Flutter elements appear:
- `Container` with `BoxDecoration` — borders, corners and shadows.
- Styled text using `TextStyle`.
- A shared `ThemeData` applied throughout the app.
- Buttons and gesture handling, including `onPressed` and `InkWell`.
- Forms with validation using `Form`, `TextFormField` and validators.
- `Navigator.push` and `Navigator.pop`.
- `Row`, `Column` and `Expanded`.
- `ListView.builder` for scrolling lists.

Also ensure:
- Responsive layouts.
- Clear navigation and a simple user flow.
- Consistent colours, typography and layout.

## 8. Suggested code organisation
Keep responsibilities separated:
- `screens/`: complete app pages.
- `widgets/`: reusable UI components shared by screens.
- `models/`: Dart classes describing data structures (for example, `Project`).
- `data/`: hard-coded sample data.
- `theme/`: shared colours and `ThemeData`.
- `main.dart`: app entry point and root app configuration.

Do not create unnecessary abstraction. Add files when they have a clear purpose.

## 9. Working rules
1. Inspect the existing project before editing files.
2. Preserve existing user work; do not overwrite files without checking them.
3. Implement in small, testable steps.
4. Run `flutter analyze` and, when possible, run the app or relevant tests after changes.
5. Fix errors introduced by your changes.
6. Keep sample content relevant to upcycling (e.g. tin-can planter, T-shirt tote bag, cardboard organiser).
7. Do not claim a feature works unless it has been implemented and checked.
8. If a requirement or design decision is unclear, ask one concise question rather than inventing a major product decision.

## 10. First task for Codex
Inspect the current Flutter project and its existing files. Then:
1. Confirm the project structure and Flutter setup.
2. Create or organise the folders only where needed.
3. Set up the shared app theme using the agreed colour palette.
4. Implement the onboarding flow (2–3 pages) and navigation to a temporary Login screen.
5. Summarise files changed and explain how to run the app.

Read `PROJECT_CONTEXT.md` and the files in `documentation/` before making product or UI decisions.
