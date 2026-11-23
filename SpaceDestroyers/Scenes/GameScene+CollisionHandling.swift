//
//  GameScene+CollisionHandling.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit

extension GameScene {

    // MARK: - Collision Handling

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody

        // Put the lower category first
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        // Player bullet hits an invader
        if (firstBody.categoryBitMask
            & CollisionCategories.invader != 0)
            && (secondBody.categoryBitMask
                & CollisionCategories.playerBullet != 0) {

            guard let invader = firstBody.node as? Invader,
                  let bullet = secondBody.node,
                  invader.parent != nil,
                  bullet.parent != nil else {
                return
            }

            handleInvaderHit(invader: invader, bullet: bullet)
        }

        // Invader bullet hits the player
        if (firstBody.categoryBitMask
            & CollisionCategories.player != 0)
            && (secondBody.categoryBitMask
                & CollisionCategories.invaderBullet != 0) {

            player.die()
        }

        // Invader touches the player
        if (firstBody.categoryBitMask
            & CollisionCategories.invader != 0)
            && (secondBody.categoryBitMask
                & CollisionCategories.player != 0) {

            player.kill()
        }
    }

    // MARK: - Helper Methods

    private func handleInvaderHit(invader: Invader, bullet: SKNode) {
        let newInvaderRow = invader.invaderRow - 1
        let newInvaderColumn = invader.invaderColumn

        // Allow the invader above the destroyed one to fire
        if newInvaderRow >= 1 {
            self.enumerateChildNodes(withName: "invader") { node, _ in
                guard let invader = node as? Invader else {
                    return
                }

                if invader.invaderRow == newInvaderRow
                    && invader.invaderColumn == newInvaderColumn {

                    self.invadersWhoCanFire.append(invader)
                }
            }
        }

        // Remove the destroyed invader from the firing list
        if let invaderIndex = invadersWhoCanFire.firstIndex(of: invader) {
            invadersWhoCanFire.remove(at: invaderIndex)
        }

        invader.removeFromParent()
        bullet.removeFromParent()
    }
}
