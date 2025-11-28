package com.ciphio.vault.ui.theme

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

@Immutable
data class CiphioColors(
    val background: Color,
    val foreground: Color,
    val card: Color,
    val primary: Color,
    val onPrimary: Color,
    val secondary: Color,
    val onSecondary: Color,
    val input: Color,
    val border: Color,
    val success: Color,
    val warning: Color,
    val destructive: Color,
    val info: Color,
    val muted: Color,
    val mutedForeground: Color
)

val LightCiphioColors = CiphioColors(
    background = Color(0xFFF5F7F8),
    foreground = Color(0xFF2D3A47),
    card = Color(0xFFFFFFFF),
    primary = Color(0xFF2D3A47),
    onPrimary = Color(0xFFFAFAFA),
    secondary = Color(0xFFF4F5F7),
    onSecondary = Color(0xFF2D3A47),
    input = Color(0xFFEEF0F2),
    border = Color(0xFFE1E4E8),
    success = Color(0xFF28A745),
    warning = Color(0xFFE5A50A),
    destructive = Color(0xFFF44336),
    info = Color(0xFF1E88E5),
    muted = Color(0xFFEFF1F4),
    mutedForeground = Color(0xFF596677)
)

val DarkCiphioColors = CiphioColors(
    background = Color(0xFF111820),
    foreground = Color(0xFFDDE1E6),
    card = Color(0xFF1A242E),
    primary = Color(0xFFB3FFF3),
    onPrimary = Color(0xFF111820),
    secondary = Color(0xFF243240),
    onSecondary = Color(0xFFDDE1E6),
    input = Color(0xFF293947),
    border = Color(0xFF243240),
    success = Color(0xFF218838),
    warning = Color(0xFFF0A30A),
    destructive = Color(0xFFD32F2F),
    info = Color(0xFF64B5F6),
    muted = Color(0xFF1F2A36),
    mutedForeground = Color(0xFF9BA7B4)
)

val LocalCiphioColors = staticCompositionLocalOf { LightCiphioColors }

