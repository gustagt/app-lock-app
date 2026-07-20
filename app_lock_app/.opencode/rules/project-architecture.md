# Project Architecture

This project follows a **feature-first** architecture.

## Directory Structure

```
lib/
  main.dart                          # App entry point
  core/                              # Shared cross-feature code
    config/                          # Environment config, build flavors
    constants/                       # Route names, asset paths, string constants
    data/                            # Shared data sources (local storage, prefs)
    services/                        # Cross-feature services (notifications, analytics)
    theme/                           # Visual identity
      app_colors.dart                # Color palette constants
      app_shadows.dart               # Tinted shadow presets
      app_spacing.dart               # 8pt grid spacing system
      app_theme.dart                 # ThemeData (light/dark)
      app_typography.dart            # Google Fonts text theme (Outfit + Inter)
    utils/                           # Extensions, formatters, validators
  features/                          # Feature modules (one folder per feature)
    {feature_name}/
      data/                          # Feature-specific models, repositories, DTOs
      presentation/                  # Screens/pages (one per file)
      widgets/                       # Feature-specific widgets
```

## Conventions

- **Feature modules** are self-contained. All UI for a feature goes inside its folder.
- **Shared code** across features lives in `core/`. Each feature folder is responsible for its own domain logic.
- **Imports** use relative paths from the file location. No barrel files (re-exports) unless the team agrees.
- **State management** (when added) goes inside `data/` (repositories/sources) and `presentation/` (controllers/blocs).
- **No widget** should cross feature boundaries. If a widget is needed in 2+ features, it goes in `core/utils/` or a shared `widgets/` folder at root if justified.

## Theme Guidelines

- Colors are defined in `AppColors` (static const).
- Spacing uses the `AppSpacing` grid (multiples of 4/8).
- Shadows must be tinted (inherit hue from primary, never pure `#000`).
- Typography uses **Outfit** for headings and **Inter** for body text.

## Creating a New Feature

```bash
lib/features/{feature_name}/
  data/
  presentation/
  widgets/
```

## Testing

Tests mirror the source structure under `test/`:
```
test/
  core/theme/       # AppTheme, AppColors tests
  features/{feature}/presentation/   # Widget tests
  features/{feature}/data/           # Repository/model unit tests
```
