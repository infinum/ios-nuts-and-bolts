//
//  ServerTrustPolicyManager.swift
//  Loggie
//
//  Created by Filip Bec on 05/02/2018.
//  Source: Alamofire - https://github.com/Alamofire/Alamofire
//

import UIKit

@objc(LGServerTrustPolicy)
public protocol ServerTrustPolicy: NSObjectProtocol {
    func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool
}

public extension ServerTrustPolicy {

    public func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false

        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)

        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed


            isValid = result == unspecified || result == proceed
        }
        return isValid
    }
}

extension ServerTrustPolicy {

    static func certificateData(for trust: SecTrust) -> [Data] {
        var certificates: [SecCertificate] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                certificates.append(certificate)
            }
        }

        return certificateData(for: certificates)
    }

    static func certificateData(for certificates: [SecCertificate]) -> [Data] {
        return certificates.map { SecCertificateCopyData($0) as Data }
    }

    static func certificates(from certificatesData: [Data]) -> [SecCertificate] {
        return certificatesData.map({ data -> SecCertificate in
            guard let certificate = SecCertificateCreateWithData(kCFAllocatorDefault, data as CFData) else {
                preconditionFailure("Invalid certificate data")
            }
            return certificate
        })
    }

    static func publicKeys(from certificatesData: [Data]) -> [SecKey] {
        let certificates = PinPublicKeys.certificates(from: certificatesData)
        return certificates.compactMap({ (cert) -> SecKey? in
            guard let publicKey = PinPublicKeys.publicKey(for: cert) else {
                preconditionFailure("Invalid public key")
            }
            return publicKey
        })
    }

    static func publicKeys(for trust: SecTrust) -> [SecKey] {
        var publicKeys: [SecKey] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if
                let certificate = SecTrustGetCertificateAtIndex(trust, index),
                let publicKey = publicKey(for: certificate)
            {
                publicKeys.append(publicKey)
            }
        }

        return publicKeys
    }

    static func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }

        return publicKey
    }
}


public class DefaultEvaluation: NSObject, ServerTrustPolicy {
    private let validateHost: Bool

    public init(validateHost: Bool) {
        self.validateHost = validateHost
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
        SecTrustSetPolicies(serverTrust, policy)
        return trustIsValid(serverTrust)
    }
}

public class PinCertificates: NSObject, ServerTrustPolicy {
    private let pinnedCertificates: [SecCertificate]
    private let validateCertificateChain: Bool
    private let validateHost: Bool

    @nonobjc public init(certificates: [SecCertificate], validateCertificateChain: Bool, validateHost: Bool) {
        self.pinnedCertificates = certificates
        self.validateCertificateChain = validateCertificateChain
        self.validateHost = validateHost
    }

    public init(certificatesData: [Data], validateCertificateChain: Bool, validateHost: Bool) {
        self.validateCertificateChain = validateCertificateChain
        self.validateHost = validateHost
        self.pinnedCertificates = PinCertificates.certificates(from: certificatesData)
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        if validateCertificateChain {
            let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            SecTrustSetPolicies(serverTrust, policy)

            SecTrustSetAnchorCertificates(serverTrust, pinnedCertificates as CFArray)
            SecTrustSetAnchorCertificatesOnly(serverTrust, true)
            return trustIsValid(serverTrust)
        } else {
            let serverCertificatesDataArray = PinCertificates.certificateData(for: serverTrust)
            let pinnedCertificatesDataArray = PinCertificates.certificateData(for: pinnedCertificates)

            for serverCertificateData in serverCertificatesDataArray {
                for pinnedCertificateData in pinnedCertificatesDataArray {
                    if serverCertificateData == pinnedCertificateData {
                        return true
                    }
                }
            }
        }
        return false
    }
}

public class PinPublicKeys: NSObject, ServerTrustPolicy {
    private let pinnedPublicKeys: [SecKey]
    private let validateCertificateChain: Bool
    private let validateHost: Bool

    @nonobjc public init(publicKeys: [SecKey], validateCertificateChain: Bool, validateHost: Bool) {
        self.pinnedPublicKeys = publicKeys
        self.validateCertificateChain = validateCertificateChain
        self.validateHost = validateHost
    }

    public init(certificatesData: [Data], validateCertificateChain: Bool, validateHost: Bool) {
        self.pinnedPublicKeys = PinPublicKeys.publicKeys(from: certificatesData)
        self.validateCertificateChain = validateCertificateChain
        self.validateHost = validateHost
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        var certificateChainEvaluationPassed = true

        if validateCertificateChain {
            let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            SecTrustSetPolicies(serverTrust, policy)

            certificateChainEvaluationPassed = trustIsValid(serverTrust)
        }

        if certificateChainEvaluationPassed {
            for serverPublicKey in PinPublicKeys.publicKeys(for: serverTrust) as [AnyObject] {
                for pinnedPublicKey in pinnedPublicKeys as [AnyObject] {
                    if serverPublicKey.isEqual(pinnedPublicKey) {
                        return true
                    }
                }
            }
        }
        return false
    }
}

public class RevokedEvaluation: NSObject, ServerTrustPolicy {
    let validateHost: Bool
    let revocationFlags: CFOptionFlags

    public init(validateHost: Bool, revocationFlags: CFOptionFlags) {
        self.validateHost = validateHost
        self.revocationFlags = revocationFlags
    }

    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        let defaultPolicy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
        let revokedPolicy = SecPolicyCreateRevocation(revocationFlags)
        SecTrustSetPolicies(serverTrust, [defaultPolicy, revokedPolicy] as CFTypeRef)

        return trustIsValid(serverTrust)
    }
}

public class DisableEvaluation: NSObject, ServerTrustPolicy {
    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        return true
    }
}

/// Responsible for managing the mapping of `ServerTrustPolicy` objects to a given host.
@objc(LGServerTrustPolicyManager)
open class ServerTrustPolicyManager: NSObject {
    /// The dictionary of policies mapped to a particular host.
    public let policies: [String: ServerTrustPolicy]

    public init(policies: [String: ServerTrustPolicy]) {
        self.policies = policies
    }

    public func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return policies[host]
    }
}
