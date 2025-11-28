// Workaround for Java 25.0.1 compatibility with Kotlin
// This script patches the Java version detection

gradle.settingsEvaluated {
    // Set system property to make Kotlin think we're using Java 21
    System.setProperty("java.version", "21.0.0")
}

