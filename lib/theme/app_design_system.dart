/// Design System Constants for HanGo App
///
/// This file contains all design system values including spacing, border radius,
/// and other constants to ensure consistency across the application.

class AppSpacing {
  // Spacing scale: 4px base unit
  static const double xs = 4.0; // Extra small
  static const double sm = 8.0; // Small
  static const double md = 12.0; // Medium
  static const double lg = 16.0; // Large
  static const double xl = 24.0; // Extra large
  static const double xxl = 32.0; // 2x Extra large

  // Commonly used pairs
  static const double paddingSmall = sm;
  static const double paddingMedium = lg;
  static const double paddingLarge = xl;
  static const double paddingXLarge = xxl;

  // Gaps for spacing between widgets
  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  static const double gapXl = xl;
  static const double gapXxl = xxl;
}

class AppRadius {
  // Border radius scale: consistent with Material Design 3
  static const double none = 0.0;
  static const double sm = 8.0; // Small: for buttons, input fields
  static const double md = 10.0; // Medium: for cards
  static const double lg = 12.0; // Large: for modals
  static const double xl = 16.0; // Extra large: for special components
  static const double full = 9999.0; // Full: for circular elements

  // Aliases for semantic use
  static const double button = sm;
  static const double input = sm;
  static const double card = md;
  static const double modal = lg;
  static const double badge = sm;
  static const double avatar = full;
}

class AppElevation {
  // Shadow elevation levels
  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
}

class AppDimensions {
  // Common component dimensions
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 48.0;
  static const double buttonHeightXLarge = 56.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 32.0;

  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 40.0;
  static const double avatarSizeLarge = 56.0;
  static const double avatarSizeXLarge = 80.0;

  // Sidebar dimensions
  static const double sidebarWidth = 240.0;
  static const double sidebarCollapsedWidth = 80.0;

  // Responsive breakpoints
  static const double screenSmall = 480.0; // Mobile
  static const double screenMedium = 768.0; // Tablet
  static const double screenLarge = 1024.0; // Desktop
  static const double screenXLarge = 1280.0; // Large desktop

  // Table/DataTable specific
  static const double dataTableHeightRow = 56.0;
  static const double dataTablePaddingHorizontal = 16.0;
  static const double dataTablePaddingVertical = 12.0;
}

class AppAnimationDuration {
  // Animation durations in milliseconds
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration verySlow = Duration(milliseconds: 400);
  static const Duration extraSlow = Duration(milliseconds: 500);

  // Aliases for common animations
  static const Duration transition = normal;
  static const Duration hover = fast;
  static const Duration modal = slow;
  static const Duration pageRoute = verySlow;
}

class AppOpacity {
  // Opacity levels for layering and feedback
  static const double disabled = 0.5;
  static const double hover = 0.08;
  static const double pressed = 0.12;
  static const double disabled_text = 0.38;
  static const double secondary_text = 0.60;
  static const double overlay_light = 0.15;
  static const double overlay_medium = 0.3;
  static const double overlay_dark = 0.5;
}

class AppFontSize {
  // Typography scale based on Material Design 3
  static const double xs = 11.0;
  static const double sm = 12.0;
  static const double md = 14.0;
  static const double base = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;
  static const double display = 32.0;

  // Heading sizes
  static const double h1 = 32.0;
  static const double h2 = 28.0;
  static const double h3 = 24.0;
  static const double h4 = 20.0;
  static const double h5 = 18.0;
  static const double h6 = 16.0;
}

class AppFontWeight {
  // Font weights for consistency
  static const int light = 300;
  static const int regular = 400;
  static const int medium = 500;
  static const int semibold = 600;
  static const int bold = 700;
  static const int extrabold = 800;
}

class AppLineHeight {
  // Line height multipliers
  static const double tight = 1.2;
  static const double normal = 1.5;
  static const double relaxed = 1.625;
  static const double loose = 2.0;
}
