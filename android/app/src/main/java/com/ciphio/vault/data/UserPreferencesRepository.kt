package com.ciphio.vault.data

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import java.io.IOException

data class PasswordPreferences(
    val length: Int = 16,
    val includeUppercase: Boolean = true,
    val includeLowercase: Boolean = true,
    val includeDigits: Boolean = true,
    val includeSymbols: Boolean = true
)

enum class ThemeOption { LIGHT, DARK, SYSTEM }

class UserPreferencesRepository(private val dataStore: DataStore<Preferences>) {

    val passwordPreferences: Flow<PasswordPreferences> = dataStore.data
        .catch { exception ->
            if (exception is IOException) emit(emptyPreferences()) else throw exception
        }
        .map { prefs ->
            PasswordPreferences(
                length = prefs[LENGTH_KEY] ?: 16,
                includeUppercase = prefs[UPPERCASE_KEY] ?: true,
                includeLowercase = prefs[LOWERCASE_KEY] ?: true,
                includeDigits = prefs[DIGITS_KEY] ?: true,
                includeSymbols = prefs[SYMBOLS_KEY] ?: true
            )
        }

    val themeOption: Flow<ThemeOption> = dataStore.data
        .catch { exception ->
            if (exception is IOException) emit(emptyPreferences()) else throw exception
        }
        .map { prefs ->
            when (prefs[THEME_KEY] ?: THEME_SYSTEM) {
                THEME_LIGHT -> ThemeOption.LIGHT
                THEME_DARK -> ThemeOption.DARK
                else -> ThemeOption.SYSTEM
            }
        }

    suspend fun updatePasswordPreferences(preferences: PasswordPreferences) {
        dataStore.edit { prefs ->
            prefs[LENGTH_KEY] = preferences.length
            prefs[UPPERCASE_KEY] = preferences.includeUppercase
            prefs[LOWERCASE_KEY] = preferences.includeLowercase
            prefs[DIGITS_KEY] = preferences.includeDigits
            prefs[SYMBOLS_KEY] = preferences.includeSymbols
        }
    }

    suspend fun setTheme(option: ThemeOption) {
        dataStore.edit { prefs ->
            prefs[THEME_KEY] = when (option) {
                ThemeOption.LIGHT -> THEME_LIGHT
                ThemeOption.DARK -> THEME_DARK
                ThemeOption.SYSTEM -> THEME_SYSTEM
            }
        }
    }

    companion object {
        private const val THEME_LIGHT = "light"
        private const val THEME_DARK = "dark"
        private const val THEME_SYSTEM = "system"

        private val LENGTH_KEY = intPreferencesKey("password_length")
        private val UPPERCASE_KEY = booleanPreferencesKey("password_uppercase")
        private val LOWERCASE_KEY = booleanPreferencesKey("password_lowercase")
        private val DIGITS_KEY = booleanPreferencesKey("password_digits")
        private val SYMBOLS_KEY = booleanPreferencesKey("password_symbols")
        private val THEME_KEY = stringPreferencesKey("theme_option_v2")
    }
}

