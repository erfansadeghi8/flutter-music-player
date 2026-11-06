import org.gradle.api.initialization.resolve.RepositoriesMode

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use {
            properties.load(it)
        }
        val sdkPath = properties.getProperty("flutter.sdk")
        require(!sdkPath.isNullOrBlank()) {
            "flutter.sdk is not set in android/local.properties"
        }
        sdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

   repositories {
    google()
    mavenCentral()
    maven("https://storage.googleapis.com/download.flutter.io")
}

    resolutionStrategy {
        eachPlugin {
            if (requested.id.id == "com.android.application") {
                useModule("com.android.tools.build:gradle:${requested.version}")
            }

            if (requested.id.id == "com.google.gms.google-services") {
                useModule("com.google.gms:google-services:${requested.version}")
            }
        }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    //id("com.google.firebase.crashlytics") version "3.0.2" apply false
}


dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)

    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
    }
}
include(":app")