//
//  ConstantsTests.swift
//  SpaceDestroyersTests
//
//  Created by lama alemadi on 23/11/2026.
//

import Testing
import CoreGraphics
@testable import SpaceDestroyers

@MainActor
struct ConstantsTests {

    @Test func maxLevelsIsPositive() {
        #expect(Constants.Game.maxLevels > 0)
    }

    @Test func invaderRowsIsPositive() {
        #expect(Constants.Invader.rows > 0)
    }

    @Test func playerStartsWithLives() {
        #expect(Constants.Player.startingLives > 0)
    }

    @Test func fireRateCooldownIsPositive() {
        #expect(Constants.Player.fireRateCooldown > 0)
    }
}
