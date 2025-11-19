package com.cryptatext.data

import android.content.Context
import androidx.datastore.preferences.preferencesDataStore

val Context.cryptatextDataStore by preferencesDataStore(name = "cryptatext")

