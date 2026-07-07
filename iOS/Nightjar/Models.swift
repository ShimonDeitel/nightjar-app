import Foundation

struct Sighting: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var species: String
    var location: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), species: String = "", location: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.species = species
        self.location = location
        self.notes = notes
    }
}
