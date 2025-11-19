package com.cryptatext

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.fragment.app.FragmentActivity
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import com.cryptatext.BuildConfig
import com.cryptatext.ui.CryptatextApp
import com.cryptatext.ui.ExpirationScreen

class MainActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        var sharedText by mutableStateOf<String?>(null)
        
        // Handle shared text from other apps
        handleSharedText(intent)?.let { text ->
            sharedText = text
        }
        
        setContent {
            val textToSet = remember { sharedText }
            
            CryptatextApp(initialSharedText = textToSet)
            
            // Clear shared text after setting it
            LaunchedEffect(textToSet) {
                if (textToSet != null) {
                    sharedText = null
                }
            }
        }
    }
    
    private fun handleSharedText(intent: Intent?): String? {
        if (intent == null) return null
        
        // Handle shared text (ACTION_SEND)
        if (intent.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            return intent.getStringExtra(Intent.EXTRA_TEXT)
        }
        
        // Handle deep link (ACTION_VIEW)
        if (intent.action == Intent.ACTION_VIEW && intent.data != null) {
            val data = intent.data
            // Check for "text" query parameter: cryptatext://encrypt?text=Hello
            return data?.getQueryParameter("text")
        }
        
        return null
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleSharedText(intent)?.let { text ->
            // We need to update the state to trigger recomposition if the app is already running
            // Ideally this would be handled by a ViewModel or a more robust state holder,
            // but for this simple activity, we can just recreate the content or use a broadcast.
            // However, since we passed initialSharedText to CryptatextApp, it only works on first launch.
            // To support onNewIntent properly, we should probably relaunch the activity or use a mutable state
            // that is passed down.
            // For simplicity in this "Polish" phase, we'll just relaunch the activity to ensure state is fresh.
            val newIntent = Intent(this, MainActivity::class.java)
            newIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
            newIntent.putExtra(Intent.EXTRA_TEXT, text)
            newIntent.action = Intent.ACTION_SEND
            newIntent.type = "text/plain"
            startActivity(newIntent)
        }
    }
    
    fun launchPlayStore() {
        val appId = packageName
        val marketIntent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$appId"))
        val webIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=$appId"))
        
        try {
            startActivity(marketIntent)
        } catch (e: android.content.ActivityNotFoundException) {
            try {
                startActivity(webIntent)
            } catch (e: Exception) {
                // Neither market nor browser available, or other error
                // Could show a toast here if needed
            }
        }
    }
}

