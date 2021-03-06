//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSCore

public class AmplifyAWSServiceConfiguration: AWSServiceConfiguration {
    private static let version = "1.1.1"

    override public class func baseUserAgent() -> String! {
        //TODO: Retrieve this version from a centralized location:
        //https://github.com/aws-amplify/amplify-ios/issues/276
        let platformInfo = AmplifyAWSServiceConfiguration.platformInformation()
        let systemName = UIDevice.current.systemName.replacingOccurrences(of: " ", with: "-")
        let systemVersion = UIDevice.current.systemVersion
        let localeIdentifier = Locale.current.identifier
        return "\(platformInfo) \(systemName)/\(systemVersion) \(localeIdentifier)"
    }

    override public var userAgent: String {
        return AmplifyAWSServiceConfiguration.baseUserAgent()
    }

    override public func copy(with zone: NSZone? = nil) -> Any {
        return super.copy(with: zone)
    }

    override init() {
        super.init(region: .Unknown, credentialsProvider: nil)
    }

    override public init(region regionType: AWSRegionType,
                         credentialsProvider: AWSCredentialsProvider) {
        super.init(region: regionType, credentialsProvider: credentialsProvider)
    }

    public init(region regionType: AWSRegionType) {
        super.init(region: regionType, credentialsProvider: nil)
    }
}

extension AmplifyAWSServiceConfiguration {

    static var platformMapping: [Platform: String] = [:]

    public static func addUserAgentPlatform(_ platform: Platform, version: String) {
        platformMapping[platform] = version
    }

    public enum Platform: String {
        case flutter = "amplify-flutter"
    }

    static func platformInformation() -> String {
        var platformTokens = platformMapping.map { "\($0.rawValue)/\($1)" }
        platformTokens.append("amplify-iOS/\(version)")
        return platformTokens.joined(separator: " ")
    }
}
