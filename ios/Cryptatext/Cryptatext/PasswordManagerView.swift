import SwiftUI
import LocalAuthentication
import Security

/// Main password manager view that handles navigation between screens.
struct PasswordManagerView: View {
    @StateObject private var vaultStore: PasswordVaultStore
    @State private var navigationPath = NavigationPath()
    
    private let cryptoService: CryptoService
    
    init(cryptoService: CryptoService) {
        self.cryptoService = cryptoService
        _vaultStore = StateObject(wrappedValue: PasswordVaultStore(cryptoService: cryptoService))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if !vaultStore.hasMasterPassword() {
                    MasterPasswordSetupView(vaultStore: vaultStore, onSetupComplete: {
                        // Setup complete, will show list
                    })
                } else if !vaultStore.isUnlocked {
                    MasterPasswordUnlockView(vaultStore: vaultStore, onUnlockComplete: {
                        // Unlock complete, will show list
                    })
                } else {
                    PasswordManagerListView(
                        vaultStore: vaultStore,
                        onAddEntry: {
                            navigationPath.append(PasswordNavigation.add)
                        },
                        onViewEntry: { entry in
                            navigationPath.append(PasswordNavigation.view(entry))
                        },
                        onEditEntry: { entry in
                            navigationPath.append(PasswordNavigation.edit(entry))
                        },
                        onChangePassword: {
                            navigationPath.append(PasswordNavigation.changePassword)
                        },
                        onLock: {
                            vaultStore.lock()
                        }
                    )
                }
            }
            .navigationDestination(for: PasswordNavigation.self) { destination in
                switch destination {
                case .add:
                    AddEditPasswordEntryView(
                        entry: nil,
                        vaultStore: vaultStore,
                        onSave: {
                            navigationPath.removeLast()
                            Task {
                                try? await vaultStore.reloadEntriesAsync()
                            }
                        }
                    )
                case .edit(let entry):
                    AddEditPasswordEntryView(
                        entry: entry,
                        vaultStore: vaultStore,
                        onSave: {
                            navigationPath.removeLast()
                            Task {
                                try? await vaultStore.reloadEntriesAsync()
                            }
                        }
                    )
                case .view(let entry):
                    ViewPasswordEntryView(
                        entry: entry,
                        vaultStore: vaultStore,
                        onEdit: { entry in
                            navigationPath.removeLast()
                            navigationPath.append(PasswordNavigation.edit(entry))
                        }
                    )
                case .changePassword:
                    ChangeMasterPasswordView(
                        vaultStore: vaultStore,
                        onComplete: {
                            navigationPath.removeLast()
                        }
                    )
                }
            }
        }
    }
}

/// Navigation destinations for the password manager
enum PasswordNavigation: Hashable {
    case add
    case edit(PasswordEntry)
    case view(PasswordEntry)
    case changePassword
}
