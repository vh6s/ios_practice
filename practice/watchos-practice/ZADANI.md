# PlantPal: zadání na procvičení

Aplikace hlídá, kdy zalít které kytky. **Hodinky** ukážou, co je dnes potřeba zalít, a ťuknutím zalití potvrdíš. **Widget** na ploše ukáže nejbližší kytku a má tlačítko „Zalito“.

Pokrývá všechno ze cvičení: MVVM, DI, Core Data (se vztahem 1:N), síťová volání, polohu, MapKit, PhotosPicker, záložky, navigaci do detailu, sheety s výškami, nastavitelný interaktivní widget s App Group a hodinky s komunikací oběma směry.

---

## Rozhodnutí, která už platí

- **Poloha je povinná.** Každá kytka má souřadnice: ve structu `CLLocationCoordinate2D`, v Core Data dva povinné `Double`.
- **Spočítané hodnoty se neukládají.** `nextWatering` a `isDueToday` jsou spočítané vlastnosti ve structu `Plant`.
- Historie zalití je ve `WateringEntity` a zapisuje ji jen `waterPlant`.

---

## Mapa obrazovek

### iPhone

```
TabView
├── Záložka „Dnes“    → TodayView           (NavigationStack)
│     ├── karta s počasím (API)
│     ├── seznam kytek k zalití, v každém řádku tlačítko „Zalito“
│     └── ťuknutí na řádek ──push──▶ PlantDetailView
│
├── Záložka „Kytky“   → PlantListView       (NavigationStack)
│     ├── List všech kytek + ContentUnavailableView, když je prázdný
│     ├── toolbar „+“ ──sheet──▶ PlantFormView (nová kytka)
│     └── ťuknutí na řádek ──push──▶ PlantDetailView
│
└── Záložka „Mapa“    → PlantMapView
      ├── Map s Annotation pro každou kytku (symbol místnosti)
      └── ťuknutí na kytku ──sheet s výškami──▶ PlantDetailView

PlantDetailView
  ├── fotka, místnost, další zalití, historie zalití
  ├── „Zalito“             → dataManager.waterPlant
  ├── „Upravit“            ──sheet──▶ PlantFormView (úprava, předvyplněná)
  ├── „Smazat“             ──confirmationDialog──▶ dataManager.deletePlant
  └── „Poslat na hodinky“  → connector.send

PlantFormView (vždy uvnitř sheetu + NavigationStack)
  ├── TextField jméno
  ├── Picker místnost (.segmented)
  ├── Stepper interval zalévání (dny)
  ├── Toggle venkovní
  ├── PhotosPicker fotka
  ├── patička sekce: souřadnice (aktuální poloha, jinak Brno)
  └── toolbar: Cancel (.cancellationAction), Save (.confirmationAction)
```

**Jeden formulář, dva režimy.** `PlantFormViewModel(plant: Plant?)`: `nil` znamená novou kytku, hodnota znamená úpravu. `savePlant` hledá podle `id`, takže oba režimy volají stejnou metodu.

### Apple Watch

```
NavigationStack
└── WatchPlantListView
      ├── kytky k zalití dnes
      ├── toolbar: ikona, jestli je iPhone dostupný
      └── ťuknutí na řádek ──push──▶ WatchPlantDetailView
                                       ├── fotka, jméno, místnost
                                       ├── „Zalito“    → pošle na iPhone
                                       └── „Navigovat“ → MKMapItem.openInMaps (pěšky)
```

### Widget

| Velikost | Obsah |
|---|---|
| `.systemSmall` | nejbližší kytka + za kolik dní ji zalít + tlačítko „Zalito“ |
| `.systemMedium` | tři nejbližší kytky, každá s tlačítkem „Zalito“ |

Nastavení: `@Parameter` „Jen místnost“ (`Room` jako `AppEnum`; nevyplněno = všechny místnosti).

---

## Struktura složek

```
PlantPal/
  PlantPalApp.swift              @main, vytváří Connector jako @State
  ContentView.swift              TabView
  DI/                            DIContainer, Injected
  Model/                         Plant, Room, WeatherData, PlantPal.xcdatamodeld
  Screens/
    Today/                       TodayView, TodayViewModel, TodayViewState
    PlantList/                   PlantListView, PlantListViewModel, PlantListViewState
    PlantDetail/                 PlantDetailView, PlantDetailViewModel, PlantDetailViewState
    PlantForm/                   PlantFormView, PlantFormViewModel, PlantFormViewState
    PlantMap/                    PlantMapView, PlantMapViewModel, PlantMapViewState
  Services/
    Data/                        DataManaging, CoreDataManager, MockDataManager
    Networking/                  Router, HttpMethod, APIManager, WeatherDataRouter
    Location/                    LocationManaging, CoreLocationManager, MockLocationManager
    Connectivity/                Connector (sdílený s cílem pro hodinky)
PlantPalWidget/
  PlantPalWidgetBundle, PlantPalWidget, PlantPalWidgetEntryView, WaterPlantIntent
  Timeline/                      Provider, PlantEntry, ConfigurationAppIntent
PlantPal Watch App/
  PlantPalWatchApp.swift
  Screens/WatchPlantList/, Screens/WatchPlantDetail/
```

---

## Datový model

**Struct `Plant`**

| Vlastnost | Typ | Poznámka |
|---|---|---|
| `id` | `UUID` | |
| `name` | `String` | |
| `room` | `Room` | `livingRoom`, `bedRoom`, `kitchen`, `balcony` (raw hodnoty `Int16`) |
| `isOutdoor` | `Bool` | |
| `wateringIntervalDays` | `Int` | |
| `lastWatered` | `Date` | |
| `image` | `UIImage` | |
| `coordinate` | `CLLocationCoordinate2D` | povinná |
| `waterings` | `[Date]` | od nejnovějšího, přidáš v etapě 3 |
| `nextWatering` | spočítaná | `lastWatered` + interval |
| `isDueToday` | spočítaná | `nextWatering` ≤ konec dneška |

**Core Data:** `PlantEntity` 1:N `WateringEntity` (`waterings` Cascade, `plant` Nullify).

**`DataManaging`:** `savePlant`, `fetchPlants`, `waterPlant`, v etapě 3 přibude `deletePlant`.

---

## Etapy

### Etapa 1: Kostra, MVVM, DI (zbývá ~30 min)
- [x] Složky `Screens/`, `Services/`, `DI/`, `Model/`
- [x] `DIContainer`, `DataManaging`
- [ ] `ContentView`: `TabView` se záložkami Dnes, Kytky, Mapa (v každé zatím jen `Text`)

**Hotovo, když:** aplikace se spustí se třemi záložkami.

### Etapa 2: Core Data ✅
- [x] `CoreDataManager` s ukládáním „najdi podle `id`, jinak vytvoř“
- [x] `waterPlant` vytvoří `WateringEntity` a upraví `lastWatered`
- [x] `CoreDataManager` zaregistrovaný v DI
- [ ] Vypsat chybu v prázdném `catch` ve `waterPlant`

### Etapa 3: Obrazovky a sheety (~2,5 h)
- [ ] **PlantList** s `ContentUnavailableView` a „+“, které otevře **sheet PlantForm**
- [ ] **PlantForm** (režim nová kytka + úprava), Cancel / Save
- [ ] **PlantDetail** přes `NavigationLink`: historie, Zalito, sheet Upravit, Smazat s `.confirmationDialog`
- [ ] `deletePlant` v `DataManaging` a `CoreDataManager`
- [ ] `waterings: [Date]` v `Plant`, načtené z `entity.waterings`
- [ ] **Dnes**: kytky s `isDueToday`, tlačítko „Zalito“ v každém řádku

**Hotovo, když:**
- přidáš kytku přes sheet a upravíš ji druhým sheetem,
- po zalití přibude řádek v historii,
- smazaná kytka zmizí.

### Etapa 4: Poloha a mapa (~1,5 h)
- [ ] `LocationManaging`, `CoreLocationManager`, zaregistrované v DI
- [ ] `NSLocationWhenInUseUsageDescription` přes `INFOPLIST_KEY_*`
- [ ] PlantForm převezme aktuální polohu, jinak použije Brno
- [ ] Záložka **Mapa**: všechny kytky jako `Annotation`; ťuknutí otevře sheet s `.presentationDetents([.fraction(0.3), .medium, .large])`

**Hotovo, když:** ťuknutí na kytku v mapě vysune detail zespodu a sheet jde roztáhnout.

### Etapa 5: API a stav načítání (~1 h)
- [x] `Router`, `HttpMethod`, `APIManager`, `WeatherDataRouter` (`precipitation_sum`)
- [x] Model `WeatherData`
- [ ] Zaregistrovat `APIManaging` v DI
- [ ] Dnes: karta s počasím pro aktuální polohu; stav obrazovky drží `isLoading`, `errorMessage` a data
- [ ] Víc než 2 mm srážek dnes: **venkovní** kytky schovat ze seznamu k zalití, popisek „Zalije déšť 🌧️“

**Hotovo, když:**
- bez internetu vidíš chybovou hlášku,
- s internetem vidíš dnešní srážky.

### Etapa 6: Widget (~2 h)
- [ ] App Group `group.cz.<ty>.PlantPal` v obou cílech sestavení; databáze Core Data ve sdílené složce
- [ ] Nasdílet `Model`, `DI`, `Services/Data` do cíle widgetu (target membership)
- [ ] `AppIntentConfiguration` s parametrem „Jen místnost“
- [ ] Rozložení small + medium
- [ ] Interaktivní `Button(intent: WaterPlantIntent(plantId:))`, který zapisuje do Core Data
- [ ] Timeline `.after(příští půlnoc)`; `savePlant` a `waterPlant` volají `WidgetCenter.shared.reloadAllTimelines()`

**Hotovo, když:** po ťuknutí na „Zalito“ ve widgetu kytka zmizí z widgetu i ze záložky Dnes.

### Etapa 7: watchOS (~2,5 h)
- [ ] Nasdílet `Model`, `DI`, `Services/Data`, `Connector` do cíle pro hodinky
- [ ] `Connector`: `@MainActor @Observable`, metody delegáta `nonisolated`, `sendMessage`, když je druhé zařízení dostupné, jinak `transferUserInfo`
- [ ] **iPhone → hodinky**: „Poslat na hodinky“ pošle kytku po jednotlivých polích (id, jméno, místnost, interval, lastWatered, latitude, longitude, malé JPEG); hodinky ji uloží do vlastního Core Data
- [ ] **Hodinky → iPhone**: „Zalito“ pošle `["id": …, "wateredAt": …]`; iPhone zavolá `waterPlant` a obnoví widget
- [ ] Obrazovky na hodinkách: seznam (ikona dostupnosti iPhonu) a detail (Zalito, Navigovat)

**Hotovo, když:** zalití potvrzené na hodinkách se objeví v historii na iPhonu i ve widgetu.

---

## Bonusy

- `updateApplicationContext`: synchronizace celého seznamu kytek na hodinky
- Komplikace na ciferník hodinek s počtem kytek k zalití
- Unit testy na `isDueToday` a `nextWatering` s `MockDataManager`
