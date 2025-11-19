# Unified Design System - Cryptatext

**Purpose:** Ensure consistent UI/UX across Android and iOS platforms while respecting platform-specific design guidelines.

---

## 🎨 Color Palette

### Core Colors
Both platforms use the same semantic color names:

| Color Name | Usage | Android | iOS |
|------------|-------|---------|-----|
| `primary` | Primary actions, buttons, accents | Material 3 Primary | Custom Primary |
| `onPrimary` | Text/icons on primary background | Material 3 On Primary | Custom On Primary |
| `background` | Main app background | Material 3 Background | Custom Background |
| `foreground` | Primary text color | Material 3 On Background | Custom Foreground |
| `mutedForeground` | Secondary text, hints | Material 3 On Surface Variant | Custom Muted Foreground |
| `card` | Card backgrounds | Material 3 Surface | Custom Card |
| `input` | Input field backgrounds | Material 3 Surface Variant | Custom Input |
| `border` | Borders, dividers | Material 3 Outline | Custom Border |
| `destructive` | Delete actions, errors | Material 3 Error | Custom Destructive |
| `success` | Success messages | Material 3 Tertiary | Custom Success |
| `muted` | Muted backgrounds | Material 3 Surface Container | Custom Muted |

### Implementation

#### Android
```kotlin
// LocalCryptatextColors.kt
val palette = LocalCryptatextColors.current
palette.primary
palette.foreground
```

#### iOS
```swift
// CryptatextPalette.swift
@Environment(\.cryptatextPalette) private var palette
palette.primary
palette.foreground
```

---

## 📐 Spacing System

### Standard Spacing Values

| Size | Value | Usage |
|------|-------|-------|
| `xs` | 4dp/4pt | Tight spacing, icon padding |
| `sm` | 8dp/8pt | Small gaps, compact lists |
| `md` | 12dp/12pt | Standard padding, card padding |
| `lg` | 16dp/16pt | Section spacing, large padding |
| `xl` | 24dp/24pt | Screen margins, large sections |
| `xxl` | 32dp/32pt | Extra large spacing |

### Implementation

#### Android
```kotlin
Modifier.padding(12.dp)  // md
Modifier.padding(horizontal = 16.dp, vertical = 12.dp)
```

#### iOS
```swift
.padding(12)  // md
.padding(.horizontal, 16)
.padding(.vertical, 12)
```

---

## 🔤 Typography

### Text Styles

| Style | Android | iOS | Usage |
|-------|---------|-----|-------|
| **Title Large** | `titleLarge` (22sp) | `.system(size: 22, weight: .bold)` | Screen titles |
| **Title Medium** | `titleMedium` (20sp) | `.system(size: 20, weight: .semibold)` | Section headers |
| **Body Large** | `bodyLarge` (16sp) | `.system(size: 17, weight: .regular)` | Primary text |
| **Body Medium** | `bodyMedium` (14sp) | `.system(size: 15, weight: .regular)` | Secondary text |
| **Body Small** | `bodySmall` (12sp) | `.system(size: 13, weight: .regular)` | Captions, hints |
| **Label** | `labelSmall` (11sp) | `.system(size: 11, weight: .medium)` | Labels, chips |

### Implementation

#### Android
```kotlin
Text(
    text = "Title",
    style = MaterialTheme.typography.titleLarge,
    fontWeight = FontWeight.SemiBold
)
```

#### iOS
```swift
Text("Title")
    .font(.system(size: 20, weight: .semibold))
```

---

## 🎯 Component Patterns

### 1. Buttons

#### Primary Button
**Android:**
```kotlin
Button(
    onClick = { },
    colors = ButtonDefaults.buttonColors(
        containerColor = palette.primary,
        contentColor = palette.onPrimary
    ),
    shape = RoundedCornerShape(12.dp),
    modifier = Modifier.fillMaxWidth()
) {
    Text("Button Text")
}
```

**iOS:**
```swift
Button(action: { }) {
    Text("Button Text")
        .font(.system(size: 17, weight: .semibold))
        .foregroundColor(palette.onPrimary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
}
```

#### Outlined Button
**Android:**
```kotlin
OutlinedButton(
    onClick = { },
    colors = ButtonDefaults.outlinedButtonColors(
        contentColor = palette.primary
    ),
    border = BorderStroke(1.dp, palette.primary),
    shape = RoundedCornerShape(12.dp)
) {
    Text("Button Text")
}
```

**iOS:**
```swift
Button(action: { }) {
    Text("Button Text")
        .foregroundColor(palette.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(palette.primary, lineWidth: 1)
        )
}
```

---

### 2. Text Fields

#### Standard Text Field
**Android:**
```kotlin
OutlinedTextField(
    value = text,
    onValueChange = { text = it },
    label = { Text("Label") },
    colors = OutlinedTextFieldDefaults.colors(
        focusedBorderColor = palette.primary,
        unfocusedBorderColor = palette.border,
        focusedContainerColor = palette.input,
        unfocusedContainerColor = palette.input
    ),
    shape = RoundedCornerShape(12.dp),
    modifier = Modifier.fillMaxWidth()
)
```

**iOS:**
```swift
TextField("Label", text: $text)
    .textFieldStyle(.roundedBorder)
    .autocapitalization(.none)
    .autocorrectionDisabled()
    .padding()
    .background(palette.input, in: RoundedRectangle(cornerRadius: 12))
```

---

### 3. Cards

#### Standard Card
**Android:**
```kotlin
Card(
    modifier = Modifier.fillMaxWidth(),
    colors = CardDefaults.cardColors(containerColor = palette.card),
    border = BorderStroke(1.dp, palette.border),
    shape = RoundedCornerShape(12.dp)
) {
    Column(modifier = Modifier.padding(16.dp)) {
        // Content
    }
}
```

**iOS:**
```swift
VStack {
    // Content
}
.padding()
.background(palette.card, in: RoundedRectangle(cornerRadius: 12))
.overlay(
    RoundedRectangle(cornerRadius: 12)
        .stroke(palette.border, lineWidth: 1)
)
```

---

### 4. Category Chips

#### Filter Chip
**Android:**
```kotlin
FilterChip(
    selected = isSelected,
    onClick = { },
    label = { Text("Category") },
    colors = FilterChipDefaults.filterChipColors(
        selectedContainerColor = palette.primary,
        selectedLabelColor = palette.onPrimary,
        containerColor = palette.card,
        labelColor = palette.foreground
    )
)
```

**iOS:**
```swift
Button(action: { }) {
    Text("Category")
        .font(.system(size: 14, weight: .medium))
        .foregroundColor(isSelected ? palette.onPrimary : palette.foreground)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            isSelected ? palette.primary : palette.card,
            in: RoundedRectangle(cornerRadius: 16)
        )
}
```

---

### 5. Empty States

#### Standard Empty State
**Android:**
```kotlin
Column(
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.spacedBy(16.dp)
) {
    Icon(
        imageVector = Icons.Filled.Visibility,
        contentDescription = null,
        modifier = Modifier.size(64.dp),
        tint = palette.mutedForeground
    )
    Text(
        text = "No items yet",
        style = MaterialTheme.typography.titleMedium,
        color = palette.foreground
    )
    Text(
        text = "Get started by adding your first item",
        style = MaterialTheme.typography.bodyMedium,
        color = palette.mutedForeground
    )
    Button(
        onClick = onAddAction,
        colors = ButtonDefaults.buttonColors(
            containerColor = palette.primary,
            contentColor = palette.onPrimary
        ),
        modifier = Modifier.padding(top = 8.dp)
    ) {
        Icon(Icons.Filled.Add, null, modifier = Modifier.size(20.dp))
        Spacer(modifier = Modifier.width(8.dp))
        Text("Add Your First Item")
    }
}
```

**iOS:**
```swift
VStack(spacing: 16) {
    Image(systemName: "lock.shield")
        .font(.system(size: 48))
        .foregroundColor(palette.mutedForeground)
    Text("No items yet")
        .font(.system(size: 18, weight: .medium))
        .foregroundColor(palette.foreground)
    Text("Get started by adding your first item")
        .font(.system(size: 15))
        .foregroundColor(palette.mutedForeground)
    Button(action: onAddAction) {
        Text("Add Your First Item")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(palette.onPrimary)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(palette.primary, in: RoundedRectangle(cornerRadius: 12))
    }
}
```

---

### 6. List Items

#### Password Entry List Item
**Android:**
```kotlin
Card(
    modifier = Modifier.fillMaxWidth(),
    colors = CardDefaults.cardColors(containerColor = palette.card),
    border = BorderStroke(1.dp, palette.border),
    shape = RoundedCornerShape(12.dp),
    onClick = onClick
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = entry.service,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.SemiBold,
                color = palette.foreground
            )
            Text(
                text = entry.username,
                style = MaterialTheme.typography.bodyMedium,
                color = palette.mutedForeground
            )
        }
        // Actions
    }
}
```

**iOS:**
```swift
HStack {
    VStack(alignment: .leading, spacing: 4) {
        Text(entry.service)
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(palette.foreground)
        Text(entry.username)
            .font(.system(size: 15))
            .foregroundColor(palette.mutedForeground)
    }
    Spacer()
    // Actions
}
.padding()
.background(palette.card, in: RoundedRectangle(cornerRadius: 12))
```

---

## 🎭 Animation & Transitions

### Standard Durations

| Duration | Value | Usage |
|----------|-------|-------|
| Fast | 150ms | Quick feedback, hover states |
| Normal | 300ms | Standard transitions |
| Slow | 500ms | Complex animations |

### Implementation

#### Android
```kotlin
// Compose animations
AnimatedVisibility(
    visible = isVisible,
    enter = fadeIn(animationSpec = tween(300)),
    exit = fadeOut(animationSpec = tween(300))
)
```

#### iOS
```swift
// SwiftUI animations
.animation(.easeInOut(duration: 0.3), value: isVisible)
```

---

## 📱 Platform-Specific Adaptations

### Android (Material Design 3)
- ✅ Use Material 3 components (`Button`, `Card`, `TextField`)
- ✅ Follow Material spacing (8dp grid)
- ✅ Use Material icons (`Icons.Filled.*`)
- ✅ Material color system
- ✅ Material typography scale

### iOS (Human Interface Guidelines)
- ✅ Use SwiftUI native components (`Button`, `List`, `TextField`)
- ✅ Follow iOS spacing (4pt grid)
- ✅ Use SF Symbols (`Image(systemName: "...")`)
- ✅ iOS color system
- ✅ iOS typography scale

---

## 🔄 Consistency Rules

### 1. Color Usage
- **Primary:** Always use for primary actions
- **Foreground:** Always use for primary text
- **Muted Foreground:** Always use for secondary text
- **Destructive:** Always use for delete/destructive actions

### 2. Spacing
- **Cards:** Always use 12dp/12pt padding
- **Sections:** Always use 16dp/16pt spacing
- **Screen margins:** Always use 12dp/12pt

### 3. Typography
- **Titles:** Always use titleMedium (20sp/20pt)
- **Body text:** Always use bodyLarge (16sp/17pt)
- **Captions:** Always use bodySmall (12sp/13pt)

### 4. Border Radius
- **Cards:** Always use 12dp/12pt
- **Buttons:** Always use 12dp/12pt
- **Chips:** Always use 16dp/16pt

---

## 📋 Checklist for New Components

When creating new UI components, ensure:

- [ ] Uses semantic color names from palette
- [ ] Follows spacing system (4/8/12/16/24dp)
- [ ] Uses consistent typography scale
- [ ] Has proper border radius (12dp for cards/buttons)
- [ ] Includes empty state if applicable
- [ ] Has loading state if async
- [ ] Has error state if applicable
- [ ] Follows platform-specific patterns
- [ ] Is accessible (content descriptions, labels)
- [ ] Works in light and dark mode

---

## 🎯 Design Principles

1. **Consistency First:** Same functionality should look similar across platforms
2. **Platform Native:** Use platform-specific components where appropriate
3. **Semantic Colors:** Always use semantic color names, never hardcoded colors
4. **Accessibility:** Ensure all components are accessible
5. **Performance:** Optimize for smooth animations and fast rendering

---

**Last Updated:** November 2024  
**Status:** ✅ Active - Use this guide for all new UI components

