# WalletWars — Lessons Learned

## Sprint 0

- **iOS 26 Tab API:** `Tab` type has no `.tint()` modifier. Use dynamic `.tint()` on the `TabView` itself based on `selectedTab` index to switch between Hero Blue and Rival Red.
- **Info.plist conflict:** When `GENERATE_INFOPLIST_FILE = YES` (Xcode default), adding a standalone `Info.plist` to the project causes "multiple commands produce Info.plist" build error. Fix: set `INFOPLIST_FILE = WalletWars/Info.plist` in Build Settings and remove it from Copy Bundle Resources.
- **Xcode project file management:** Files created on disk are NOT automatically part of the Xcode build. Must drag into Xcode project navigator manually. Never modify `.pbxproj` directly.
- **`@Query` in ViewModels:** `@Query` does NOT work inside `@Observable` classes — only in SwiftUI Views. ViewModels must use `FetchDescriptor` + `context.fetch()` instead.
- **SwiftData enum storage:** Enums used in `@Model` properties must have `String` raw values and conform to `Codable` for SwiftData JSON storage.
- **SourceKit false positives:** When files exist on disk but aren't added to Xcode project, SourceKit shows "Cannot find type in scope" errors. These resolve once files are added via Xcode.
