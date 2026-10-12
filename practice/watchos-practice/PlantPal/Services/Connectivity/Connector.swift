//
//  Untitled.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import Foundation
import Observation
import UIKit
import WatchConnectivity

// The same class on both sides. Each app creates one instance at start
// (see CityGuideApp and CityGuideWatchApp) -- before any data can arrive.
@MainActor @Observable
final class Connector: NSObject, WCSessionDelegate, WatchConnecting {
    var isReachable = false         // is the other app running and connected now?

    // Called on the main actor for every place that arrives from the other device.
    @ObservationIgnored var onPlantReceived: (Plant) -> Void = { _ in }
    @ObservationIgnored var onWateredReceived: (UUID, Date) -> Void = { _, _ in }

    private let session = WCSession.default

    override init() {
        super.init()
        guard WCSession.isSupported() else { return }   // e.g. an iPad
        session.delegate = self
        session.activate()
    }

    // MARK: - Sending: live if possible, queued if not

    func send(_ plant: Plant) {
        transfer(message(from: plant))
    }

    func sendWatered(plantId: UUID, date: Date) {
        transfer(["kind": "watered", "id": plantId.uuidString, "date": date])
    }

    private func transfer(_ message: [String: Any]) {
        // is the session usable? sending in a non-activated session is an error
        guard session.activationState == .activated
        else { return }
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

    private func message(from plant: Plant) -> [String: Any] {
        var message: [String: Any] = [
            "kind": "plant",
            "id": plant.id.uuidString,
            "name": plant.name,
            "room": Int(plant.room.rawValue),
            "isOutdoor": plant.isOutdoor,
            "interval": plant.wateringIntervalDays,
            "lastWatered": plant.lastWatered,
            "latitude": plant.coordinate.latitude,
            "longitude": plant.coordinate.longitude
        ]
        return message
    }

    nonisolated private func receive(_ dictionary: [String: Any]) {
        guard let kind = dictionary["kind"] as? String,
              let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString)
        else { return }

        if kind == "watered", let date = dictionary["date"] as? Date {
            Task { @MainActor in
                onWateredReceived(id, date)
            }
            return
        }

        guard kind == "plant",
              let name = dictionary["name"] as? String,
              let room = dictionary["room"] as? Int,
              let isOutdoor = dictionary["isOutdoor"] as? Bool,
              let interval = dictionary["interval"] as? Int,
              let lastWatered = dictionary["lastWatered"] as? Date,
              let latitude = dictionary["latitude"] as? Double,
              let longitude = dictionary["longitude"] as? Double
        else { return }
        let imageData = dictionary["image"] as? Data

        Task { @MainActor in
            let plant = Plant(
                id: id,
                name: name,
                room: Room(rawValue: Int16(room)) ?? .livingRoom,
                isOutdoor: isOutdoor,
                wateringIntervalDays: interval,
                lastWatered: lastWatered,
                image: imageData.flatMap { UIImage(data: $0) } ?? UIImage(),
                coordinate: .init(latitude: latitude, longitude: longitude)
            )
            onPlantReceived(plant)
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
