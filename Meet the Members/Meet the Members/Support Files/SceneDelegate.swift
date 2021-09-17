//
//  SceneDelegate.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // MARK: STEP 4: Setup entry point
        // Action Items:
        // - Read the code. Here's what it does and why we do it:
        //      Usually, the initial view controller is initialized by IB.
        //      But because we are not using IB for this project, we need to
        //      manually do the initialization in code. You can try to remove
        //      the five lines in this method and you will see a runtime
        //      error about entry point not set.
        
        //      This delegate method is called every time the App is launched.
        //      So we will use it to initialize a `StartVC` and assign it to the
        //      root view controller. This effectively makes `StartVC` our
        //      initial view controller.
        //
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.windowScene = windowScene
        window!.rootViewController = StartVC()
        window!.makeKeyAndVisible()
    }
    
    // More UIScene lifecycle delegate methods. Don't worry about them.

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

