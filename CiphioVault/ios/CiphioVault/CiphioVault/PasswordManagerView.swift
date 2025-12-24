import SwiftUI
import LocalAuthentication
import Security

/// Main password manager view that handles navigation between screens.
struct PasswordManagerView: View {
    @StateObject private var vaultStore: PasswordVaultStore
    @State private var selectedNavigation: PasswordNavigation?
    
    private let cryptoService: CryptoService
    
    init(cryptoService: CryptoService) {
        self.cryptoService = cryptoService
        _vaultStore = StateObject(wrappedValue: PasswordVaultStore(cryptoService: cryptoService))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !vaultStore.hasMasterPassword {
                    MasterPasswordSetupView(vaultStore: vaultStore, onSetupComplete: {
                        // Setup complete, view will automatically update via @Published property
                    })
                } else if !vaultStore.isUnlocked {
                    MasterPasswordUnlockView(vaultStore: vaultStore, onUnlockComplete: {
                        // Unlock complete, will show list
                    })
                } else {
                    PasswordManagerListView(
                        vaultStore: vaultStore,
                        onAddEntry: {
                            selectedNavigation = .add
                        },
                        onViewEntry: { entry in
                            selectedNavigation = .view(entry)
                        },
                        onEditEntry: { entry in
                            selectedNavigation = .edit(entry)
                        },
                        onChangePassword: {
                            selectedNavigation = .changePassword
                        },
                        onLock: {
                            vaultStore.lock()
                        }
                    )
                }
            }
            .background(
                NavigationLink(
                    destination: destinationView,
                    isActive: Binding(
                        get: { selectedNavigation != nil },
                        set: { if !$0 { selectedNavigation = nil } }
                    )
                ) {
                    EmptyView()
                }
            )
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if let navigation = selectedNavigation {
            switch navigation {
            case .add:
                AddEditPasswordEntryView(
                    entry: nil,
                    vaultStore: vaultStore,
                    onSave: {
                        selectedNavigation = nil
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
                        selectedNavigation = nil
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
                        selectedNavigation = .edit(entry)
                    }
                )
            case .changePassword:
                ChangeMasterPasswordView(
                    vaultStore: vaultStore,
                    onComplete: {
                        selectedNavigation = nil
                    }
                )
            }
        } else {
            EmptyView()
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
