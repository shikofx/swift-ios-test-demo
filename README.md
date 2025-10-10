# swift-ios-test-demo

This repository serves as a comprehensive portfolio project demonstrating a wide range of skills in mobile test automation for iOS. The project is built around the "Sauce Demo" iOS application and showcases the creation of a robust and scalable test automation framework from scratch.

## Key Features & Technologies

This project is developed in stages, with each stage introducing new technologies and best practices.

### Core iOS Native Testing (`XCUITest`)

- **Unit Testing:** Foundational tests for business logic (`ViewModel`, services) and UI components (`UIViewController`) using `XCTest`.
- **Test Framework Architecture:** A scalable and maintainable framework built using Swift and `XCUITest`.
- **Design Patterns:** Implementation of the **Page Object Model (POM)** to create reusable and readable UI tests.
- **Abstraction Layer:** Custom wrappers and extensions for `XCUITest` to simplify test syntax and improve stability.
- **Snapshot Testing:** Integration of `SnapshotTesting` library to catch visual regressions in UI components.
- **Data Helpers & Services:** Tools for generating test data and interacting with APIs to set up preconditions.

### CI/CD & DevOps

- **GitHub Actions:** A complete CI/CD pipeline for building, linting, testing, and archiving the application.
- **GitLab CI:** A parallel CI/CD pipeline to demonstrate proficiency with different CI systems.
- **Static Analysis:** Integration of **SwiftLint** to enforce code style and conventions.
- **Reporting:** Integration with **Allure Report** to generate detailed and interactive test reports, published via GitHub/GitLab Pages.


This project aims to be a living document of best practices in iOS test automation, from foundational unit tests to complex end-to-end scenarios running in a CI/CD environment.