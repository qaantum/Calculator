package com.ciphio.vault.autofill

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * BroadcastReceiver to trigger autofill after credential selection.
 * This helps ensure autofill happens immediately after authentication.
 */
class AutofillBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.ciphio.vault.autofill.CREDENTIALS_READY") {
            Log.d("AutofillBroadcast", "Received credentials ready broadcast")
            // The autofill service will detect stored credentials on next request
        }
    }
}

