//
//  GameScene+InvaderManagement.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit

extension GameScene {

    // MARK: - Invader Management

    // Move invaders sideways and drop them at the edges
    func moveInvaders() {
        var changeDirection = false

        enumerateChildNodes(withName: "invader") { node, _ in
            guard let invader = node as? SKSpriteNode else {
                return
            }

            let invaderHalfWidth =
                Constants.Invader.widthMultiplier
                * invader.size.width / 2

            invader.position.x -= CGFloat(self.invaderSpeed)

            if invader.position.x > self.size.width - invaderHalfWidth
                || invader.position.x < self.leftBounds + invaderHalfWidth {
                changeDirection = true
            }
        }

        if changeDirection {
            self.invaderSpeed *= -1

            self.enumerateChildNodes(withName: "invader") { node, _ in
                guard let invader = node as? SKSpriteNode else {
                    return
                }

                invader.position.y -= Constants.Invader.dropDistance
            }
        }
    }

    // Make invaders fire repeatedly
    func invokeInvaderFire() {
        let fireBullet = SKAction.run {
            self.fireInvaderBullet()
        }

        let waitToFireInvaderBullet = SKAction.wait(
            forDuration: Constants.Invader.fireInterval
        )

        let invaderFire = SKAction.sequence([
            fireBullet,
            waitToFireInvaderBullet
        ])

        let repeatForeverAction = SKAction.repeatForever(invaderFire)

        run(repeatForeverAction)
    }

    // Fire from a random eligible invader, or complete the level
    func fireInvaderBullet() {
        if invadersWhoCanFire.isEmpty {
            GameStateManager.shared.advanceToNextLevel()
            levelComplete()
        } else if let randomInvader = invadersWhoCanFire.randomElement() {
            randomInvader.fireBullet(scene: self)
        }
    }
}
