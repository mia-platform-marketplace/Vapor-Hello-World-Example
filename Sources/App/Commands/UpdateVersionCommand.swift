import Foundation
import Vapor

private enum RuntimeError: Swift.Error {
    case invalidVersion(String)
}

struct UpdateVersionCommand: Command {
    struct Signature: CommandSignature {
        @Option(name: "number", help: "The new version number.")
        var number: String?

        @Flag(name: "patch", help: "Update version with a patch version.")
        var patch: Bool

        @Flag(name: "minor", help: "Update version with a minor version.")
        var minor: Bool

        @Flag(name: "major", help: "Update version with a major version.")
        var major: Bool
    }

    var help: String {
        "Update the package version."
    }

    func run(using context: CommandContext, signature: Signature) throws {
        var newVersion = ""
        do {
            newVersion = try getNewVersion(context: context, signature: signature)
            try Shell.run(command: "git tag v\(newVersion)")
            context.console.print("✅ Tagged v\(newVersion)")
            try Shell.run(command: "./scripts/update-changelog.sh \(newVersion)")
            context.console.print("📝 Changelog updated with v\(newVersion)")
        } catch RuntimeError.invalidVersion(let message), // swiftlint:disable indentation_width
                Shell.Error.commandFailure(let message) {
            context.console.error(message)
        } catch {
            context.console.error("Unexpected error: \(error.localizedDescription)")
        }
    }

    private func getNewVersion(context: CommandContext, signature: Signature) throws -> String {
        // Get latest version
        var latestVersion = try Shell.run(command: "git describe --tags $(git rev-list --tags --max-count=1)")
        var prohibitedCharacters = CharacterSet.letters
        prohibitedCharacters.formUnion(.controlCharacters)
        prohibitedCharacters.formUnion(.whitespaces)
        prohibitedCharacters.formUnion(.symbols)
        latestVersion = latestVersion.trimmingCharacters(in: prohibitedCharacters)

        // Calculate new version
        var newVersion: String
        let latestVersionComponents = latestVersion.components(separatedBy: ".")

        if let number = signature.number {
            // swiftlint:disable force_try
            let versionRegex = try! NSRegularExpression(pattern: "[0-9]+.[0-9]+.[0-9]+.*")
            let range = NSRange(location: 0, length: number.utf8.count)
            if versionRegex.firstMatch(in: number, options: [], range: range) != nil {
                newVersion = number
            } else {
                throw RuntimeError.invalidVersion("Unable to proceed: \(number) is not in a valid version format.")
            }
        } else {
            // swiftlint:disable indentation_width
            guard let patch = Int(latestVersionComponents[2]),
                  let minor = Int(latestVersionComponents[1]),
                  let major = Int(latestVersionComponents[0])
            else {
                throw RuntimeError.invalidVersion(
                    "Unable to proceed: latest version \(latestVersion) is not in a valid format."
                )
            }
            if signature.patch {
                newVersion = "\(latestVersionComponents[0]).\(latestVersionComponents[1]).\(patch + 1)"
            } else if signature.minor {
                newVersion = "\(latestVersionComponents[0]).\(minor + 1).0"
            } else if signature.major {
                newVersion = "\(major + 1).0.0"
            } else {
                throw RuntimeError.invalidVersion("Not enough information provided. See help for more information.")
            }
        }

        return newVersion
    }
}

private enum Shell {
    enum Error: Swift.Error {
        case commandFailure(String)
    }

    @discardableResult
    static func run(command: String) throws -> String {
        var result: Result<String, Shell.Error> = .failure(.commandFailure("Unable to execute \(command)"))

        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        task.standardOutput = Pipe()
        task.standardError = Pipe()
        task.terminationHandler = { process in
            // swiftlint:disable force_cast
            let stdOut = process.standardOutput as! Pipe
            let stdErr = process.standardError as! Pipe

            if process.terminationStatus == 0 {
                let data = stdOut.fileHandleForReading.readDataToEndOfFile()
                if let commandOutput = String(data: data, encoding: .utf8) {
                    result = .success(commandOutput)
                } else {
                    result = .failure(.commandFailure("Unable to decode \(command) output"))
                }
            } else {
                let data = stdErr.fileHandleForReading.readDataToEndOfFile()
                if let errorString = String(data: data, encoding: .utf8) {
                    result = .failure(.commandFailure(errorString))
                } else {
                    result = .failure(.commandFailure("Unable to decode \(command) error message"))
                }
            }
        }

        try task.run()
        task.waitUntilExit()

        switch result {
        case .success(let commandOutput):
            return commandOutput
        case .failure(let error):
            throw error
        }
    }
}
