//
//  SceneDelegate.swift
//  SimpleRollCall
//
//  Created by Michael Lin on 1/20/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // This syntax is called optional binding.
        // See: https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // UIScreen.main.bounds gives you the size of the phone screen.
        // It has the type CGRect, where CG stands for Core Graphic.
        // CGRect is often used in describing a frame (see https://developer.apple.com/documentation/uikit/uiview/1622621-frame) and it
        // has two important properties: `origin` which is a CGPoint (gives you the x and y),
        // and `size` which is a CGSize (gives you the width and height).
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // The ! stands for force unwrapping, this practice is also known as optional chaining.
        // Since window: UIWindow? (an optional UIWindow type), we need to unwrap before using it.
        // ! means our app would crash if window is a nil, which, in this case is preferable because
        // we would know that something is terribly wrong.
        window!.windowScene = windowScene
        
        // Create an instance of RollCallVC and assign it to the window's root view controller.
        window!.rootViewController = RollCallVC()
        
        window!.makeKeyAndVisible()
        
    }

    /*
     * Feel free to skim through the following parts, we don't expect you to
     * understand all these comments right now. We will talk about app life cycle management
     * later in the training program.
     */
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

