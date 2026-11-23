//
//  GameStateManager.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import Foundation

class GameStateManager {

    // MARK: - Singleton
    static let shared = GameStateManager()

    private init() {}

    // MARK: - Game State
    private(set) var currentLevel: Int = 1

    // MARK: - Public Methods
    func advanceToNextLevel() {
        currentLevel += 1
    }

    func resetLevel() {
        currentLevel = 1
    }

    func isMaxLevelReached() -> Bool {
        currentLevel > Constants.Game.maxLevels
    }
}
