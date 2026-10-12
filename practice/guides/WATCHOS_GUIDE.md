# watchOS + WatchConnectivity

Zdroje: cvičení `sem_03/final/CityGuide` (iPhone → hodinky, hodinky ukládají do Core Data) a `sem_03/final/Messenger` (oba směry, jen paměť). Z `practice/`: PlantPal, RandomNumber, Tasks.

---

## 0. Rozhodni

| Otázka | Možnosti | Příklad |
|---|---|---|
| Směr? | iPhone → hodinky / hodinky → iPhone / oba | CityGuide: → hodinky. Messenger, Tasks: oba. |
| Přežijí data restart? | ne: drž je v connectoru nebo ve `state`. ano: callback → Core Data | Messenger: `connector.notes`. CityGuide: `onPlaceReceived` → Core Data. |
| Jak connector k VM? | `@State` v `App` + předávat přes `init`, nebo DI | CityGuide: `init`. PlantPal, RandomNumber, Tasks: DI. |
| Kde sdílené soubory? | iOS složka + Target Membership hodinek, nebo `Shared/` v obou cílech | CityGuide: Membership. Messenger, Tasks: `Shared/`. |
| Kdy posílat? | tlačítkem, nebo hned po uložení | CityGuide, PlantPal: tlačítko. Tasks: po uložení. |

---

## 1. Cíl hodinek

1. File → New → Target → **watchOS → App** („Watch App for Existing iOS App“).
2. Zkontroluj: `INFOPLIST_KEY_WKCompanionAppBundleIdentifier` = bundle ID iPhonu, bundle ID hodinek = `<iPhone>.watchkitapp`.

Po přejmenování projektu zkontroluj obě ID znovu. `⌘B` projde, chyba se ukáže až při instalaci.

---

## 2. Sdílení kódu

Hodinkám dej jen model, DI, `Services/Data` a Connector. Síť ani polohu ne.

```swift
func registerDependencies() {
    register(DataManaging.self, cached: true) { CoreDataManager() }
    register(WatchConnecting.self, cached: true) { Connector() }
#if os(iOS)
    register(APIManaging.self, cached: true) { APIManager() }
#endif
}
```

- „Cannot find 'X' in scope“ jen v cíli hodinek → `X` nasdílej, nebo jeho použití obal do `#if os(iOS)`.
- Hodinky mají **vlastní databázi**. Stejný model a kód, jiný soubor. App Group mezi zařízeními nefunguje.

---

## 3. Connector

Jedna třída v obou cílech.

```swift
@MainActor @Observable
final class Connector: NSObject, WCSessionDelegate, WatchConnecting {
    var isReachable = false
    @ObservationIgnored var onPlantReceived: (Plant) -> Void = { _ in }

    private let session = WCSession.default

    override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        session.delegate = self
        session.activate()
    }
}
```

### 3.1 Odesílání

```swift
private func transfer(_ message: [String: Any]) {
    guard session.activationState == .activated else { return }
    if session.isReachable {
        session.sendMessage(message, replyHandler: nil) { @Sendable error in
            print(error.localizedDescription)
        }
    } else {
        session.transferUserInfo(message)
    }
}
```

| Metoda | Doručení | Simulátor |
|---|---|---|
| `sendMessage` | hned, jen když druhá aplikace běží | ✅ |
| `transferUserInfo` | fronta, doručí se později | ❌ |
| `updateApplicationContext` | jen poslední stav | ✅ (ve cvičení není) |

`@Sendable` u chybového handleru je nutný: běží na vedlejším vlákně a Swift 6 by bez něj spadl.

### 3.2 Formát zprávy

- Jen `String`, čísla, `Bool`, `Date`, `Data` a pole a slovníky z nich. `UUID` → `uuidString`, enum → `Int(rawValue)`, obrázek → malé JPEG `Data` (`preparingThumbnail` jen v `#if os(iOS)`).
- Víc druhů zpráv → klíč `"kind"`. Nesmí kolidovat s polem modelu.
- Vždy posílej původní `id`.

### 3.3 Příjem

```swift
nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    receive(message)
}
nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
    receive(userInfo)
}

nonisolated private func receive(_ dictionary: [String: Any]) {
    guard let idString = dictionary["id"] as? String,
          let id = UUID(uuidString: idString),
          let name = dictionary["name"] as? String
    else { return }                              // malformed: drop, never crash
    let imageData = dictionary["image"] as? Data // optional fields outside the guard

    Task { @MainActor in
        onPlantReceived(Plant(id: id, name: name,
                              image: imageData.flatMap { UIImage(data: $0) } ?? UIImage()))
    }
}
```

- Delegát běží na vedlejším vlákně → `nonisolated`, hodnoty vytáhni ze slovníku, pak `Task { @MainActor in … }`.
- `UUID(uuidString:)` patří do `guard`. `?? UUID()` z poškozené zprávy vyrobí nový záznam.
- `receive` musí callback opravdu zavolat (RandomNumber ho jednou nevolal).
- iOS navíc: `sessionDidBecomeInactive` (prázdná) a `sessionDidDeactivate` → `session.activate()`, obojí v `#if os(iOS)`.

---

## 4. Jen jeden connector

Každý connector se nastaví jako `session.delegate`, platí jen poslední. Proto:

| Přístup | Pravidlo |
|---|---|
| `@State private var connector = Connector()` v `App` | předávej přes `init` každé obrazovce |
| DI | `register(WatchConnecting.self, cached: true) { Connector() }`. `Connector()` nesmí být nikde jinde. |

- Protokol musí být `AnyObject`, jinak `connector.onX = …` na `let` nejde.
- Callbacky `{ get set }`, `isReachable` `{ get }`.
- Zprávy z fronty přijdou hned po startu → connector i callback musí existovat před první obrazovkou.

---

## 5. Kdo nastavuje callback

**Callback je jedno místo.** Nastavit ho smí jen jeden objekt a ten musí žít celý běh aplikace.

| Vlastník | Kdy | Příklad |
|---|---|---|
| VM vytvořený v `App` (`@State` v `App`, view má `let viewModel`) | jedna přijímající obrazovka | CityGuide hodinky |
| `App.init` | uložit bez ohledu na obrazovku | PlantPal iPhone |
| sdílená `@Observable` služba v DI | víc obrazovek ukazuje stejná data | nebylo potřeba |
| žádný, data drží connector | smí po restartu zmizet | Messenger |

- **VM s callbackem nevytvářej ve view**, ani přes `@State`. View vzniká znovu, `XxxViewModel()` se spustí znovu a zahozená instance přepíše callback. Její `[weak self]` je pak `nil` a data se neuloží.
- `[weak self]` v každém `onXxxReceived`. Connector žije celý běh aplikace a bez něj by držel VM navždy.
- `var state = XxxViewState()` s výchozí hodnotou. Bez ní closure v `init` hlásí „self._state used before being initialized“.
- `App.init` + `@State`: nastav lokální objekt, pak jednou přiřaď. Hodnotu `@State` v `init` nečti.
- Ukládání v `App.init` neobnoví otevřený seznam. Buď callback ve VM, nebo `.onChange` na hodnotu v connectoru.

---

## 6. Co posílat

**Obecně:**
- **Hodnotu, ne příkaz.** `"completed": true`, ne „přepni“. Druhé doručení pak nic nezkazí.
- **Čas události posílej s ní** (`sendWatered(plantId:date:)`). Zpráva z fronty může přijít o hodiny později.
- **Příjem = upsert** podle `id` (Core Data: `results.first ?? Entity(context:)`, `state`: `firstIndex`). Jinak duplicity.
- **Změnu ulož i lokálně**, ať se vlastní seznam obnoví hned.
- **Model nepojmenovávej `Task`**, přepíše Swift `Task`. Použij `TaskItem`.

### 6.1 Stejný objekt tam a zpátky (Tasks)

Jedna zpráva = celý úkol. iPhone ho pošle po přidání, obě strany po odškrtnutí.

```swift
protocol WatchConnecting: AnyObject {
    var isReachable: Bool { get }
    var onTaskReceived: (TaskItem) -> Void { get set }
    func send(_ task: TaskItem)
}

func toggle(task: TaskItem) {
    var updated = task
    updated.completed.toggle()
    dataManager.saveTask(updated)
    connector.send(updated)
    fetchTasks()
}
```

| ✅ | ❌ |
|---|---|
| jedna zpráva, jeden callback, bez `"kind"` | starší kopie přepíše novější změny na druhé straně |
| nový i změněný úkol = stejný kód příjmu | posílá se víc, než se změnilo |

**Stačí, když se po vytvoření mění jen jedno pole** (Tasks: jen `completed`). Jinak 6.2.

### 6.2 Změny jako `id` + hodnota (návrh, neimplementováno)

| Změna | Zpráva |
|---|---|
| nový záznam | celý objekt, `"kind": "task"` |
| úprava | `id` + nová hodnota, `"kind": "completed"` |

```swift
protocol WatchConnecting: AnyObject {
    var isReachable: Bool { get }
    var onTaskReceived: (TaskItem) -> Void { get set }
    var onCompletedReceived: (UUID, Bool) -> Void { get set }
    func send(_ task: TaskItem)
    func sendCompleted(id: UUID, completed: Bool)
}
```

Ve VM druhý callback `onCompletedReceived` → `setCompleted(id:completed:)` + `fetchTasks()`.

### 6.3 Hodinky ze `state` na Core Data

1. Target Membership hodinek: `CoreDataManager.swift`, `DataManaging.swift`, `*.xcdatamodeld`.
2. `DataManaging` registruj bez `#if os(iOS)`.
3. Callback na hodinkách: `dataManager.saveTask` + `fetchTasks()`.
4. View: `.onAppear { viewModel.fetchTasks() }`.

Hodinky začínají s prázdnou databází → `ContentUnavailableView`.

---

## 7. UI na hodinkách

```swift
@main
struct PlantPalWatchApp: App {
    @State private var viewModel = WatchPlantListViewModel()
    var body: some Scene {
        WindowGroup {
            WatchPlantListView(viewModel: viewModel)
        }
    }
}
```

- Stejné View / ViewModel / ViewState. Šablonový `ContentView.swift` smaž.
- Prázdný seznam → `ContentUnavailableView`.
- Ikona dostupnosti: `iphone.radiowaves.left.and.right` / `iphone.slash`.
- Jednoduše: seznam, detail, jedna akce. Žádné formuláře.

---

## 8. Spuštění

1. Vyber iPhone **se spárovanými hodinkami** (`xcrun simctl list pairs`).
2. Spusť iOS schéma.
3. Přepni na schéma hodinek, cíl = spárované hodinky. Spusť, zvol **Don't Stop**.
4. Obě aplikace v popředí, simulátor doručí jen `sendMessage`.

**Nic nedorazilo?**
1. Pár je `connected`.
2. `WindowGroup` hodinek obsahuje view.
3. Ikona dostupnosti je zelená.
4. Jen jeden `Connector()` (`grep -rn "Connector()"`).
5. `receive` volá callback a jeho vlastník žije.
6. `print("📥 \(dictionary)")` na začátku `receive`.
