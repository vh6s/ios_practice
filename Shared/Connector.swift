//
//  Connector.swift
//  Tasks
//
//  Created by Matěj on 12.10.2026.
//

import Foundation
import Observation
import WatchConnectivity

@MainActor @Observable
final class Connector: NSObject, WCSessionDelegate {
    var tasks: [TodoTask] = []          // received from the other device
    var isReachable = false         // is the other app running and connected now?
    
    private let session = WCSession.default
    
    override init() {
        super.init()
        guard WCSession.isSupported() else { return }   // e.g. an iPad
        session.delegate = self
        session.activate()
    }
    
    func send(_ task: TodoTask) {
        // is session even usable? sending message in non activated session is an error
        guard session.activationState == .activated
        else { return }
        var message: [String: Any] = [
            "id": task.id.uuidString,
            "text": task.text,
            "isCompleted": task.isCompleted
        ]
        if let taskDate = task.date {
            message["date"] = taskDate
        }
        
        
        if session.isReachable {        // live
            session.sendMessage(message,
                                replyHandler: nil) { @Sendable error in
                print(error.localizedDescription)
            }
        } else {                        // queued (the Simulator does not support it)
            session.transferUserInfo(message)
        }
    }
    
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
    // Uživatel přejde na jiné hodinky
    // sessionDidBecomeInactive: přes session už nejde zahájit nový přenos. Doručí se jen to, co od starých hodinek ještě dobíhá na pozadí.
    // sessionDidDeactivate: všechna data od starých hodinek jsou doručená a session je deaktivovaná, tedy není spojená s žádnými hodinkami.
    
    // iOS only: the user may switch to another watch.
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) { }
    
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
    
    nonisolated private func receive(_ dictionary: [String: Any]) {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let text = dictionary["text"] as? String,
              let isCompleted = dictionary["isCompleted"] as? Bool
        else { return }
        
        let date = dictionary["date"] as? Date
        
        Task { @MainActor in
            let recievedTask = TodoTask(id: id, text: text, date: date, isCompleted: isCompleted)
            
            if let index = tasks.firstIndex(where: { $0.id == recievedTask.id }) {
                tasks[index] = recievedTask
            } else {
                tasks.insert(recievedTask, at: 0)
            }
        }
    }
    
    nonisolated private func updateReachability(_ reachable: Bool) {
        Task { @MainActor in
            isReachable = reachable
        }
    }
}
