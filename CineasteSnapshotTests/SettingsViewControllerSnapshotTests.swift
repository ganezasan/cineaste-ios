//
//  SettingsViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

@testable import Cineaste_App
import XCTest
import SnapshotTesting

class SettingsViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        let viewController = SettingsViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // Then
        assertViewSnapshot(matching: navigationController)
    }
}