plugins {
    id("com.android.application")
    kotlin("android")
    id("org.jetbrains.kotlin.plugin.serialization")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.cryptatext"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.cryptatext"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        
        buildConfigField("boolean", "IS_BETA", "false")
    }

    signingConfigs {
        create("release") {
            // Load from local.properties or environment variables in a real project
            // storeFile = file("release.keystore")
            // storePassword = "password"
            // keyAlias = "release"
            // keyPassword = "password"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // signingConfig = signingConfigs.getByName("release")
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

