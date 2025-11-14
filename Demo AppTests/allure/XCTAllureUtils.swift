//
//  XCTestExtension.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 18.10.25.
//

import XCTest

func feature(_ values: String...) {
    label(name: "feature", values: values)
}

func epic(_ values: String...) {
    label(name: "epic", values: values)
}

func story(_ values: String...) {
    label(name: "story", values: values)
}

func id(_ values: String...) {
    label(name: "id", values: values)
}

func severity(_ values: String...) {
    label(name: "severity", values: values)
}

func step<T>(_ name: String, step: () -> T) -> T {
    return XCTContext.runActivity(named: name) { _ in
        return step()
    }
}

func step(_ name: String, step: () -> Void) {
    XCTContext.runActivity(named: name) { _ in
        step()
    }
}

func link(_ value: String) {
    links(name: value, values: ["https://github.com/dparkheychuk/SDET-Demo-App/testCase/\(value)"])
}

func given(_ desc: String = "", _block block: @MainActor (any XCTActivity) -> Void) {
    XCTContext.runActivity(named: "Given \(desc)", block: block)
}

func when(_ desc: String = "", _block block: @MainActor (any XCTActivity) -> Void) {
    XCTContext.runActivity(named: "When \(desc)", block: block)
}

func then(_ desc: String = "", _block block: @MainActor (any XCTActivity) -> Void) {
    XCTContext.runActivity(named: "Then \(desc)", block: block)
}

private func label(name: String, values: [String]) {
    for value in values {
        XCTContext.runActivity(named: "allure.label.\(name):\(value)", block: {_ in})
    }
}

private func links(name: String, values: [String]) {
    for value in values {
        XCTContext.runActivity(named: "allure.link.\(value)", block: {_ in})
    }
}
