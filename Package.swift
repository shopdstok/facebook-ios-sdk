// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// @lint-ignore-every LICENSELINT

/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PackageDescription
import Foundation

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

enum BinarySource {
    case local, remote

    static var current: Self {
       if getenv("USE_LOCAL_FB_BINARIES") != nil {
            return .local
       } else {
           return .remote
       }
    }
}

struct BinaryTargets {
    let source: BinarySource

    var aem: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FBAEMKit",
                path: "build/XCFrameworks/Static/FBAEMKit.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FBAEMKit",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FBAEMKit-Static_XCFramework.zip",
                checksum: "9d973f21d19f2bebc4930740f9f037d887dac99b2e8ffb75a3293ddcd7132043"
            )
        }
    }

    var basics: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FBSDKCoreKit_Basics",
                path: "build/XCFrameworks/Static/FBSDKCoreKit_Basics.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FBSDKCoreKit_Basics",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FBSDKCoreKit_Basics-Static_XCFramework.zip",
                checksum: "5b4a5eef74b849b18415275fe50d285e61a20afdf83cb40ab70ea3ac3a451ebf"
            )
        }
    }

    var core: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FBSDKCoreKit",
                path: "build/XCFrameworks/Static/FBSDKCoreKit.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FBSDKCoreKit",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FBSDKCoreKit-Static_XCFramework.zip",
                checksum: "fa00f5376ad989d75559da001aa94c1e4bc5115c4ac882d31a66600aad76e772"
            )
        }
    }

    var login: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FBSDKLoginKit",
                path: "build/XCFrameworks/Static/FBSDKLoginKit.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FBSDKLoginKit",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FBSDKLoginKit-Static_XCFramework.zip",
                checksum: "27de971ebf8bac22066a27f44a442e6c082968cd3892658d95d7bc3bf50e3b74"
            )
        }
    }

    var share: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FBSDKShareKit",
                path: "build/XCFrameworks/Static/FBSDKShareKit.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FBSDKShareKit",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FBSDKShareKit-Static_XCFramework.zip",
                checksum: "9971023970ca2a2653e30cf88c0775b3f62c7f417debdf2d6c7cd370342fa638"
            )
        }
    }

    var gamingServices: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FacebookGamingServices",
                path: "build/XCFrameworks/Static/FacebookGamingServices.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FacebookGamingServices",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FacebookGamingServices-Static_XCFramework.zip",
                checksum: "55587186f8e3e66ad90c872811c9905ac77723f31e3323775456ba7d7288defd"
            )
        }
    }

    var fbsdkGamingServices: Target {
        switch source {
        case .local:
            return .binaryTarget(
                name: "FBSDKGamingServicesKit",
                path: "build/XCFrameworks/Static/FBSDKGamingServicesKit.xcframework"
            )
        case .remote:
            return .binaryTarget(
                name: "FBSDKGamingServicesKit",
                url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.2/FBSDKGamingServicesKit-Static_XCFramework.zip",
                checksum: "9078d869c616e201a65c015ac271882829ac499609bde59e35c971159eeccb93"
            )
        }
    }
}

let targets = BinaryTargets(source: .current)

let package = Package(
    name: "Facebook",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)
    ],
    products: [
         // The Kernel of the SDK. Must be included as a runtime dependency.
        .library(
            name: "FacebookBasics",
            targets: ["FBSDKCoreKit_Basics"]
        ),

        /*
          The Core SDK library that provides two importable modules:

            - FacebookCore which includes the most current interface and
              will contain interfaces for new features written in Swift

            - FBSDKCoreKit which contains legacy Objective-C interfaces
              that will be used to maintain backwards compatibility with
              types that have been converted to Swift.
              This will not contain interfaces for new features written in Swift.
        */
        .library(
            name: "FacebookCore",
            targets: ["FacebookCore", "FBSDKCoreKit"]
        ),

        //  The Facebook Login SDK
        .library(
            name: "FacebookLogin",
            targets: ["FacebookLogin"]
        ),

        //  The Facebook Share SDK
        .library(
            name: "FacebookShare",
            targets: ["FBSDKShareKit", "FacebookShare"]
        ),

        //  The Facebook Gaming Services SDK
        .library(
            name: "FacebookGamingServices",
            targets: ["FacebookGamingServices", "FBSDKGamingServicesKit"]
        ),

        // The Facebook AEM Kit
        .library(
            name: "FacebookAEM",
            targets: ["FBAEMKit", "FacebookAEM"]
        )
    ],
    targets: [
        // The kernel of the SDK
        targets.basics,

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        targets.aem,

        // The main AEM module
        .target(
          name: "FacebookAEM",
          dependencies: ["FBAEMKit"]
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        targets.core,

        // The main Core SDK module
        .target(
            name: "FacebookCore",
            dependencies: ["FacebookAEM", "FBSDKCoreKit_Basics", "FBSDKCoreKit"],
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedLibrary("z"),
                .linkedFramework("Accelerate")
            ]
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        targets.login,

        // The main Login SDK module
        .target(
            name: "FacebookLogin",
            dependencies: ["FacebookCore", "FBSDKLoginKit"]
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        targets.share,

        // The main Share SDK module
        .target(
            name: "FacebookShare",
            dependencies: ["FacebookCore", "FBSDKShareKit"]
        ),

        // The main Facebook Gaming Services module
        targets.gamingServices,

        /*
          Wrappers for backwards compatibility ObjC interfaces.
        */
        targets.fbsdkGamingServices,
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
