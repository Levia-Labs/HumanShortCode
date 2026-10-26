plugins {
    kotlin("jvm") version "2.0.21"
}

group = "io.github.levia-labs"
version = "2.0.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

kotlin {
    jvmToolchain(21)
}

tasks.test {
    useJUnitPlatform()
    testLogging { events("failed") }
}
