package com.qaantum.calculatorhub.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val CleanDarkScheme = darkColorScheme(
    primary = Sky500,
    onPrimary = White,
    primaryContainer = Slate700,
    onPrimaryContainer = White,
    background = Slate900,
    onBackground = Slate50,
    surface = Slate800,
    onSurface = Slate50,
    surfaceVariant = Slate700,
    onSurfaceVariant = Slate50,
    outline = Slate600,
    error = Red500
)

private val CleanLightScheme = lightColorScheme(
    primary = Slate700,
    onPrimary = White,
    primaryContainer = Slate50,
    onPrimaryContainer = Slate900,
    background = Slate50,
    onBackground = Slate900,
    surface = White,
    onSurface = Slate900,
    surfaceVariant = Slate50, // Card background
    onSurfaceVariant = Slate600,
    outline = Slate500,
    error = Red500
)

@Composable
fun CalculatorHubTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    // dynamicColor is removed/ignored to enforce Pro look
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) CleanDarkScheme else CleanLightScheme

    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.background.toArgb()
            window.navigationBarColor = colorScheme.background.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
            WindowCompat.getInsetsController(window, view).isAppearanceLightNavigationBars = !darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
