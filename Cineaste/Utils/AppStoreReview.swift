//
//  AppStoreReview.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 10.06.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation
import StoreKit

// see here for details
// https://developer.apple.com/documentation/storekit/skstorereviewcontroller

enum AppStoreReview {

    private static var processCompletedCounter: Int {
        var count = UserDefaults.standard.processCompletedCount
        count += 1
        UserDefaults.standard.processCompletedCount = count

        return count
    }

    static func requestReview() {
        // do not ask for appStore Review in UITest
        #if DEBUG
        guard !ProcessInfo().arguments.contains("UI_TEST") else { return }
        #endif

        guard let currentBuildVersion = Bundle.main
            .object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return }

        let canShowRequest = AppStoreReview.processCompletedCounter % 4 == 0
            && currentBuildVersion != UserDefaults.standard.lastVersionPromptedForReview

        if canShowRequest {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.lastVersionPromptedForReview = currentBuildVersion
            }
        }
    }

    static func openWriteReviewURL() {
        let writeReviewUrl = "\(Constants.appStoreUrl)?action=write-review"
        guard let writeReviewURL = URL(string: writeReviewUrl)
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}
