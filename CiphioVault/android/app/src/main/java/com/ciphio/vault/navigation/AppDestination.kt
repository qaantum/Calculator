package com.ciphio.vault.navigation

sealed class AppDestination(val route: String) {
    data object Home : AppDestination("home")
    data object History : AppDestination("history")
    data object Settings : AppDestination("settings")
    data object Algorithms : AppDestination("algorithms")
    data object Terms : AppDestination("terms")
    data object Privacy : AppDestination("privacy")
    
    // Password Manager routes (modular - can be removed)
    data object PasswordManager : AppDestination("password_manager")
    data object PasswordManagerSetup : AppDestination("password_manager_setup")
    data object PasswordManagerUnlock : AppDestination("password_manager_unlock")
    data object PasswordManagerAdd : AppDestination("password_manager_add")
    data object PasswordManagerEdit : AppDestination("password_manager_edit")
    
    // Premium routes
    data object Premium : AppDestination("premium")
    data object Supporters : AppDestination("supporters")
}

