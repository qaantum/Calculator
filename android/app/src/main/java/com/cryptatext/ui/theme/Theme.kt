package com.cryptatext.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import com.cryptatext.data.ThemeOption

@Composable
fun CryptatextTheme(themeOption: ThemeOption, content: @Composable () -> Unit) {
    val useDarkTheme = when (themeOption) {
        ThemeOption.LIGHT -> false
        ThemeOption.DARK -> true
        ThemeOption.SYSTEM -> isSystemInDarkTheme()
    }

    val palette = if (useDarkTheme) DarkCryptatextColors else LightCryptatextColors
    val colorScheme = palette.toMaterialColorScheme(useDarkTheme)

    CompositionLocalProvider(LocalCryptatextColors provides palette) {
        MaterialTheme(
            colorScheme = colorScheme,
            shapes = CryptatextShapes,
            typography = CryptatextTypography,
            content = content
        )
    }
}

private fun CryptatextColors.toMaterialColorScheme(isDark: Boolean) = if (isDark) {
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

