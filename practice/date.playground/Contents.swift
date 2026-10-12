import Cocoa

let calendar = Calendar.current // nejdriv je potreba vytvorit kalendar
let rightNow: Date = Date() // let rightNow: Date = .now

let dateComponents = DateComponents(calendar: calendar, year: 2008, month: 4, day: 15) // casove komponenty, vsechny jsou optional
let composedDate = calendar.date(from: dateComponents)! // vytvoreni data z kalendare a komponentu


// Get components
let pulledComponents = calendar.dateComponents([.day, .month], from: composedDate)
let weekDay = calendar.component(.weekday, from: .now) // dny v tydnu se vraci jako integer (od nedele do soboty 1-7)

// Adding a component to a date (like 10 days away)
let tenDaysFromNow = calendar.date(byAdding: .day, value: 10, to: .now) // 10 dnu dopredu
let tenDaysBefore = calendar.date(byAdding: .day, value: -10, to: .now) // 10 dnu dozadu

// Get beginning of component
let beginningAndEndOfDay = calendar.dateInterval(of: .day, for: .now) // vrati zacatek, konec a delku dne
let beginningOfDay = calendar.dateInterval(of: .day, for: .now)!.start // zacatek dne

// Time intervals between two dates
let timeInterval = calendar.dateComponents([.year, .day], from: composedDate, to: .now)
let yearsSince = timeInterval.year
let daysSince = timeInterval.day

// Is same day
let isSameDate = calendar.isDate(composedDate, inSameDayAs: .now) // jsou datumy stejne?
let isSameDate2 = calendar.isDate(composedDate, equalTo: .now, toGranularity: .year) // maji datumy stejny rok?
