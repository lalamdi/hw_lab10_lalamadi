//
//  GameScene+Setup.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit
import CoreMotion

extension GameScene {

    // MARK: - Setup Methods

    // Configure tilt controls
    func setupAccelerometer() {
        guard motionManager.isAccelerometerAvailable,
              let currentQueue = OperationQueue.current else {
            return
        }

        motionManager.accelerometerUpdateInterval =
            Constants.Input.accelerometerUpdateInterval

        motionManager.startAccelerometerUpdates(to: currentQueue) {
            data, error in

            if let acceleration = data?.acceleration {
                self.accelerationX = CGFloat(acceleration.x)
            }
        }
    }

    // Create the invader grid for the current level
    func setupInvaders() {
        let currentLevel = GameStateManager.shared.currentLevel

        let numberOfInvaders =
            currentLevel * Constants.Invader.invadersPerLevelMultiplier
            + Constants.Invader.invadersPerLevelBase

        for i in 1...rowsOfInvaders {
            for j in 1...numberOfInvaders {
                let tempInvader = Invader()
                let invaderHalfWidth = tempInvader.size.width / 2

                let xPositionStart =
                    size.width / 2 - invaderHalfWidth
                    - (CGFloat(currentLevel) * tempInvader.size.width)
                    + Constants.Invader.horizontalSpacing

                tempInvader.position = CGPoint(
                    x: xPositionStart
                        + ((tempInvader.size.width
                            + Constants.Invader.horizontalSpacing)
                           * CGFloat(j - 1)),
                    y: self.size.height
                        - CGFloat(i) * Constants.Invader.verticalSpacing
                )

                tempInvader.invaderRow = i
                tempInvader.invaderColumn = j

                addChild(tempInvader)

                // Only the bottom row can initially fire
                if i == rowsOfInvaders {
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }

    // Position the player at the bottom center
    func setupPlayer() {
        player.position = CGPoint(
            x: self.frame.midX,
            y: player.size.height / 2 + Constants.Player.bottomOffset
        )

        addChild(player)
    }

    // Set up the scene when it appears
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask =
            CollisionCategories.edgeBody

        backgroundColor = SKColor.black

        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
        setupAccelerometer()
    }
}
