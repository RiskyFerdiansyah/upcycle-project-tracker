# PROJECT_CONTEXT.md — Upcycle Project Tracker

## 1. Project identity
**Project title:** Upcycle Project Tracker  
**Concept:** An Open Educational and Community-Based Upcycling Platform  
**Sustainability alignment:** UN SDG 12 — Responsible Consumption and Production.

## 2. Project overview
The application is intended to help teachers, lecturers, students and the general public discover, create, share and recreate upcycling projects.

It combines two environments:
- **Educational environment:** learning activities, classes, assignments, student submissions and educator progress monitoring.
- **Public community environment:** project discovery, tutorials, publishing, sharing and recreating projects.

Both environments connect through one shared Community Gallery.

## 3. Problem and objectives
The proposal identifies that people may have ideas for reusing discarded materials but lack practical guidance, inspiration or a platform to share their creations. Educational institutions also need practical sustainability activities and ways for educators to assign projects and monitor student progress.

The project aims to:
1. Provide a platform to discover and share upcycling ideas.
2. Encourage sustainable living and SDG 12 awareness.
3. Support project-based learning for educators and students.
4. Let users create, track and document projects.
5. Encourage creativity through Project Remake / Recreate.
6. Support educational progress tracking and assessment.
7. Explore Machine Learning for student learning analytics in a separate ML workstream.

## 4. Target users and roles
- Primary school students.
- Secondary school students.
- College students.
- University students.
- Teachers and lecturers.
- General public / creators.

The proposal uses flexible user roles: users start with a standard account and may receive additional access according to their activities and responsibilities. Teacher/lecturer access requires educational role verification. A user may have multiple roles.

## 5. Main product features
### Project Tutorial
Project title and description, materials, tools, step-by-step instructions, estimated completion time and difficulty level.

### Community Project Gallery
A shared gallery for public and educational projects. Proposed filters include:
- All Projects
- Public Projects
- Educational Projects
- Verified Projects
- Assigned Projects (permission-controlled)
- Difficulty: Easy, Medium, Hard
- Materials: Plastic, Paper, Glass, Fabric and others
- Project status: Not Started, In Progress, Completed

### Project Remake / Recreate
A user discovers a project, chooses to recreate it, follows the tutorial, makes their own version, uploads results and credits the original creator.

### Teacher / Lecturer Dashboard
Create classes, generate class codes, assign gallery projects, monitor participation and progress, review submissions and provide feedback/assessments.

### Learning and Assessment
Potential activities include short quizzes, sustainability questions, reflections and project-related assessments.

### Project Tracking
Personal tracking supports saving projects, updating status, uploading progress photos and viewing history. Educational tracking connects classes, assignments, submissions and educator feedback.

Suggested statuses:
- Not Started
- In Progress
- Completed

**Important:** Project tracking means recording project activities and progress; it is not GPS or physical location tracking.

## 6. Publishing approach
The proposal describes a Hybrid Publishing System:
- Public creators may publish projects directly, subject to moderation.
- Educational projects go through educational review/verification before receiving a Verified Educational Content label.
- Publication states include Pending Review, Published and Rejected/Removed.

## 7. PMD Practical 1 — implementation scope
**Course:** Programming for Mobile Devices (CCS21503 / TCS22103)  
**Practical:** Practical 1 — Front-End Design  
**Technology:** Flutter (Dart) with Material UI components.

The practical requires at least five screen categories:
1. Onboarding — two or three intro screens.
2. Login and Register — form fields with validation; no database needed yet.
3. Dashboard — summary section plus navigation.
4. Main Feature Screen — core case-study screen showing a scrolling list.
5. Create / Edit Screen — form for adding or changing an item.

Required Flutter elements:
- `Container` with `BoxDecoration`.
- Styled text with `TextStyle`.
- One `ThemeData` applied throughout.
- Buttons and gesture handling (`onPressed`, `InkWell`).
- Form validation (`TextFormField`, validator).
- `Navigator.push` and `Navigator.pop`.
- `Row`, `Column` and `Expanded`.
- `ListView.builder`.

Design requirements: responsive layouts, clear navigation, simple user flow and consistent colours, typography and layout.

Data may be hard-coded in Dart lists at this stage; database integration belongs to Practical 2.

The PMD report is 5–10 pages and should include introduction/project title/objective/SDG relevance, system overview and target users, UI design/development decisions, a table showing where each required Flutter element appears, labelled screenshots, 2–3 real challenges and solutions, and a conclusion.

## 8. Agreed UI/UX direction in this project
The user approved a combined **UI Mockup + Flutter Development Together** workflow.

Visual direction:
- Modern eco-friendly interface.
- Forest Green `#245C43` as primary.
- Sage Green `#6D9B75` as secondary.
- Mint `#DDEBDD` as surface.
- Off White `#F7F7F0` as background.
- Warm Orange `#E8A95B` as accent.
- Rounded cards, subtle shadows, clean typography and clear navigation.

Planned screens:
1. Onboarding (2–3 intro pages).
2. Login.
3. Register.
4. Home Dashboard.
5. Community Gallery.
6. Project Details & Tutorial.
7. Create / Edit Project.
8. My Projects.
9. User Profile.

Proposed bottom navigation after login:
- Home
- Explore
- My Projects
- Profile

## 9. Suggested Flutter folder responsibilities
- `main.dart`: app entry point and root configuration.
- `screens/`: full pages/screens.
- `widgets/`: reusable components such as project cards, buttons and bottom navigation.
- `models/`: data structure classes such as `Project`.
- `data/`: sample project lists.
- `theme/`: shared colours, text styles and `ThemeData`.

## 10. Development workflow
The user wants to work quickly using both ChatGPT and Codex:
- ChatGPT project conversation: planning, UI/UX decisions, explanations and tracking decisions.
- Codex: inspect and edit the local Flutter project, implement UI, run analysis and debug.
- Keep this file and `AGENTS.md` in the project root so Codex can read the durable project context.
- Store original assignment/proposal references and UI/UX reference image in `documentation/`.

## 11. Important scope boundaries
- Practical 1 is a front-end prototype, not a complete production platform.
- No database/backend is required for this practical.
- Teacher dashboard, class management, advanced community moderation and ML analytics are part of the wider concept/future stages; do not let them delay the mandatory Practical 1 screens.
- The ML assignment is a separate Python/Jupyter/Scikit-Learn workstream. The proposal does not yet confirm a final ML target or dataset.
