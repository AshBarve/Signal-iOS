//
// Copyright 2022 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

@objc
public class SystemStoryManagerMock: NSObject, SystemStoryManagerProtocol {

    /// In tests, set some other handler to this to return different results when the system under test calls enqueueOnboardingStoryDownload
    public lazy var downloadOnboardingStoryHandler: () -> Promise<Void> = {
        return .value(())
    }

    public func enqueueOnboardingStoryDownload() -> Promise<Void> {
        return downloadOnboardingStoryHandler()
    }

    /// In tests, set some other handler to this to return different results when the system under test calls cleanUpOnboardingStoryIfNeeded
    public lazy var cleanUpOnboardingStoryHandler: () -> Promise<Void> = {
        return .value(())
    }

    public func cleanUpOnboardingStoryIfNeeded() -> Promise<Void> {
        return cleanUpOnboardingStoryHandler()
    }

    public var isOnboardingStoryRead: Bool = false

    public func isOnboardingStoryRead(transaction: SDSAnyReadTransaction) -> Bool {
        return isOnboardingStoryRead
    }

    public var isOnboardingStoryViewed: Bool = false

    public func isOnboardingStoryViewed(transaction: SDSAnyReadTransaction) -> Bool {
        return isOnboardingStoryViewed
    }

    public func setHasReadOnboardingStory(transaction: SDSAnyWriteTransaction, updateStorageService: Bool) {
        return
    }

    public func setHasViewedOnboardingStory(source: OnboardingStoryViewSource, transaction: SDSAnyWriteTransaction) {
        return
    }

    public var isOnboardingOverlayViewed: Bool = false
    public func isOnboardingOverlayViewed(transaction: SDSAnyReadTransaction) -> Bool {
        return isOnboardingOverlayViewed
    }

    public func setOnboardingOverlayViewed(value: Bool, transaction: SDSAnyWriteTransaction) {
        return
    }

    public func addStateChangedObserver(_ observer: SystemStoryStateChangeObserver) {
        fatalError("Unimplemented for tests")
    }

    public func removeStateChangedObserver(_ observer: SystemStoryStateChangeObserver) {
        fatalError("Unimplemented for tests")
    }

    public var areSystemStoriesHidden: Bool = false

    public func areSystemStoriesHidden(transaction: SDSAnyReadTransaction) -> Bool {
        return areSystemStoriesHidden
    }

    public func setSystemStoriesHidden(_ hidden: Bool, transaction: SDSAnyWriteTransaction) {
        fatalError("Unimplemented for tests")
    }
}

public class OnboardingStoryManagerFilesystemMock: OnboardingStoryManagerFilesystem {

    public override class func fileOrFolderExists(url: URL) -> Bool {
        return true
    }

    public override class func fileSize(of: URL) -> NSNumber? {
        return NSNumber(value: 100)
    }

    public override class func deleteFile(url: URL) throws {
        return
    }

    public override class func moveFile(from fromUrl: URL, to toUrl: URL) throws {
        return
    }

    public override class func isValidImage(at url: URL, mimeType: String?) -> Bool {
        return true
    }
}

public class OnboardingStoryManagerStoryMessageFactoryMock: OnboardingStoryManagerStoryMessageFactory {

    public override class func createFromSystemAuthor(
        attachmentSource: TSResourceDataSource,
        timestamp: UInt64,
        transaction: SDSAnyWriteTransaction
    ) throws -> StoryMessage {
        return try StoryMessage.createAndInsert(
            timestamp: timestamp,
            authorAci: StoryMessage.systemStoryAuthor,
            groupId: nil,
            manifest: StoryManifest.incoming(
                receivedState: StoryReceivedState(
                    allowsReplies: false,
                    receivedTimestamp: timestamp,
                    readTimestamp: nil,
                    viewedTimestamp: nil
                )
            ),
            replyCount: 0,
            attachmentBuilder: .withoutFinalizer(.foreignReferenceAttachment),
            mediaCaption: nil,
            shouldLoop: false,
            transaction: transaction
        )
    }

    public override class func validateAttachmentContents(
        dataSource: any DataSource,
        mimeType: String
    ) throws -> TSResourceDataSource {
        return .from(
            dataSource: dataSource,
            mimeType: mimeType,
            caption: nil,
            renderingFlag: .default
        )
    }
}
