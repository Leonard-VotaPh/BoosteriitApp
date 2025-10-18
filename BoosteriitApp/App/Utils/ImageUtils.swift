import SwiftUI
import UIKit
import CryptoKit

enum ImageUtils {
    /// Returns whether the string is a data URL (starts with "data:")
    static func isDataURL(_ value: String) -> Bool {
        return value.hasPrefix("data:")
    }

    /// Decode a Data URL (data:[<mediatype>][;base64],<data>) and return a UIImage if successful.
    /// - Parameter dataURL: full data URL string from JSON (e.g. "data:image/jpeg;base64,/9j/4AAQ...")
    static func uiImage(fromDataURL dataURL: String) -> UIImage? {
        guard let commaIndex = dataURL.firstIndex(of: ",") else { return nil }
        let base64Part = String(dataURL[dataURL.index(after: commaIndex)...])
        guard let data = Data(base64Encoded: base64Part, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: data)
    }

    /// Convenience: return a SwiftUI Image from a data URL string
    static func imageFromDataURL(_ dataURL: String) -> Image? {
        if let ui = uiImage(fromDataURL: dataURL) {
            return Image(uiImage: ui)
        }
        return nil
    }

    // MARK: - Disk cache for data URLs

    private static var cacheDirectory: URL {
        let tmp = FileManager.default.temporaryDirectory
        let dir = tmp.appendingPathComponent("BoosteriitImageCache", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    private static func sha256Hex(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Parse MIME type from a data URL like "data:image/jpeg;base64,...". Returns e.g. "image/jpeg" or nil.
    private static func mimeType(fromDataURL dataURL: String) -> String? {
        guard dataURL.hasPrefix("data:") else { return nil }
        let afterData = dataURL.dropFirst(5) // remove "data:"
        if let semicolon = afterData.firstIndex(of: ";") {
            return String(afterData[..<semicolon])
        }
        return nil
    }

    /// Return file extension for common image mime types
    private static func fileExtension(for mime: String?) -> String {
        guard let mime = mime else { return "bin" }
        if mime.contains("jpeg") || mime.contains("jpg") { return "jpg" }
        if mime.contains("png") { return "png" }
        if mime.contains("gif") { return "gif" }
        return "bin"
    }

    /// Decode a data URL and write to disk cache. Returns a file URL if successful (cached or newly written).
    static func cachedFileURL(fromDataURL dataURL: String) -> URL? {
        let key = sha256Hex(dataURL)
        let ext = fileExtension(for: mimeType(fromDataURL: dataURL))
        let fileURL = cacheDirectory.appendingPathComponent("\(key).\(ext)")

        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }

        // decode base64 and write
        guard let commaIndex = dataURL.firstIndex(of: ",") else { return nil }
        let base64Part = String(dataURL[dataURL.index(after: commaIndex)...])
        guard let data = Data(base64Encoded: base64Part, options: .ignoreUnknownCharacters) else { return nil }

        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            // If writing fails, return nil
            return nil
        }
    }

    /// Clear disk cache (for debugging / storage control)
    static func clearCache() {
        let dir = cacheDirectory
        if FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.removeItem(at: dir)
        }
    }
}
