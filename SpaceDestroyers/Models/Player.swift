//
//  Player.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit

class Player: SKSpriteNode {

    private var canFire = true
    private var invincible = false

    private var lives: Int = Constants.Player.startingLives {
        didSet {
            if lives < 0 {
                kill()
            } else {
                respawn()
            }
        }
    }

    init() {
        let texture = SKTexture(imageNamed: "player1")

        super.init(
            texture: texture,
            color: SKColor.clear,
            size: texture.size()
        )

        // Configure collision detection
        self.physicsBody = SKPhysicsBody(
            texture: texture,
            size: self.size
        )
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask =
            CollisionCategories.player
        self.physicsBody?.contactTestBitMask =
            CollisionCategories.invaderBullet |
            CollisionCategories.invader
        self.physicsBody?.collisionBitMask =
            CollisionCategories.edgeBody
        self.physicsBody?.allowsRotation = false

        animate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Animate the ship's flame
    private func animate() {
        var playerTextures: [SKTexture] = []

        for i in 1...Constants.Player.animationFrameCount {
            playerTextures.append(
                SKTexture(imageNamed: "player\(i)")
            )
        }

        let playerAnimation = SKAction.repeatForever(
            SKAction.animate(
                with: playerTextures,
                timePerFrame: Constants.Player.animationTimePerFrame
            )
        )

        self.run(playerAnimation)
    }

    // Lose a life when hit, unless temporarily invincible
    func die() {
        if !invincible {
            self.lives -= 1
        }
    }

    // Return to the start menu
    func kill() {
        guard let scene = self.scene,
              let view = scene.view else {
            return
        }

        GameStateManager.shared.resetLevel()

        let gameOverScene = StartGameScene(size: scene.size)
        gameOverScene.scaleMode = scene.scaleMode

        let transitionType = SKTransition.flipHorizontal(
            withDuration: Constants.Game.sceneTransitionDuration
        )

        view.presentScene(gameOverScene, transition: transitionType)
    }

    // Blink while temporarily invincible
    func respawn() {
        invincible = true

        let fadeOutAction = SKAction.fadeOut(
            withDuration: Constants.Player.fadeOutDuration
        )
        let fadeInAction = SKAction.fadeIn(
            withDuration: Constants.Player.fadeInDuration
        )

        let fadeOutIn = SKAction.sequence([
            fadeOutAction,
            fadeInAction
        ])

        let fadeOutInAction = SKAction.repeat(
            fadeOutIn,
            count: Constants.Player.respawnBlinkCount
        )

        let setInvincibleFalse = SKAction.run {
            self.invincible = false
        }

        run(
            SKAction.sequence([
                fadeOutInAction,
                setInvincibleFalse
            ])
        )
    }

    // Fire a bullet and wait before allowing another shot
    func fireBullet(scene: SKScene) {
        guard canFire else { return }
        canFire = false

        let bullet = PlayerBullet(
            imageName: "laser",
            bulletSound: "laser.mp3"
        )

        bullet.position.x = self.position.x
        bullet.position.y = self.position.y + self.size.height / 2
        scene.addChild(bullet)

        let moveBulletAction = SKAction.move(
            to: CGPoint(
                x: self.position.x,
                y: scene.size.height + bullet.size.height
            ),
            duration: Constants.Player.bulletDuration
        )

        let removeBulletAction = SKAction.removeFromParent()

        bullet.run(
            SKAction.sequence([
                moveBulletAction,
                removeBulletAction
            ])
        )

        let waitToEnableFire = SKAction.wait(
            forDuration: Constants.Player.fireRateCooldown
        )

        run(waitToEnableFire, completion: {
            self.canFire = true
        })
    }
}
