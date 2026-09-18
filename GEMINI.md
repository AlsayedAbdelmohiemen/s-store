# S-Store & Admin Panel UI/UX Design System Rules

Whenever modifying, designing, or implementing Flutter widgets, screens, themes, or layouts for this project:

1. **Brand Color Palette (Modern Indigo & Slate)**:
   - Primary: `SColors.primary` / `SColors.primaryColor` (`0xFF4F46E5`). Never hardcode `Colors.blue`.
   - Secondary / Accent: `SColors.secondary` (`0xFFF59E0B`), `SColors.accent` (`0xFFEEF2FF`).
   - Surfaces: Always use `SColors.light` (`0xFFF8FAFC`) / `SColors.dark` (`0xFF0F172A`). Never use pitch black `Colors.black` for dark backgrounds.
   - Cards/Containers: `SColors.lightContainer` (`Colors.white`) / `SColors.darkContainer` (`0xFF1E293B`).
   - Status: Success (`0xFF10B981`), Warning (`0xFFF59E0B`), Error (`0xFFEF4444`).

2. **Card & Container Aesthetics**:
   - Always use smooth rounded corners (`BorderRadius.circular(16)` or `12`).
   - Cards must feature subtle borders (`SColors.borderSecondary` in light, `SColors.darkerGrey.withValues(alpha: 0.2)` in dark) and soft ambient shadows.

3. **Visual Hierarchy & Typography**:
   - Utilize consistent spacing based on `SSizes` (8-point grid).
   - Ensure clear contrast between headings (bold, high contrast) and supporting captions/labels (`SColors.textSecondary`).

4. **Consistency**:
   - Both `lib/` (Mobile Store) and `admin_panel/lib/` (Admin Dashboard) must strictly share this unified visual language.
