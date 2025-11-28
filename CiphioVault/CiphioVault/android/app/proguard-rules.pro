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

# Keep ALL app classes - be aggressive to prevent crashes
-keep class com.ciphio.vault.** { *; }
-keepclassmembers class com.ciphio.vault.** { *; }

# Keep data classes
-keep class com.ciphio.vault.data.** { *; }
-keep class com.ciphio.vault.passwordmanager.** { *; }
-keep class com.ciphio.vault.crypto.** { *; }
-keep class com.ciphio.vault.ui.** { *; }
-keep class com.ciphio.vault.premium.** { *; }

# Keep ViewModels and Factories
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keep class * extends androidx.lifecycle.ViewModelFactory { *; }
-keep class com.ciphio.vault.***Factory { *; }

# Keep extension properties (like ciphioDataStore)
-keepclassmembers class * {
    @kotlin.jvm.JvmStatic <methods>;
}

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
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes AnnotationDefault

# Keep BuildConfig
-keep class com.ciphio.vault.BuildConfig { *; }

# Keep companion objects
-keepclassmembers class * {
    static ** Companion;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}
