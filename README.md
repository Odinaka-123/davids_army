David’s Army — Teen App (Flutter)

A modular Flutter application for the David’s Army teen ministry. Built with Riverpod, GoRouter, and clean architecture principles. The app provides teens with access to resources, services directory, events, prayer requests, and mentorship tools.

Features
Core Modules

Home – Verse of the week, CTAs, news, quick actions

Directory – Searchable archive of services (series, speaker, topics)

Resources – Podcasts (Spotify), Generals (mentors), documents

Consult a General – Booking, asking questions, FAQs

Events – Calendar/list view, RSVP, add-to-calendar

Prayer Requests – Anonymous/private submissions

Profile – Saved items, history, notifications

Tech Stack
Layer	Implementation
Framework	Flutter (Dart)
State Management	Riverpod (FutureProvider, StateNotifier)
Navigation	GoRouter (nested routes + shell routing)
Storage	Firebase / Supabase (recommended)
Media Streaming	External links (Spotify), optional audio/video
Architecture	Feature-first + Clean Architecture
Project Structure (Recommended)
lib/
 ├── app/
 │    ├── router/
 │    │     └── app_router.dart
 │    └── theme/
 │          └── colors.dart
 │          └── typography.dart
 │          └── theme.dart
 │
 ├── core/
 │    ├── utils/
 │    ├── widgets/
 │    ├── errors/
 │    └── services/
 │
 ├── features/
 │    ├── home/
 │    ├── directory/
 │    ├── resources/
 │    ├── generals/
 │    ├── events/
 │    ├── prayer/
 │    └── profile/
 │
 └── main.dart


Pattern:
Each feature folder contains its own
models/, providers/, views/, controllers/, and repository/ (if needed).

Routing Structure (GoRouter)
/                → Home
/directory       → Directory list
/directory/:id   → Service details
/resources       → Main hub
/resources/podcasts
/resources/generals
/events
/events/:id
/prayer
/profile

State Management Approach

Riverpod for all business logic

FutureProvider → data fetching (services, podcasts, events)

StateNotifier → user actions (save, bookmark, submit form)

Global providers stored in /core/providers

Feature-specific providers inside each feature module

Database Overview

Your schema will include tables like:

services (title, date, speaker, tags, media URLs)

podcasts (title, description, episode link)

generals (name, role, topics, availability)

events (title, datetime, description)

prayer_requests (anonymous flag, user id, text, urgency)

users (profile, saved_items, history)

Setup & Development
1. Clone & install
git clone https://github.com/<your-username>/davids-army-app.git
cd davids-army-app
flutter pub get

2. Environment variables

Create .env or .env.local:

SUPABASE_URL=
SUPABASE_ANON_KEY=



3. Run
flutter run

4. Build
flutter build apk
flutter build ios

Roadmap

 Wireframe → UI → Implementation

 Add authentication

 Implement all feature modules

 Add admin tools

 Add analytics + crash logging

 Publish to Play Store + TestFlight

License

Apache
