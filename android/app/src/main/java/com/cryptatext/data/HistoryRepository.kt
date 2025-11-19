package com.cryptatext.data

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.IOException

class HistoryRepository(private val dataStore: DataStore<Preferences>) {

    private val json = Json { ignoreUnknownKeys = true; encodeDefaults = true }

    val saveToggle: Flow<Boolean> = dataStore.data
        .catch { exception ->
            if (exception is IOException) emit(emptyPreferences()) else throw exception
        }
        .map { prefs -> prefs[SAVE_TOGGLE_KEY] ?: false }

    val history: Flow<List<HistoryEntry>> = dataStore.data
        .catch { exception ->
            if (exception is IOException) emit(emptyPreferences()) else throw exception
        }
        .map { prefs ->
            prefs[HISTORY_KEY]?.let {
                runCatching { json.decodeFromString<List<HistoryEntry>>(it) }.getOrDefault(emptyList())
            } ?: emptyList()
        }

    suspend fun setSaveToggle(enabled: Boolean) {
        dataStore.edit { prefs ->
            prefs[SAVE_TOGGLE_KEY] = enabled
        }
    }

    suspend fun appendEntry(entry: HistoryEntry) {
        dataStore.edit { prefs ->
            val current = prefs[HISTORY_KEY]?.let {
                runCatching { json.decodeFromString<List<HistoryEntry>>(it) }.getOrDefault(emptyList())
            } ?: emptyList()
            val updated = (listOf(entry) + current).take(MAX_ENTRIES)
            prefs[HISTORY_KEY] = json.encodeToString(updated)
        }
    }

    suspend fun deleteEntry(id: String) {
        dataStore.edit { prefs ->
            val current = prefs[HISTORY_KEY]?.let {
                runCatching { json.decodeFromString<List<HistoryEntry>>(it) }.getOrDefault(emptyList())
            } ?: emptyList()
            val updated = current.filterNot { it.id == id }
            if (updated.isEmpty()) {
                prefs.remove(HISTORY_KEY)
            } else {
                prefs[HISTORY_KEY] = json.encodeToString(updated)
            }
        }
    }

    suspend fun upsertEntries(transform: (List<HistoryEntry>) -> List<HistoryEntry>) {
        dataStore.edit { prefs ->
            val current = prefs[HISTORY_KEY]?.let {
                runCatching { json.decodeFromString<List<HistoryEntry>>(it) }.getOrDefault(emptyList())
            } ?: emptyList()
            val updated = transform(current)
            if (updated.isEmpty()) {
                prefs.remove(HISTORY_KEY)
            } else {
                prefs[HISTORY_KEY] = json.encodeToString(updated.take(MAX_ENTRIES))
            }
        }
    }

    suspend fun clearHistory() {
        dataStore.edit { prefs ->
            prefs.remove(HISTORY_KEY)
        }
    }

    companion object {
        private const val MAX_ENTRIES = 100
        private val SAVE_TOGGLE_KEY = booleanPreferencesKey("save_toggle")
        private val HISTORY_KEY = stringPreferencesKey("history")
    }
}

