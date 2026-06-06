# SoloQuest Design System

> Design spec cho Flutter team. Mọi color, spacing, typography đều có CSS variable để theme switch.

---

## 1. Color Palette

### Background Layers (từ sâu → nổi)

| Token | Hex | CSS Variable | Dùng cho |
|-------|-----|--------------|----------|
| `bgDeep` | `#060A14` | `--bg-deep` | Nền ngoài cùng |
| `bg` | `#0A0E1A` | `--bg` | Nền chính |
| `bgRaised` | `#0F1629` | `--bg-raised` | Card nổi, sheet, nav |
| `surface` | `#141B2D` | `--surface` | Card, input background |
| `surfaceHover` | `#1A2340` | `--surface-hover` | Hover state |
| `surfaceActive` | `#1F2A4A` | `--surface-active` | Active/pressed state |

### Text

| Token | Hex | CSS Variable | Dùng cho |
|-------|-----|--------------|----------|
| `fg` | `#E8ECF4` | `--fg` | Text chính |
| `fgSecondary` | `#8B95A8` | `--fg-secondary` | Text phụ, mô tả |
| `fgMuted` | `#4A5568` | `--fg-muted` | Text disabled, placeholder |

### Accent Colors

| Token | Hex | CSS Variable | Dùng cho |
|-------|-----|--------------|----------|
| `cyan` | `#00F0FF` | `--cyan` | Primary accent, CTA, active |
| `cyanDim` | `rgba(0,240,255,0.15)` | `--cyan-dim` | Background nhẹ cyan |
| `cyanGlow` | `rgba(0,240,255,0.3)` | `--cyan-glow` | Glow effect |
| `violet` | `#A855F7` | `--violet` | Secondary accent |
| `violetDim` | `rgba(168,85,247,0.15)` | `--violet-dim` | Background nhẹ violet |
| `violetGlow` | `rgba(168,85,247,0.3)` | `--violet-glow` | Glow effect |

### Status Colors

| Token | Hex | CSS Variable | Dùng cho |
|-------|-----|--------------|----------|
| `success` | `#22C55E` | `--success` | Hoàn thành, streak |
| `successDim` | `rgba(34,197,94,0.15)` | `--success-dim` | Background success |
| `warn` | `#F59E0B` | `--warn` | Cảnh báo, hoãn, streak |
| `warnDim` | `rgba(245,158,11,0.15)` | `--warn-dim` | Background warn |
| `danger` | `#EF4444` | `--danger` | Bỏ qua, error |
| `dangerDim` | `rgba(239,68,68,0.15)` | `--danger-dim` | Background danger |
| `info` | `#3B82F6` | `--info` | Thông tin |
| `infoDim` | `rgba(59,130,246,0.15)` | `--info-dim` | Background info |

### EXP / Gamification

| Token | Hex | CSS Variable | Dùng cho |
|-------|-----|--------------|----------|
| `expGold` | `#FFD700` | `--exp-gold` | EXP value, badge |
| `expGoldDim` | `rgba(255,215,0,0.15)` | `--exp-gold-dim` | Background EXP |
| `levelGradient` | `linear-gradient(135deg, #00F0FF, #A855F7)` | `--level-gradient` | Level badge, CTA button |

### Borders

| Token | Value | CSS Variable |
|-------|-------|--------------|
| `border` | `rgba(255,255,255,0.06)` | `--border` |
| `borderSubtle` | `rgba(255,255,255,0.03)` | `--border-subtle` |
| `borderGlowCyan` | `rgba(0,240,255,0.2)` | `--border-glow-cyan` |
| `borderGlowViolet` | `rgba(168,85,247,0.2)` | `--border-glow-violet` |

### Chip Colors (Quest Types)

| Quest Type | Background | Text Color |
|------------|------------|------------|
| Water | `rgba(59,130,246,0.15)` | `#60A5FA` |
| Break | `rgba(168,85,247,0.15)` | `#C084FC` |
| Movement | `rgba(34,197,94,0.15)` | `#4ADE80` |
| Learning | `rgba(245,158,11,0.15)` | `#FBBF24` |
| Sleep | `rgba(99,102,241,0.15)` | `#818CF8` |
| Fitness | `rgba(239,68,68,0.15)` | `#F87171` |

### Flutter Implementation

```dart
// theme/app_colors.dart
class AppColors {
  // Background
  static const Color bgDeep = Color(0xFF060A14);
  static const Color bg = Color(0xFF0A0E1A);
  static const Color bgRaised = Color(0xFF0F1629);
  static const Color surface = Color(0xFF141B2D);
  static const Color surfaceHover = Color(0xFF1A2340);
  static const Color surfaceActive = Color(0xFF1F2A4A);

  // Text
  static const Color fg = Color(0xFFE8ECF4);
  static const Color fgSecondary = Color(0xFF8B95A8);
  static const Color fgMuted = Color(0xFF4A5568);

  // Accent
  static const Color cyan = Color(0xFF00F0FF);
  static const Color cyanDim = Color(0x2600F0FF); // 15%
  static const Color cyanGlow = Color(0x4D00F0FF); // 30%
  static const Color violet = Color(0xFFA855F7);
  static const Color violetDim = Color(0x26A855F7);
  static const Color violetGlow = Color(0x4DA855F7);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color successDim = Color(0x2622C55E);
  static const Color warn = Color(0xFFF59E0B);
  static const Color warnDim = Color(0x26F59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDim = Color(0x26EF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDim = Color(0x263B82F6);

  // EXP
  static const Color expGold = Color(0xFFFFD700);
  static const Color expGoldDim = Color(0x26FFD700);
  static const LinearGradient levelGradient = LinearGradient(
    colors: [cyan, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Borders
  static const Color border = Color(0x0FFFFFFF); // 6%
  static const Color borderSubtle = Color(0x08FFFFFF); // 3%
  static const Color borderGlowCyan = Color(0x3300F0FF); // 20%
  static const Color borderGlowViolet = Color(0x33A855F7);
}
```

---

## 2. Typography

| Style | Font | Size | Weight | Letter Spacing | Dùng cho |
|-------|------|------|--------|----------------|----------|
| Display | Inter | 24-32px | 800 | -0.02em | Page title |
| Heading | Inter | 18px | 700 | 0 | Section title |
| Body | Inter | 14-15px | 500-600 | 0 | Text chính |
| Caption | Inter | 12-13px | 400-500 | 0 | Text phụ |
| Label | Inter | 11px | 600 | 0.04em | Chip, badge nhỏ |
| Mono | JetBrains Mono | 11-14px | 600-800 | 0 | Số liệu, EXP, thời gian |
| Mono Label | JetBrains Mono | 10-11px | 700 | 0.08-0.12em | Section label uppercase |

### Flutter Implementation

```dart
// theme/app_text_styles.dart
class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    color: AppColors.fg,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.fg,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.fg,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.fgSecondary,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.04,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.fg,
  );

  static const TextStyle monoLabel = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.08,
    color: AppColors.fgMuted,
  );
}
```

---

## 3. Spacing & Radius

### Spacing Scale

| Token | Value |
|-------|-------|
| `space4` | 4px |
| `space6` | 6px |
| `space8` | 8px |
| `space10` | 10px |
| `space12` | 12px |
| `space14` | 14px |
| `space16` | 16px |
| `space20` | 20px |
| `space24` | 24px |
| `space32` | 32px |
| `space40` | 40px |

### Border Radius

| Token | Value | Dùng cho |
|-------|-------|----------|
| `radiusSm` | 8px | Button nhỏ, chip |
| `radiusMd` | 12px | Button, input, card nhỏ |
| `radiusLg` | 16px | Card lớn, section |
| `radiusXl` | 20px | Modal, bottom sheet |
| `radiusFull` | 9999px | Pill shape, badge |

### Flutter Implementation

```dart
// theme/app_spacing.dart
class AppSpacing {
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get fullAll => BorderRadius.circular(full);

  // Bottom sheet: top corners only
  static const BorderRadius sheet = BorderRadius.vertical(top: Radius.circular(xl));
}
```

---

## 4. Shadows & Glows

| Token | Value | Dùng cho |
|-------|-------|----------|
| `glowCyan` | `0 0 20px rgba(0,240,255,0.15), 0 0 40px rgba(0,240,255,0.05)` | Card active cyan |
| `glowViolet` | `0 0 20px rgba(168,85,247,0.15), 0 0 40px rgba(168,85,247,0.05)` | Card active violet |
| `shadowCard` | `0 4px 24px rgba(0,0,0,0.4)` | Card nổi |
| `shadowElevated` | `0 8px 32px rgba(0,0,0,0.6)` | Modal, sheet |

### Flutter Implementation

```dart
// theme/app_shadows.dart
class AppShadows {
  static List<BoxShadow> get glowCyan => [
    BoxShadow(color: Color(0x2600F0FF), blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: Color(0x0D00F0FF), blurRadius: 40, spreadRadius: 0),
  ];

  static List<BoxShadow> get glowViolet => [
    BoxShadow(color: Color(0x26A855F7), blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: Color(0x0DA855F7), blurRadius: 40, spreadRadius: 0),
  ];

  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withValues(alpha:0.4), blurRadius: 24, offset: Offset(0, 4)),
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(color: Colors.black.withValues(alpha:0.6), blurRadius: 32, offset: Offset(0, 8)),
  ];
}
```

---

## 5. Buttons

### 5.1 Primary Button (CTA)

- Background: `cyan` → `#00F0FF`
- Text: `bgDeep` → `#060A14`, bold 700, 14-15px
- Min height: 44px (small), 48px (default)
- Border radius: `radiusMd` (12px)
- Pressed: scale 0.97, darken background
- Gradient variant: `levelGradient` (cyan → violet)

### 5.2 Secondary Button

- Background: transparent
- Text: `fg`
- Border: 1px solid `border`
- Pressed: background → `surface`

### 5.3 Ghost Button

- Background: transparent
- Text: `fgSecondary`
- Padding: smaller (8px 12px)
- No border

### 5.4 Icon Button

- Size: 44x44px
- Border radius: `radiusMd`
- Background: transparent hoặc `bgRaised`
- Border: 1px solid `border`

### 5.5 Special Buttons

| Button | Background | Text | Border |
|--------|------------|------|--------|
| Complete | `cyan` | `bgDeep` | none |
| Snooze | `warnDim` | `warn` | `rgba(245,158,11,0.2)` |
| Skip | transparent | `fgMuted` | `border` |
| Danger | `danger` | white | none |

### Flutter Implementation

```dart
// widgets/app_button.dart
enum AppButtonType { primary, secondary, ghost, danger, success, warn }

class AppButton extends StatelessWidget {
  final String label;
  final AppButtonType type;
  final VoidCallback? onPressed;
  final bool expanded;
  final Widget? icon;

  const AppButton({
    required this.label,
    this.type = AppButtonType.primary,
    this.onPressed,
    this.expanded = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: 1.0, // handle press state
        duration: Duration(milliseconds: 100),
        child: Container(
          height: 48,
          constraints: expanded ? BoxConstraints(maxWidth: double.infinity) : null,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: _border,
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, SizedBox(width: 6)],
              Text(label, style: _textStyle),
            ],
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    return switch (type) {
      AppButtonType.primary => AppColors.cyan,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.ghost => Colors.transparent,
      AppButtonType.danger => AppColors.danger,
      AppButtonType.success => AppColors.successDim,
      AppButtonType.warn => AppColors.warnDim,
    };
  }
  // ... implement _textStyle, _border
}
```

---

## 6. Cards

### 6.1 Base Card

- Background: `surface`
- Border: 1px solid `border`
- Border radius: `radiusLg` (16px)
- Padding: 16px
- Margin: 0 16px 12px

### 6.2 Glow Card

- Same as base + `borderGlowCyan` + `glowCyan` shadow
- Dùng cho: active quest, highlighted section

### 6.3 Info Card

- Background gradient: `rgba(0,240,255,0.05)` → `rgba(168,85,247,0.04)`
- Border: `borderGlowCyan`
- Dùng cho: AI insight, context card

### Flutter Implementation

```dart
// widgets/app_card.dart
class AppCard extends StatelessWidget {
  final Widget child;
  final bool glow;
  final Color? glowColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
      padding: padding ?? EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: glow ? AppColors.borderGlowCyan : AppColors.border,
        ),
        boxShadow: glow ? AppShadows.glowCyan : null,
      ),
      child: child,
    );
  }
}
```

---

## 7. Bottom Sheet

### Specs

- Position: absolute bottom 0, full width
- Background: `bgRaised`
- Border radius: `radiusXl` (20px) top corners only
- Max height: 70% screen
- Backdrop: `rgba(0,0,0,0.75)` + `blur(4px)`
- Handle bar: 36x4px, centered, color `fgMuted`
- Animation: slide up with `cubic-bezier(0.22, 1, 0.36, 1)`

### Structure

```
┌─────────────────────────────────┐
│         ─── (handle bar)        │
│                                 │
│  Title                    16px  │
│  Subtitle                 13px  │
│                                 │
│  [Option 1]  [Option 2]        │
│  [Option 3]  [Option 4]        │
│                                 │
│  [Confirm Button]               │
│  [Cancel Button]                │
└─────────────────────────────────┘
```

### Option Styles

- Default: `surface` bg, `border` border, `fgSecondary` text
- Selected: `cyanDim` bg, `borderGlowCyan` border, `cyan` text
- Radio variant: circle indicator with dot

### Flutter Implementation

```dart
// widgets/app_bottom_sheet.dart
class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget body,
    String? confirmLabel,
    VoidCallback? onConfirm,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
        decoration: BoxDecoration(
          color: AppColors.bgRaised,
          borderRadius: AppRadius.sheet,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.fgMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading),
                  if (subtitle != null) ...[
                    SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ],
              ),
            ),
            // Body
            Flexible(child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: body,
            )),
          ],
        ),
      ),
    );
  }
}
```

---

## 8. Toast

### Specs

- Position: bottom center (above nav), `bottom: 80px`
- Background: `surface`
- Border: 1px solid `borderGlowCyan`
- Border radius: `radiusFull` (pill)
- Padding: 10px 20px
- Font: 13px, 600, `fg`
- Animation: fade in + slide up, auto dismiss 2s

### Flutter Implementation

```dart
// widgets/app_toast.dart
class AppToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
        left: 20, right: 20,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 300),
            onEnd: () => Future.delayed(Duration(seconds: 2), () => entry.remove()),
            builder: (_, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.borderGlowCyan),
                ),
                child: Text(message, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
  }
}
```

---

## 9. Modal (Completion Modal)

### Specs

- Backdrop: `rgba(0,0,0,0.8)` + `blur(6px)`
- Background: `bgRaised`
- Border radius: 20px
- Width: 100% - 48px padding, max 340px
- Border: 1px solid `border`
- Shadow: `shadowElevated`

### Structure

```
┌─────────────────────────────────┐
│         ✓ (success ring)        │
│                                 │
│      "Nhiệm vụ hoàn thành"     │
│           +120 EXP              │
│                                 │
│  ┌─────────────────────────┐    │
│  │ Ghi chú...              │    │
│  └─────────────────────────┘    │
│                                 │
│  "Cảm nhận của bạn?"            │
│  [Tốt hơn] [Bình thường] [Mệt] │
│                                 │
│  "Độ khó?"                      │
│  [Dễ] [Vừa] [Khó] [Quá mệt]   │
│                                 │
│  [Xong]                         │
└─────────────────────────────────┘
```

### Feeling Options

- Default: `bgRaised` bg, `border` border, `fgSecondary` text
- Selected: `cyanDim` bg, `borderGlowCyan` border, `cyan` text

### Flutter Implementation

```dart
// widgets/completion_modal.dart
class CompletionModal extends StatelessWidget {
  final int exp;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgRaised,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.elevated,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success ring
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.successDim,
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child: Icon(Icons.check, color: AppColors.success, size: 28),
            ),
            SizedBox(height: 16),
            Text('Nhiệm vụ hoàn thành', style: AppTextStyles.heading),
            SizedBox(height: 8),
            Text('+$exp EXP', style: AppTextStyles.mono.copyWith(
              fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.expGold,
            )),
            // ... textarea, feeling options, confirm button
          ],
        ),
      ),
    );
  }
}
```

---

## 10. Chips & Tags

### 10.1 Quest Type Chip

- Size: small (10-11px)
- Padding: 3px 8px
- Border radius: `radiusFull`
- Uppercase, letter-spacing 0.04em
- Colors: see Chip Colors table above

### 10.2 Selection Chip

- Padding: 8px 14px
- Border radius: `radiusFull`
- Default: `surface` bg, `border` border
- Selected: type-specific dim bg + glow border

### Flutter Implementation

```dart
// widgets/app_chip.dart
enum QuestType { water, break_, movement, learning, sleep, fitness }

class AppChip extends StatelessWidget {
  final QuestType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(label.toUpperCase(), style: AppTextStyles.label.copyWith(
        color: _textColor, fontSize: 10,
      )),
    );
  }
}
```

---

## 11. Progress Bar

### Specs

- Height: 6px
- Background: `surface`
- Fill: `levelGradient` (cyan → violet)
- Border radius: `radiusFull`
- Animation: width transition 0.6s ease

### Flutter Implementation

```dart
// widgets/app_progress_bar.dart
class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: FractionallySizedBox(
        widthFactor: progress,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.levelGradient,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}
```

---

## 12. Bottom Navigation

### Specs

- Height: 64px + safe area bottom
- Background: `bgRaised`
- Border top: 1px solid `border`
- 5 items evenly spaced
- Active: `cyan` color
- Inactive: `fgMuted` color
- Icon size: 20-22px
- Label: 10px, weight 500

### Flutter Implementation

```dart
// widgets/app_bottom_nav.dart
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home, label: 'Trang Chủ', active: currentIndex == 0),
              _NavItem(icon: Icons.description, label: 'Nhật Ký', active: currentIndex == 1),
              _NavItem(icon: Icons.bar_chart, label: 'Tiến Trình', active: currentIndex == 2),
              _NavItem(icon: Icons.star, label: 'Thưởng', active: currentIndex == 3),
              _NavItem(icon: Icons.person, label: 'Hồ Sơ', active: currentIndex == 4),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 13. Animations

| Animation | Duration | Easing | Dùng cho |
|-----------|----------|--------|----------|
| Press scale | 100-150ms | ease | Button press → scale(0.97) |
| Slide up | 300ms | cubic-bezier(0.22, 1, 0.36, 1) | Bottom sheet |
| Fade | 250ms | ease | Modal, overlay |
| Pulse glow | 2s infinite | ease-in-out | Active indicator, logo |
| Progress fill | 600ms | ease | Progress bar |
| Shimmer | 2s infinite | linear | CTA button shine |
| Stagger | 50ms delay each | ease-out | List items appear |

### Flutter Implementation

```dart
// theme/app_animations.dart
class AppAnimations {
  static const Duration press = Duration(milliseconds: 100);
  static const Duration sheet = Duration(milliseconds: 300);
  static const Duration fade = Duration(milliseconds: 250);
  static const Duration progress = Duration(milliseconds: 600);

  static const Curve pressCurve = Curves.easeOut;
  static const Curve sheetCurve = Cubic(0.22, 1, 0.36, 1);
  static const Curve fadeCurve = Curves.easeInOut;
}
```

---

## 14. Layout Patterns

### Screen Structure (with Bottom Nav)

```
┌─────────────────────┐
│    Status Bar 44px  │
├─────────────────────┤
│                     │
│   Page Content      │ ← scrollable
│                     │
├─────────────────────┤
│   Bottom Nav 64px   │
└─────────────────────┘
```

### Screen Structure (full page, no nav)

```
┌─────────────────────┐
│    Status Bar 44px  │
├─────────────────────┤
│                     │
│   Full Page         │ ← scrollable
│                     │
└─────────────────────┘
```

### Content Padding

- Horizontal: 16-20px
- Section gap: 12-16px
- Card margin bottom: 12px

---

## 15. Theme Switching

Để support light theme hoặc custom theme, dùng `ThemeExtension`:

```dart
// theme/solo_quest_theme.dart
@immutable
class SoloQuestColors extends ThemeExtension<SoloQuestColors> {
  final Color bgDeep;
  final Color bg;
  final Color bgRaised;
  final Color surface;
  final Color fg;
  final Color fgSecondary;
  final Color fgMuted;
  final Color cyan;
  final Color violet;
  // ... all colors

  @override
  SoloQuestColors copyWith({...}) => SoloQuestColors(...);

  @override
  SoloQuestColors lerp(SoloQuestColors? other, double t) => ...;
}

// Usage
ThemeData(
  extensions: [
    SoloQuestColors.dark(), // or .light()
  ],
)

// Access
final colors = Theme.of(context).extension<SoloQuestColors>()!;
```

---

## 16. Screen List

| # | Screen | Key Components |
|---|--------|----------------|
| 01 | Welcome | Logo, gradient bg, shimmer CTA |
| 03 | Home | Stats grid, quest cards, bottom sheet, completion modal |
| 04 | Quest Detail | Tabs, hero, checklist, timer, amount selector |
| 05 | Logs | Timeline, day tabs |
| 06 | Progress | Level ring, stats grid, weekly chart, habit cards |
| 07 | Rewards | Shop grid |
| 08 | Daily Review | Rating, textarea, AI insight |
| 09 | Profile | Settings list |
| 10 | Morning Check-in | Slider inputs, mood selector |
| 11 | Weekly Summary | Charts, AI insight |
| 12 | Schedule Editor | Time blocks |
| 13 | Learning Goals | Skill selector |
| 14 | Learning Roadmap | Timeline, modules |
| 15 | Reminder Settings | Toggle switches |
| 16 | Quest Rules | Info cards |

---

## 17. Onboarding Flow (9 steps)

1. **Welcome** — splash, logo animation
2. **Basic Info** — name, age, gender, height, weight inputs
3. **Work** — job, schedule, free time
4. **Health** — activity level, last exercise, health limits
5. **Goals** — select areas: water, movement, learning, sleep...
6. **Schedule** — wake time, sleep time, free slots
7. **Reminders** — break frequency, water frequency, quiet hours
8. **Rewards** — select rewards: game, movie, rest, social, food
9. **Complete** — summary + sample schedule preview
