plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin must be applied after Android & Kotlin
    id("com.google.gms.google-services") // Firebase services (if used)
}

android {
    namespace = "com.example.culinary"
    compileSdk = 34 // Explicitly set

    defaultConfig {
        applicationId = "com.example.culinary"
        minSdk = 23 // ✅ Changed from 21 to 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true  // ✅ Enable code shrinking
            isShrinkResources = true  // ✅ Correct way to enable `shrinkResources`

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.9.0") // ✅ Ensure Material Components are included
}
