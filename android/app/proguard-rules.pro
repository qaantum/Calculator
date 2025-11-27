# Keep Kotlin serialization
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt

-keepclassmembers class kotlinx.serialization.json.** {
    *** Companion;
}
-keepclasseswithmembers class kotlinx.serialization.json.** {
    kotlinx.serialization.KSerializer serializer(...);
}

-keep,includedescriptorclasses class com.ciphio.vault.**$$serializer { *; }
-keepclassmembers class com.ciphio.vault.** {
    *** Companion;
}
-keepclasseswithmembers class com.ciphio.vault.** {
    kotlinx.serialization.KSerializer serializer(...);
}

# Keep data classes
-keep class com.ciphio.vault.data.** { *; }
-keep class com.ciphio.vault.passwordmanager.PasswordEntry { *; }
-keep class com.ciphio.vault.crypto.** { *; }

# Keep Compose
-keep class androidx.compose.** { *; }
-dontwarn androidx.compose.**

# Keep Datastore
-keep class androidx.datastore.** { *; }
-keepclassmembers class * extends androidx.datastore.preferences.protobuf.GeneratedMessageLite {
    <fields>;
}

# Keep Biometric
-keep class androidx.biometric.** { *; }

# Keep Autofill service
-keep class com.ciphio.vault.autofill.** { *; }
-keep class * extends android.service.autofill.AutofillService { *; }

# Keep BouncyCastle crypto
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Keep billing
-keep class com.android.billingclient.** { *; }

# General Android
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Prevent R8 from stripping interface information
-keepattributes Signature
-keepattributes Exceptions
