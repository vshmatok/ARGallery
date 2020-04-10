//
//  MainViewController.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/2/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class MainViewController: UIViewController, Alertable {

    // MARK: - IBOutlets

    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var blureView: UIVisualEffectView!

    // MARK: - Properties

    private let videoHelper = ARVideoHelper()
    private let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")

    private var isRestartAvailable = true

    private var trackedImages: [TrackedImage] = []

    private var session: ARSession {
        return sceneView.session
    }

    private var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.session.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = ARConfigService.shared.selectedAlbum?.name

        blureView.isHidden = false
        trackedImages = ARConfigService.shared.referenceImages.map({ TrackedImage(name: $0.name ?? "", node: nil ) })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        session.pause()
    }

    // MARK: - Private

    private func displayErrorMessage(title: String, message: String) {
        blureView.isHidden = false

        let model = ActionModel(title: "Restart Session", style: .default) { [weak self] _ in
            self?.blureView.isHidden = true
            self?.resetTracking()
        }

        showAlert(model: .init(title: title, message: message, style: .alert, actions: [model]))
    }

    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARConfigService.shared.referenceImages
        configuration.maximumNumberOfTrackedImages = 3
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.blureView.isHidden = true
        }
    }

    private func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false

        resetTracking()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.isRestartAvailable = true
        }
    }
}

// MARK: - ARSCNViewDelegate

extension MainViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        let referenceImage = imageAnchor.referenceImage

        guard let refenceImageName = referenceImage.name,
            let videoURL = ARConfigService.shared.selectedAlbum?.content[refenceImageName] else {
                return
        }

        updateQueue.async { [weak self] in
            guard let self = self else { return }
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            planeNode.eulerAngles.x = -.pi / 2
            planeNode.runAction(self.imageHighlightAction,
                                completionHandler: {
                                    self.videoHelper.displayVideo(referenceImage: referenceImage,
                                                                  node: node,
                                                                  video: videoURL)
            })
            node.addChildNode(planeNode)

            for (index, trackedImage) in self.trackedImages.enumerated() {
                if trackedImage.name == referenceImage.name {
                    self.trackedImages[index].node = planeNode
                }
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            for trackedImage in trackedImages {
                if trackedImage.name == imageAnchor.referenceImage.name {
                    if !imageAnchor.isTracked {
                        session.remove(anchor: anchor)
                        trackedImage.node?.removeFromParentNode()
                    }
                    break
                }
            }
        }
    }
}

// MARK: - ARSessionDelegate

extension MainViewController: ARSessionDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }

        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]

        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")

        DispatchQueue.main.async { [weak self] in
            self?.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }

    func sessionWasInterrupted(_ session: ARSession) {
        blureView.isHidden = false
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        blureView.isHidden = true
        restartExperience()
    }

    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
}
