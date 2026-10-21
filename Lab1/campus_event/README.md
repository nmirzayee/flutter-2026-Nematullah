#lab 1
Campus Events is a Flutter application for browsing and managing university events. Users can search events, filter categories, save favourites, register for events, and manage their profile.


## Features
- Three tabs: Events, Favourites, and Profile
- Search and category filters
- Responsive event list and grid
- Event details and registration
- Add, edit, and delete events
- Form validation
- Light, dark, and system themes
- Drawer with About and Reset Data

## Screenshots
1. Phone — Light mode: add screenshot
2. Phone — Dark mode: add screenshot
3. Tablet — Event grid: add screenshot

## Decisions
The event list and profile are stored in the AppShell State so that all tabs share the same data. The detail screen receives callbacks to request changes without owning the main event list. The event form returns a CampusEvent through Navigator.pop, allowing the caller to update the list after a successful save. LayoutBuilder determines whether events appear in a list or grid based on available width. PopScope compares the current form values with the initial values to prevent accidental loss of changes. The models use immutable fields and copyWith to create updated objects instead of modifying existing ones. In week 9, I would consider adding persistent storage so that events and profile changes remain available after restarting the application.

## Running the project

```bash
flutter pub get
flutter run -d chrome
```

## Verification

```bash
dart format .
flutter analyze
```