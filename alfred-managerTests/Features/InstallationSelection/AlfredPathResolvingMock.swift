//
//  AlfredPathResolvingMock.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation

class AlfredPathResolvingMock: AlfredPathResolving {
    var urlsCallCount: Int = 0
    var urlsHandler: () -> Result<[URL], AlfredPathResolver.Error> = { fatalError("urlsHandler not set") }
    
    func urls() -> Result<[URL], AlfredPathResolver.Error> {
        urlsCallCount += 1
        return urlsHandler()
    }
}
