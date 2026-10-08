import org.gradle.api.initialization.resolve.RepositoriesMode
pluginManagement {
    val flutterSdkPath =
        file("local.properties")
            .readLines()
            .firstOrNull { it.startsWith("flutter.sdk=") }
            ?.substringAfter("=")
            ?: error("flutter.sdk not found in local.properties")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
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
    id("com.google.firebase.crashlytics") version "3.0.2" apply false
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)

    val storageUrl: String =
        System.getenv("FLUTTER_STORAGE_BASE_URL") ?: "https://storage.googleapis.com"

    repositories {
        google()
        mavenCentral()
        maven("$storageUrl/download.flutter.io")
    }
}

include(":app")