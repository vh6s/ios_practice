//
//  Connector.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 11.10.2026.
//

import Foundation
import Observation
import WatchConnectivity

// Swift dělí kód do takzvaných izolačních domén, aby se dvě vlákna nedostala ke stejným datům najednou.
// @MainActor je doména svázaná s hlavním vláknem.
// Tím říkáme, že všechny vlastnosti a metody Connector patří main actoru. Smí se k nim přistupovat jen
// z hlavního vlákna, jinak překladač ohlásí chybu. Dává to smysl, protože notes a isReachable čte SwiftUI
// při vykreslování a změny UI musí probíhat na hlavním vlákně.
@MainActor @Observable
final class Connector: NSObject, WCSessionDelegate {
    var tasks: [Task] = []          // received from the other device
    var isReachable = false         // is the other app running and connected now?
    
    // Callback pro iOS aplikaci, když přijde zpráva o odškrtnutí z hodinek
    @ObservationIgnored var onTaskToggled: (UUID) -> Void = { _ in }

    private let session = WCSession.default

    override init() {
        super.init()
        guard WCSession.isSupported() else { return }   // e.g. an iPad
        session.delegate = self
        session.activate()
    }

    // MARK: - Sending: live if possible, queued if not

    func send(_ task: Task) {
        guard session.activationState == .activated else { return }
        
        // Přidání title do zprávy
        let message: [String: Any] = [
            "title": task.title,
            "text": task.text
        ]
        
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { @Sendable error in
                print(error.localizedDescription)
            }
        } else {
            session.transferUserInfo(message)
        }
    }
    
    //Pro pole
    func sendTasks(_ tasks: [Task]) {
        guard session.activationState == .activated else { return }
        
        do {
            // Převede pole úkolů na formát Data
            let data = try JSONEncoder().encode(tasks)
            // Odešle aktuální stav a na hodinkách přepíše ten starý
            try session.updateApplicationContext(["tasksData": data])
        } catch {
            print("Chyba při kódování dat: \(error.localizedDescription)")
        }
    }
    
    // Odeslání informace o odškrtnutí úkolu (z WatchOS do iOS)
    func sendToggle(id: UUID) {
        guard session.activationState == .activated, session.isReachable else { return }
        
        let message: [String: Any] = [
            "action": "toggle",
            "id": id.uuidString
        ]
        
        session.sendMessage(message, replyHandler: nil) { @Sendable error in
            print("Chyba při odesílání toggle: \(error.localizedDescription)")
        }
    }

    // MARK: - WCSessionDelegate
    // Watch Connectivity calls these methods on a background thread:

    // nonisolated vyjme jednu metodu z izolace třídy. Taková metoda nepatří main actoru
    // a dá se zavolat z libovolného vlákna. Výměnou za to nesmí synchronně sahat na izolovaná
    // data: notes, isReachable ani self.session.
    // Jak se z non-isolated dostat zpět?  Task { @MainActor in ...
    
    nonisolated func session(_ session: WCSession,
        activationDidCompleteWith state: WCSessionActivationState,
        error: (any Error)?) {
        if let error {
            print("Activation failed: \(error.localizedDescription)")
        }
        updateReachability(session.isReachable)
        
        // Načte data uložená z minula hned po startu
        if !session.receivedApplicationContext.isEmpty {
            processContext(session.receivedApplicationContext)
        }
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
    
    //Toto se musi doplnit pro predavani tasku
    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        processContext(applicationContext)
    }
    
    // udrzuje funkci pamet watchek i bez spusteni mobilni apky
    nonisolated private func processContext(_ context: [String: Any]) {
        guard let data = context["tasksData"] as? Data else { return }
        do {
            let decodedTasks = try JSONDecoder().decode([Task].self, from: data)
            Swift.Task { @MainActor in
                self.tasks = decodedTasks
            }
        } catch {
            print("Chyba dekódování: \(error)")
        }
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
#endif // os(iOS)

    // MARK: - Helpers

    nonisolated private func receive(_ dictionary: [String: Any]) {
        // 1. Nejprve zkontrolujeme, zda nejde o zprávu typu "toggle"
        if let action = dictionary["action"] as? String, action == "toggle",
           let idString = dictionary["id"] as? String,
           let id = UUID(uuidString: idString) {
            
            Swift.Task { @MainActor in
                onTaskToggled(id)
            }
            return // Pokud to byl toggle, ukončíme funkci
        }
        
        // 2. Pokud to nebyl toggle, rozbalíme hodnoty pro nový úkol
        guard let text = dictionary["text"] as? String,
              let title = dictionary["title"] as? String
        else { return }
        
        Swift.Task { @MainActor in
            // Poznámka: Zde chybí isCompleted, protože tato starší metoda ho nezná.
            // Protože ale pro přenos pole používáš sendTasks/updateApplicationContext,
            // tato část se pravděpodobně ani nezavolá. Ponecháváme ji pro zpětnou kompatibilitu.
            tasks.append(Task(title: title, text: text))
        }
    }

    nonisolated private func updateReachability(_ reachable: Bool) {
        Swift.Task { @MainActor in //Swift kdyby byla koliza
            isReachable = reachable
        }
    }
}
