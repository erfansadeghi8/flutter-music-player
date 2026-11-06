plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.music_player"
    ndkVersion = "28.2.13676358"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.music_player"
        minSdk = flutter.minSdkVersion
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

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

// ساخت کپی APK با نام Lyra.apk
tasks.register("renameReleaseApk") {
    dependsOn("assembleRelease")

    doLast {
        val outputDir = layout.buildDirectory
            .dir("outputs/flutter-apk")
            .get()
            .asFile

        val sourceFile = outputDir.resolve("app-release.apk")
        val targetFile = outputDir.resolve("Lyra.apk")

        if (sourceFile.exists()) {
            sourceFile.copyTo(targetFile, overwrite = true)
            println("APK created: ${targetFile.absolutePath}")
        } else {
            error("Release APK not found: ${sourceFile.absolutePath}")
        }
    }
}

// ساخت کپی AAB با نام Lyra.aab
tasks.register("renameReleaseAab") {
    dependsOn("bundleRelease")

    doLast {
        val outputDir = layout.buildDirectory
            .dir("outputs/bundle/release")
            .get()
            .asFile

        val sourceFile = outputDir.resolve("app-release.aab")
        val targetFile = outputDir.resolve("Lyra.aab")

        if (sourceFile.exists()) {
            sourceFile.copyTo(targetFile, overwrite = true)
            println("AAB created: ${targetFile.absolutePath}")
        } else {
            error("Release AAB not found: ${sourceFile.absolutePath}")
        }
    }
}