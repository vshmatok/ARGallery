//
//  FileSystemService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/23/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

// MARK: - Directories

enum Directory: String, CaseIterable {
    case image
}

final class FileSystemService {
    func createDirectoriesIfNeeded() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectoryURL = urls.last else {
            print(FileSystemError.couldNotGetURL.errorDescription)
            return
        }
        for directory in Directory.allCases {
            let directoryURL = documentDirectoryURL.appendingPathComponent(directory.rawValue)
            if !FileManager.default.fileExists(atPath: directoryURL.path) {
                do {
                    try FileManager.default.createDirectory(at: directoryURL,
                                                            withIntermediateDirectories: false,
                                                            attributes: nil)
                } catch {
                    print("\(#file), \(#function), line \(#line): \(error.localizedDescription)")
                }
            }
        }
    }

    func getAllFilesFrom(directory: Directory) -> [URL] {
        guard let directoryURL = getURL(for: directory) else {
            return []
        }

        do {
            let folderContent = try FileManager.default.contentsOfDirectory(at: directoryURL,
                                                                            includingPropertiesForKeys: nil,
                                                                            options: .skipsHiddenFiles)
            return folderContent
        } catch {
            print("\(#file), \(#function), line \(#line): \(error.localizedDescription)")
            return []
        }
    }

    func delete(directory: Directory) {
        guard let directoryURL = getURL(for: directory) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: directoryURL)
        } catch {
            print("\(#file), \(#function), line \(#line): \(error.localizedDescription)")
        }
    }

    func saveData(uploadModel: UploadModel, to directory: Directory) {
        guard let fileURL = getURL(for: directory)?.appendingPathComponent(uploadModel.fileName) else {
            return
        }

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try uploadModel.fileData.write(to: fileURL)
            } catch {
                print("\(#file), \(#function), line \(#line): \(error.localizedDescription)")
            }
        }
    }

    func getURL(for directory: Directory) -> URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectoryURL = urls.last else {
            print("\(#file), \(#function), line \(#line): \(FileSystemError.couldNotGetURL.errorDescription)")
            return nil
        }

        return documentDirectoryURL.appendingPathComponent(directory.rawValue)
    }
}
