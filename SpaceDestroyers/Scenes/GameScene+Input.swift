//
//  GameScene+Input.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit

extension GameScene {

    // MARK: - Input Handling

    // Apply tilt-based movement to the player
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(
            dx: accelerationX
                * Constants.Input.accelerometerVelocityMultiplier,
            dy: 0
        )
    }

    // Fire when the screen is tapped
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        player.fireBullet(scene: self)
    }

    // Move invaders every frame
    override func update(_ currentTime: TimeInterval) {
        moveInvaders()
    }
}
