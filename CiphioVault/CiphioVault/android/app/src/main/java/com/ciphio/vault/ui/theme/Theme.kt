package com.ciphio.vault.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import com.ciphio.vault.data.ThemeOption

@Composable
fun CiphioTheme(themeOption: ThemeOption, content: @Composable () -> Unit) {
    val useDarkTheme = when (themeOption) {
        ThemeOption.LIGHT -> false
        ThemeOption.DARK -> true
        ThemeOption.SYSTEM -> isSystemInDarkTheme()
    }

    val palette = if (useDarkTheme) DarkCiphioColors else LightCiphioColors
    val colorScheme = palette.toMaterialColorScheme(useDarkTheme)

    CompositionLocalProvider(LocalCiphioColors provides palette) {
        MaterialTheme(
            colorScheme = colorScheme,
            shapes = CiphioShapes,
            typography = CiphioTypography,
            content = content
        )
    }
}

private fun CiphioColors.toMaterialColorScheme(isDark: Boolean) = if (isDark) {
    darkColorScheme(
        primary = primary,
        onPrimary = onPrimary,
        secondary = secondary,
        onSecondary = onSecondary,
        background = background,
        surface = card,
        onBackground = foreground,
        onSurface = foreground,
        outline = border,
        error = destructive,
        onError = onPrimary,
        tertiary = info,
        onTertiary = onPrimary
    )
} else {
    lightColorScheme(
        primary = primary,
        onPrimary = onPrimary,
        secondary = secondary,
        onSecondary = onSecondary,
        background = background,
        surface = card,
        onBackground = foreground,
        onSurface = foreground,
        outline = border,
        error = destructive,
        onError = onPrimary,
        tertiary = info,
        onTertiary = onPrimary
    )
}

