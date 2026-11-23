//
//  GameStateManagerTests.swift
//  SpaceDestroyersTests
//
//  Created by lama alemadi on 23/11/2026.
//

import Testing
import Foundation
@testable import SpaceDestroyers

@MainActor
@Suite(.serialized)
struct GameStateManagerTests {

    private func freshManager() -> GameStateManager {
        let manager = GameStateManager.shared
        manager.resetLevel()
        return manager
    }

    @Test func resetsToLevelOne() {
        let manager = freshManager()
        manager.advanceToNextLevel()
        manager.advanceToNextLevel()
        manager.resetLevel()
        #expect(manager.currentLevel == 1)
    }

    @Test func advanceIncrementsLevel() {
        let manager = freshManager()
        manager.advanceToNextLevel()
        #expect(manager.currentLevel == 2)
    }

    @Test func isMaxLevelReachedRespectsConstantsMaxLevels() {
        let manager = freshManager()

        for _ in 1...Constants.Game.maxLevels {
            #expect(!manager.isMaxLevelReached())
            manager.advanceToNextLevel()
        }

        #expect(manager.isMaxLevelReached())
    }
}
