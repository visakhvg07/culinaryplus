// Top-level build file where you can add configuration options common to all sub-projects/modules.

plugins {
    id("com.android.application") apply false  // Remove version to avoid conflict
    id("org.jetbrains.kotlin.android") apply false
    id("com.google.gms.google-services") apply false // Firebase
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
