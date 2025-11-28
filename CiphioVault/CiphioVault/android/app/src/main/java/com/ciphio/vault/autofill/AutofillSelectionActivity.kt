package com.ciphio.vault.autofill

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.ciphio.vault.ui.CiphioApp
import com.ciphio.vault.ui.theme.CiphioTheme

/**
 * Activity for selecting which credential to use when multiple matches are found.
 */
class AutofillSelectionActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // For now, just finish - in a full implementation, this would show
        // a list of matching credentials for the user to select from
        finish()
    }
}

