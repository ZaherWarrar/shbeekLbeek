buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // سطر الربط مع Firebase
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        // dl.google.com returns 404 for some AndroidX files on this network.
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://repo.huaweicloud.com/repository/maven/") }
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Plugins such as firebase_core still compile against SDK 34. AGP 8.9 then
// fails verifyReleaseResources because AndroidX core resources are linked
// under the plugin package. Match the app compile SDK (Flutter 3.41 = 36).
// Registered before evaluationDependsOn so the hook exists even if :app
// evaluates plugin projects early.
gradle.beforeProject {
    if (this == rootProject) return@beforeProject
    afterEvaluate {
        if (!plugins.hasPlugin("com.android.library")) return@afterEvaluate
        val android = extensions.findByName("android") ?: return@afterEvaluate
        val setCompileSdk = android.javaClass.methods.firstOrNull { method ->
            method.name == "setCompileSdk" &&
                method.parameterTypes.size == 1 &&
                method.parameterTypes[0] == Int::class.javaPrimitiveType
        }
        setCompileSdk?.invoke(android, 36)
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
