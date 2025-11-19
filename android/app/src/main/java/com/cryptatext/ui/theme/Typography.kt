package com.cryptatext.ui.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

val CryptatextTypography = Typography(
    headlineMedium = TextStyle(
        fontWeight = FontWeight.SemiBold,
        fontSize = 24.sp,
        letterSpacing = (-0.5).sp
    ),
    titleMedium = TextStyle(
        fontWeight = FontWeight.SemiBold,
        fontSize = 18.sp,
        letterSpacing = 0.sp
    ),
    titleSmall = TextStyle(
        fontWeight = FontWeight.SemiBold,
        fontSize = 16.sp,
        letterSpacing = 0.sp
    ),
    bodyLarge = TextStyle(
        fontSize = 16.sp,
        fontFamily = FontFamily.SansSerif,
        letterSpacing = 0.sp
    ),
    bodyMedium = TextStyle(
        fontSize = 14.sp,
        fontFamily = FontFamily.SansSerif,
        letterSpacing = 0.sp
    ),
    bodySmall = TextStyle(
        fontSize = 12.sp,
        fontFamily = FontFamily.SansSerif,
        letterSpacing = 0.sp
    ),
    labelLarge = TextStyle(
        fontWeight = FontWeight.Medium,
        fontSize = 14.sp,
        letterSpacing = 0.sp
    ),
    labelMedium = TextStyle(
        fontWeight = FontWeight.Medium,
        fontSize = 12.sp,
        letterSpacing = 0.sp
    ),
    labelSmall = TextStyle(
        fontWeight = FontWeight.Medium,
        fontSize = 11.sp,
        letterSpacing = 0.sp
    )
)

