# Widget (WidgetKit)

Zdroje: cvičení `sem_02/finish/Jokes_CoreData_Widget` (čte Core Data aplikace), `sem_02/finish/Jokes_CoreData_Widget_API` (vlastní API, tlačítko), `sem_03/final/CityGuide` (nastavitelný widget). Z `practice/`: RandomNumber, Tasks.

---

## 0. Rozhodni

| Otázka | Možnosti | Příklad |
|---|---|---|
| Odkud data? | databáze aplikace / vlastní API / služba | Jokes_CoreData / Jokes_API / CityGuide |
| Nastavuje ho uživatel? | ne: `StaticConfiguration`. ano: `AppIntentConfiguration` | Jokes, Tasks: ne. CityGuide: ano. |
| Obnova? | `.never` (obnovuje aplikace) / `.after(date)` / `.atEnd` | Jokes_CoreData: `.never`. Jokes_API: `.after(1 h)`. CityGuide: `.atEnd`. |
| Tlačítko? | jen obnovit (8.1) / změnit záznam (8.2) | Jokes_API / Tasks |

---

## 1. Cíl widgetu

1. File → New → Target → **Widget Extension**.
2. Odškrtni Live Activity a Control. **Configuration App Intent** jen pro nastavitelný widget.
3. „Activate scheme?“ → Activate.

- `Info.plist` widgetu nesmí být v Target Membership widgetu. Jinak „Multiple commands produce …/Info.plist“.
- Po smazání cíle zůstane `*.entitlements`, skupina `Frameworks` a nastavení na úrovni projektu. Smaž je před novým cílem se stejným názvem.
- `project.pbxproj` změněný na disku → **Read From Disk**, ne „Keep Xcode Version“.
- Šablonové názvy (`MyWidget`, „My Widget“, „This is an example widget“) přejmenuj. Po změně `kind` widget z plochy odeber a přidej znovu.

---

## 2. Soubory

```
<App>Widget/
  <App>WidgetBundle.swift      @main
  <App>Widget.swift            konfigurace
  <App>WidgetEntryView.swift   UI + #Preview
  Timeline/
    Provider.swift
    <X>Entry.swift
    ConfigurationAppIntent.swift   jen u AppIntentConfiguration
```

---

## 3. Konfigurace

```swift
struct JokesWidget: Widget {
    let kind: String = "JokesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            JokesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Random Joke")
        .description("Downloads a new random joke every hour.")
    }
}

#Preview(as: .systemMedium) {
    JokesWidget()
} timeline: {
    JokeEntry(date: .now, joke: Joke.getSample())
    JokeEntry(date: .now, joke: nil)
}
```

`if #available(iOS 17.0, *)` ze šablony smaž, projekt cílí na iOS 26.

**Nastavitelný (CityGuide):** `ConfigurationAppIntent: WidgetConfigurationIntent` s `@Parameter` poli → formulář v „Upravit widget“. K tomu `AppIntentConfiguration(kind:intent:provider:)` a `Provider: AppIntentTimelineProvider`, který dostává `configuration`.

---

## 4. Entry + prázdný stav

```swift
struct JokeEntry: TimelineEntry {
    let date: Date
    let joke: Joke?   // nil: no data yet or download failed
}
```

`nil` není chyba. Ukaž „No number yet“ / „No upcoming tasks“, ne „error“. `ContentUnavailableView` se do widgetu nevejde.

---

## 5. Provider

| Funkce | Kdy | Musí |
|---|---|---|
| `placeholder` | před daty | `Model.getSample()`, bez načítání |
| `getSnapshot` | galerie | rychle, bez sítě |
| `getTimeline` | plocha | **vždy zavolat `completion`**, jinak je widget prázdný |

### 5.1 Data z aplikace (Core Data přes App Group)

```swift
struct Provider: TimelineProvider {
    private let dataManager: DataManaging

    init() {
        dataManager = DIContainer.shared.resolve()
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NumberEntry>) -> Void) {
        Task { @MainActor in // viewContext is main-thread only
            completion(Timeline(entries: [currentEntry()], policy: .never))
        }
    }

    private func currentEntry() -> NumberEntry {
        NumberEntry(date: .now, number: dataManager.fetchNumbers().first)
    }
}
```

### 5.2 Vlastní API (Jokes_API)

```swift
func getTimeline(in context: Context, completion: @escaping (Timeline<JokeEntry>) -> Void) {
    Task {
        var joke: Joke? = nil
        do {
            joke = try await apiManager.request(JokeRouter.randomSingleJoke)
        } catch {
            print("❌ \(error)")   // still deliver an entry, with nil
        }
        let nextUpdate = Date().addingTimeInterval(60 * 60)
        completion(Timeline(entries: [JokeEntry(date: Date(), joke: joke)], policy: .after(nextUpdate)))
    }
}
```

Bez App Group. Služba (CityGuide): `DIContainer.shared.resolve()` v Provideru, taky bez App Group.

---

## 6. App Group (jen 5.1)

1. Cíl aplikace → Signing & Capabilities → **+ App Groups** → `group.<prefix>.<App>`.
2. Cíl widgetu → **stejná** skupina. Hodinkám ne.
3. `CoreDataManager.init`:
   ```swift
   static let appGroup = "group.cz.mendelu.Jokes"

   init() {
       if let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroup) {
           container.persistentStoreDescriptions = [
               NSPersistentStoreDescription(url: groupURL.appending(path: "Jokes.sqlite"))
           ]
       } else {
           print("App Group \(Self.appGroup) is not available, the widget will not see the data.")
       }
       container.loadPersistentStores { _, error in ... }
   }
   ```
4. V privátním `save()`: `WidgetCenter.shared.reloadAllTimelines()` (`import WidgetKit`). Jedno místo pokryje všechny změny.

- Bez App Group má widget vlastní prázdnou databázi. Žádná chyba, jen prázdný stav.
- Data z doby před App Group zůstanou ve starém souboru. V simulátoru aplikaci smaž a nainstaluj znovu.
- Na hodinkách App Group není → větev `else`, databáze na výchozím místě. Funguje.

---

## 7. Sdílení kódu

Target Membership widgetu: `DI/*`, model (`*.swift` + `*.xcdatamodeld`), `Services/Data/*` (u 5.2 `Services/Networking/*`).

**Connector ne.** WatchConnectivity v rozšíření nefunguje. Sdílený `DIManager` ho ale registruje:

1. **Cíl** widgetu → Build Settings → Active Compilation Conditions → přidej `WIDGET_EXTENSION` do Debug i Release (dvojklik na hodnotu → **+**, ne „Add Conditional Setting“).
2. Registraci obal:
   ```swift
   #if !WIDGET_EXTENSION
   register(WatchConnecting.self, cached: true) { Connector() }
   #endif
   ```

- Nastav u **cíle**, nikdy u **projektu**. Projekt dědí i aplikace a hodinky, ty by pak connector vynechaly.
- `#if os(iOS)` ani `canImport(WatchConnectivity)` nepomůže, widget je iOS.

---

## 8. Tlačítko

### 8.1 Jen obnoví widget (Jokes_API)

```swift
struct ReloadJokeIntent: AppIntent {
    static var title: LocalizedStringResource { "Reload joke" }
    func perform() async throws -> some IntentResult {
        .result()   // returning reloads the timeline
    }
}

Button(intent: ReloadJokeIntent()) {
    Image(systemName: "arrow.clockwise")
}
```

### 8.2 Změní záznam (Tasks)

Potřebuje App Group (6) a sdílené `DataManaging` (7).

```swift
import AppIntents

struct CompleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete task"

    @Parameter(title: "Task ID")
    var taskId: String

    init() {}

    init(taskId: UUID) {
        self.taskId = taskId.uuidString
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        let dataManager: DataManaging = DIContainer.shared.resolve()
        guard var task = dataManager.fetchTasks().first(where: { $0.id.uuidString == taskId })
        else { return .result() }

        task.completed = true
        dataManager.saveTask(task)
        return .result()
    }
}
```

```swift
import AppIntents   // Button(intent:) lives here
…
Button(intent: CompleteTaskIntent(taskId: task.id)) {
    Label("Done", systemImage: "checkmark.circle")
}
```

| Část | Proč |
|---|---|
| `@Parameter var taskId: String` | který záznam. `String`, protože `@Parameter` umí jen některé typy. |
| prázdné `init()` | systém si intent vytváří sám |
| `@MainActor` | `viewContext` jen z hlavního vlákna |
| `completed = true` | hodnota, ne „přepni“ |
| `import AppIntents` ve view | jinak „init(intent:label:) is not available due to missing import“ |

- **Aplikace na pozadí neuvidí změnu z widgetu.** `.onAppear` se po návratu nespustí:
  ```swift
  @Environment(\.scenePhase) private var scenePhase
  …
  .onChange(of: scenePhase) { _, phase in
      if phase == .active { viewModel.fetchTasks() }
  }
  ```
  A v `fetchTasks()` před fetchem `context.refreshAllObjects()`, jinak `viewContext` vrátí hodnotu z paměti.
- **Hodinky se o změně z widgetu nedozví** (widget nemá connector). Při `phase == .active` pošli na hodinky všechny úkoly. Příjem je upsert, opakování nevadí.

---

## 9. Testování

1. Spusť schéma **aplikace**.
2. Podrž plochu → **+** → přidej widget.
3. Ulož nová data.
4. `#Preview(as:)` s plným i prázdným záznamem.

**Prázdný nebo zastaralý widget?**
1. `getTimeline` volá `completion` na každé cestě.
2. Stejná App Group v entitlements obou cílů.
3. `save()` volá `reloadAllTimelines()`.
4. Cíl widgetu má model, `.xcdatamodeld` a `CoreDataManager`.
5. Konzole nehlásí „App Group … is not available“.
6. Pořád nic → widget odeber a přidej znovu.
