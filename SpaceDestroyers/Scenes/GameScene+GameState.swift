//
//  GameScene+GameState.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit

extension GameScene {

    // MARK: - Game State Management

    // Return to the start menu
    func newGame() {
        let startScene = StartGameScene(size: size)
        startScene.scaleMode = scaleMode

        let transition = SKTransition.flipHorizontal(
            withDuration: Constants.Game.sceneTransitionDuration
        )

        view?.presentScene(startScene, transition: transition)
    }

    // Show the next-level menu or restart after the final level
    func levelComplete() {
        if !GameStateManager.shared.isMaxLevelReached() {
            let levelCompleteScene = LevelCompleteScene(size: size)
            levelCompleteScene.scaleMode = scaleMode

            let transition = SKTransition.flipHorizontal(
                withDuration: Constants.Game.sceneTransitionDuration
            )

            view?.presentScene(
                levelCompleteScene,
                transition: transition
            )
        } else {
            GameStateManager.shared.resetLevel()
            newGame()
        }
    }
}
