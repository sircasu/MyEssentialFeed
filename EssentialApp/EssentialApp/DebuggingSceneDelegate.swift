//
//  DebuggingSceneDelegate.swift
//  EssentialApp
//
//  Created by Matteo Casu on 26/01/24.
//

#if DEBUG
import UIKit
import MyEssentialFeed

class DebuggingSceneDelegate: SceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }


        if CommandLine.arguments.contains("-reset") { // different way to get launch argument (instead of UserDefaults.standard that care about value)
            try? FileManager.default.removeItem(at: localStoreURL)
        }

        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    
    override func makeRemoteClient() -> HTTPClient {

        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            
            return AlwaysFailingHTTPClient()
        }

        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
}

private class AlwaysFailingHTTPClient: HTTPClient {
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> MyEssentialFeed.HTTPClientTask {
        completion(.failure(NSError(domain: "offline", code: 0)))
        return Task()
    }
    
}
#endif
