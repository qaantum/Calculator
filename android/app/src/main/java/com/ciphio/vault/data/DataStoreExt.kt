package com.ciphio.vault.data

import android.content.Context
import androidx.datastore.preferences.preferencesDataStore

val Context.ciphioDataStore by preferencesDataStore(name = "ciphio")

