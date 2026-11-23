//
//  Bullet.swift
//  SpaceDestroyers
//
//  Created by lama alemadi on 23/11/2026.
//

import SpriteKit

class Bullet: SKSpriteNode {

    init(imageName: String, bulletSound: String?) {
        let texture = SKTexture(imageNamed: imageName)

        super.init(
            texture: texture,
            color: SKColor.clear,
            size: texture.size()
        )

        if let sound = bulletSound {
            run(
                SKAction.playSoundFileNamed(
                    sound,
                    waitForCompletion: false
                )
            )
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
