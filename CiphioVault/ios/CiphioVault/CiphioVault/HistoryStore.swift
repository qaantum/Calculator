import Foundation

struct HistoryEntry: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case action
        case algorithm
        case input
        case output
        case timestamp
        case keyHint
    }

    enum Action: String, Codable {
        case encrypt
        case decrypt
    }

    let id: UUID
    let action: Action
    let algorithm: String
    let input: String
    let output: String
    let timestamp: Date
    let keyHint: String
}

final class HistoryStore: ObservableObject {
    @Published private(set) var entries: [HistoryEntry] = []
    @Published var saveEnabled: Bool = false

    private let key = "ciphio.history"
    private let toggleKey = "ciphio.saveToggle"
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
    }

    func append(action: HistoryEntry.Action, algorithm: String, input: String, output: String, keyHint: String) {
        guard saveEnabled else { return }
        let entry = HistoryEntry(
            id: UUID(),
            action: action,
            algorithm: algorithm,
            input: input,
            output: output,
            timestamp: Date(),
            keyHint: keyHint
        )
        entries.insert(entry, at: 0)
        if entries.count > 100 {
            entries = Array(entries.prefix(100))
        }
        persist()
    }

    func clear() {
        entries.removeAll()
        persist()
    }

    func clear(id: UUID) {
        entries.removeAll { $0.id == id }
        persist()
    }

    func setSaveEnabled(_ enabled: Bool) {
        saveEnabled = enabled
        defaults.set(enabled, forKey: toggleKey)
    }

    private func load() {
        saveEnabled = defaults.bool(forKey: toggleKey)
        guard let data = defaults.data(forKey: key), let decoded = try? decoder.decode([HistoryEntry].self, from: data) else { return }
        entries = decoded
    }

    private func persist() {
        guard let data = try? encoder.encode(entries) else { return }
        defaults.set(data, forKey: key)
    }
}

