import XCTest
@testable import Nightjar

@MainActor
final class NightjarTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeTierLimit)
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(Sighting(species: "Test Entry"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddedEntryAppearsFirst() {
        store.add(Sighting(species: "Newest"))
        XCTAssertEqual(store.entries.first?.species, "Newest")
    }

    func testDeleteRemovesEntry() {
        let entry = Sighting(species: "ToDelete")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(entry))
    }

    func testCanAddMoreWhenBelowLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtFreeLimitWithoutPro() {
        store.entries = (0..<Store.freeTierLimit).map { _ in Sighting(species: "X") }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBlockedAtLimitDoesNotAppend() {
        store.entries = (0..<Store.freeTierLimit).map { _ in Sighting(species: "X") }
        let before = store.entries.count
        store.add(Sighting(species: "Overflow"))
        XCTAssertEqual(store.entries.count, before)
    }

    func testUpdateModifiesExistingEntry() {
        let entry = Sighting(species: "Original")
        store.add(entry)
        var updated = entry
        updated.species = "Updated"
        store.update(updated)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.species, "Updated")
    }
}
