//
//  ARVideoHelper.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/2/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import ARKit
import UIKit

final class ARVideoHelper: NSObject {

    // MARK: - Public

    func displayVideo(referenceImage: ARReferenceImage,
                      node: SCNNode,
                      video: String) {
        let width = CGFloat(referenceImage.physicalSize.width)
        let height = CGFloat(referenceImage.physicalSize.height)

        let videoHolder = SCNNode()
        let videoHolderGeometry = SCNPlane(width: width, height: height)
        videoHolder.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        videoHolder.geometry = videoHolderGeometry

        if let videoURL = URL(string: video) {
            setupVideoOnNode(videoHolder, fromURL: videoURL)
        }

        node.addChildNode(videoHolder)
    }

    // MARK: - Private

    private func setupVideoOnNode(_ node: SCNNode, fromURL url: URL) {
        var videoPlayerNode: SKVideoNode!

        let videoPlayer = AVPlayer(url: url)

        videoPlayerNode = SKVideoNode(avPlayer: videoPlayer)
        videoPlayerNode.yScale = -1
        //videoPlayerNode.zRotation = .pi // video orientation 

        let spriteKitScene = SKScene(size: CGSize(width: 1024, height: 768))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayerNode.position = CGPoint(x: spriteKitScene.size.width / 2, y: spriteKitScene.size.height / 2)
        videoPlayerNode.size = spriteKitScene.size
        spriteKitScene.backgroundColor = .clear

        spriteKitScene.addChild(videoPlayerNode)

        node.geometry?.firstMaterial?.diffuse.contents = spriteKitScene

        videoPlayerNode.play()
        videoPlayer.volume = 0

        loopVideo(videoPlayer: videoPlayer)
    }

    // MARK: - Loop Video

    private func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer.currentItem,
                                               queue: nil) { _ in
                                                videoPlayer.seek(to: CMTime.zero)
                                                videoPlayer.play()
        }
    }
}
