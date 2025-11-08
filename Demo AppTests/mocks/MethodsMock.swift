//
//  MethodsMock.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 4.11.25.
//
@testable import SDET_Demo_App

class MethodsMock: AlertPresenter {
    var showAlertCalled = false
    var alertMessage: String?

    func showAlertMessage(vc: UIViewController, title: NSString, message: NSString) {
        showAlertCalled = vc.isViewLoaded
        alertMessage = message as String
    }
}
