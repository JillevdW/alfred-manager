//
//  ViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    init() {
        onCreate()
    }
    
    deinit {
        onDestroy()
    }
    
    /// A set used to store `AnyCancellable` objects returned by `Combine` subscriptions that
    /// should be restricted to the lifecycle of this `ViewModel`.
    ///
    /// If no strong references to `self` are created through `sink` closures or usage of `assign`,
    /// the `Cancellables` in this `Set` will automatically be cancelled when this `ViewModel`
    /// is deinitialized.
    var lifecycle: Set<AnyCancellable> = []
    
    /// Called when the `ViewModel` is initialized. If this is bound to an `@StateObject`
    /// property wrapper on a `View`, this is evaluated when the `View` body is first drawn.
    func onCreate() {}
    
    /// Called when the `ViewModel` is deinitialized. If this is bound to an `@StateObject`
    /// property wrapper on a `View`, this is evaluated when the `View` is no longer in the hierarchy.
    ///
    /// TODO: By default, this clears all cancellables stored in the `cancellables` `Set`.
    func onDestroy() {}
}
