# WalletWars — Lessons Learned

## Sprint 0

- **iOS 26 Tab API:** `Tab` type has no `.tint()` modifier. Use dynamic `.tint()` on the `TabView` itself based on `selectedTab` index to switch between Hero Blue and Rival Red.
- **Info.plist conflict:** When `GENERATE_INFOPLIST_FILE = YES` (Xcode default), adding a standalone `Info.plist` to the project causes "multiple commands produce Info.plist" build error. Fix: set `INFOPLIST_FILE = WalletWars/Info.plist` in Build Settings and remove it from Copy Bundle Resources.
- **Xcode project file management:** Files created on disk are NOT automatically part of the Xcode build. Must drag into Xcode project navigator manually. Never modify `.pbxproj` directly.
- **`@Query` in ViewModels:** `@Query` does NOT work inside `@Observable` classes — only in SwiftUI Views. ViewModels must use `FetchDescriptor` + `context.fetch()` instead.
- **SwiftData enum storage:** Enums used in `@Model` properties must have `String` raw values and conform to `Codable` for SwiftData JSON storage.
- **SourceKit false positives:** When files exist on disk but aren't added to Xcode project, SourceKit shows "Cannot find type in scope" errors. These resolve once files are added via Xcode.

## Sprint 1

- **`Category` name collision with Darwin:** Our `Category` model clashes with `Darwin.Category` (OpaquePointer). In test files, add `private typealias Category = WalletWars.Category` after the import block. This also affects any file that uses `FetchDescriptor<Category>` or `Category(...)` initializer.
- **SwiftData `#Predicate` enum comparison:** Enum comparisons in `#Predicate` do NOT work — not inline (`.active`), not qualified (`QuestStatus.active`), not captured variable, not `.rawValue`. ALL approaches fail at compile or runtime. **Only fix:** fetch all records with `FetchDescriptor<T>()` and filter in memory: `allQuests.filter { $0.status == .active }`. This is a known SwiftData limitation with `Codable` enum properties.
