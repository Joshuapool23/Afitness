plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase Plugin
}

android {
    namespace = "com.example.advweb_1"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.advweb_1"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")

    // Firebase Authentication
    implementation("com.google.firebase:firebase-auth-ktx:22.1.1")

    // Firebase Firestore (for storing user data)
    implementation("com.google.firebase:firebase-firestore-ktx:24.10.0")

    // Firebase Realtime Database (optional)
    implementation("com.google.firebase:firebase-database-ktx:20.3.1")

    // Firebase Storage (for profile pictures, etc.)
    implementation("com.google.firebase:firebase-storage-ktx:20.3.0")
}
