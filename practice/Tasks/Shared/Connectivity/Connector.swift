//
//  Connector.swift
//  CityGuide (shared by the iOS app and the watch app)
//
//  Created by David Procházka on 06.10.2026.
//

import Foundation
import Observation
import UIKit
import WatchConnectivity

// The same class on both sides. Each app creates one instance at start
// (see CityGuideApp and CityGuideWatchApp) -- before any data can arrive.
@MainActor @Observable
final class Connector: NSObject, WCSessionDelegate, ConnectorManaging {
    var isReachable = false         // is the other app running and connected now?

    // Called on the main actor for every place that arrives from the other device.
    @ObservationIgnored var onTaskReceived: (TaskItem) -> Void = { _ in }

    private let session = WCSession.default

    override init() {
        super.init()
        guard WCSession.isSupported() else { return }   // e.g. an iPad
        session.delegate = self
        session.activate()
    }

    // MARK: - Sending: live if possible, queued if not

    func send(_ task: TaskItem) {
        // is the session usable? sending in a non-activated session is an error
        guard session.activationState == .activated
        else { return }
        let message = message(from: task)
        if session.isReachable {        // live
            // @Sendable: the error handler is called on a background thread,
            // so it must not be isolated to the main actor (Swift 6 would crash)
            session.sendMessage(message,
                replyHandler: nil) { @Sendable error in
                print(error.localizedDescription)
            }
        } else {                        // queued (the Simulator does not support it)
            session.transferUserInfo(message)
        }
    }

    // MARK: - WCSessionDelegate
    // Watch Connectivity calls these methods on a background thread:
    // take the values out of the dictionary, then hop to the main actor.

    nonisolated func session(_ session: WCSession,
        activationDidCompleteWith state: WCSessionActivationState,
        error: (any Error)?) {
        if let error {
            print("Activation failed: \(error.localizedDescription)")
        }
        updateReachability(session.isReachable)
    }

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        updateReachability(session.isReachable)
    }

    nonisolated func session(_ session: WCSession,
        didReceiveMessage message: [String: Any]) {
        receive(message)
    }

    nonisolated func session(_ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any]) {
        receive(userInfo)
    }

#if os(iOS)
    // iOS only: the user may switch to another watch.
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) { }

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif

    // MARK: - MapItem <-> message
    // A message may contain property-list values only (String, numbers, Data, ...),
    // so the place is sent field by field.

    private func message(from task: TaskItem) -> [String: Any] {
        var message: [String: Any] = [
            "id": task.id.uuidString,
            "title": task.title,
            "taskDescription": task.taskDescription,
            "completionDate": task.completionDate,
            "completed": task.completed,
        ]
        return message
    }

    nonisolated private func receive(_ dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let taskDescription = dictionary["taskDescription"] as? String,
              let completionDate = dictionary["completionDate"] as? Date,
              let completed = dictionary["completed"] as? Bool
        else { return }

        Task { @MainActor in
            let task = TaskItem(
                id: UUID(uuidString: id) ?? UUID(),
                title: title,
                taskDescription: taskDescription,
                completionDate: completionDate,
                completed: completed
            )
            onTaskReceived(task)
        }
    }

    nonisolated private func updateReachability(_ reachable: Bool) {
        Task { @MainActor in
            isReachable = reachable
        }
    }

#if os(iOS)
    // preparingThumbnail(of:) is not available on watchOS -- the watch only receives.
    private func thumbnail(of image: UIImage, maxSide: CGFloat) -> UIImage? {
        let scale = min(1, maxSide / max(image.size.width, image.size.height))
        let size = CGSize(width: image.size.width * scale,
                          height: image.size.height * scale)
        return image.preparingThumbnail(of: size)
    }
#endif
}
