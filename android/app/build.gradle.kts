plugins {
    id("com.android.application")
    kotlin("android")
    id("org.jetbrains.kotlin.plugin.serialization")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.ciphio.vault"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.ciphio.vault"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0-beta.1"
        
        buildConfigField("boolean", "IS_BETA", "true")
    }

    signingConfigs {
        create("release") {
            val keystorePath = System.getenv("CIPHIO_KEYSTORE_PATH") ?: project.findProperty("CIPHIO_KEYSTORE_PATH") as String?
            val keystorePass = System.getenv("CIPHIO_KEYSTORE_PASSWORD") ?: project.findProperty("CIPHIO_KEYSTORE_PASSWORD") as String?
            val keyAliasName = System.getenv("CIPHIO_KEY_ALIAS") ?: project.findProperty("CIPHIO_KEY_ALIAS") as String?
            val keyPass = System.getenv("CIPHIO_KEY_PASSWORD") ?: project.findProperty("CIPHIO_KEY_PASSWORD") as String?
            
            if (keystorePath != null && keystorePass != null && keyAliasName != null && keyPass != null) {
                storeFile = file(keystorePath)
                storePassword = keystorePass
                keyAlias = keyAliasName
                keyPassword = keyPass
            }
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs = listOf(
            "-opt-in=kotlin.RequiresOptIn",
            "-opt-in=androidx.compose.material3.ExperimentalMaterial3Api"
        )
    }

    buildFeatures {
        compose = true
        buildConfig = true
    }

    // Compose Compiler is now a plugin in Kotlin 2.0
    // No need for composeOptions.kotlinCompilerExtensionVersion

    packaging {
        resources.excludes.add("META-INF/versions/9/OSGI-INF/MANIFEST.MF")
    }
    
    testOptions {
        unitTests {
            isReturnDefaultValues = true
        }
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2024.05.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.activity:activity-compose:1.9.2")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.6")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.6")
    implementation("androidx.navigation:navigation-compose:2.7.7")
    implementation("androidx.datastore:datastore-preferences:1.1.1")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.3")
    implementation("commons-codec:commons-codec:1.16.0")
    implementation("org.bouncycastle:bcprov-jdk18on:1.78.1")
    implementation("com.google.android.material:material:1.13.0")
    implementation("androidx.biometric:biometric:1.1.0")
    implementation("com.android.billingclient:billing-ktx:7.1.1")

    debugImplementation("androidx.compose.ui:ui-tooling")
    
    // Test dependencies
    testImplementation("junit:junit:4.13.2")
    testImplementation("com.google.truth:truth:1.4.2")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.7.3")
    testImplementation("androidx.datastore:datastore-preferences:1.1.1")
    
    // AndroidTest dependencies
    androidTestImplementation("androidx.compose.ui:ui-test-junit4")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
}

