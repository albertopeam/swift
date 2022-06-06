//
//  AppDelegate.swift
//  bumble
//
//  Created by Alberto Penas Amor on 24/5/22.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let operationQueue: OperationQueue = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("\(#function) \(application.applicationState.description)")
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: MyModule.assemble())
        window.makeKeyAndVisible()
        self.window = window

        registerBGTasks()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("\(#function) \(application.applicationState.description)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("\(#function) \(application.applicationState.description)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("\(#function) \(application.applicationState.description)")
        scheduleNewRequest()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("\(#function) \(application.applicationState.description)")
    }
}

extension UIApplication.State: CustomStringConvertible {
    public var description: String {
        switch self {
            case .active: return "active"
            case .inactive: return "inactive"
            case .background: return "background"
            @unknown default: fatalError("unknow case")
        }
    }
}

private extension AppDelegate {
    func registerBGTasks() {
        // https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/using_background_tasks_to_update_your_app
        // https://developer.apple.com/documentation/backgroundtasks/bgtaskschedulererrorcode/bgtaskschedulererrorcodeunavailable?language=objc
        // NOT works in sim
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.github.albertopeam.computeTask",
                                        using: DispatchQueue.main) { task in
            guard let task  = task as? BGProcessingTask else {
                print("Can't cast task as BGProcessingTaskRequest \(task.description)")
                return
            }
            self.schedule(task: task)
        }
    }

    func schedule(task: BGProcessingTask) {
        scheduleNewRequest()
        handleCurrent(task: task)
    }

    func scheduleNewRequest() {
        let request = BGProcessingTaskRequest(identifier: "com.github.albertopeam.computeTask")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        request.requiresExternalPower = false
        request.requiresNetworkConnectivity = false

       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }

    func handleCurrent(task: BGProcessingTask) {
       // Create an operation that performs the main part of the background task.
        let operation = BackgroundOperationFactory.operation()

       // Provide the background task with an expiration handler that cancels the operation.
       task.expirationHandler = {
          operation.cancel()
       }

       // Inform the system that the background task is complete
       // when the operation completes.
       operation.completionBlock = {
          task.setTaskCompleted(success: !operation.isCancelled)
       }

       // Start the operation.
       operationQueue.addOperation(operation)
     }
}

enum BackgroundOperationFactory {
    static func operation() -> BlockOperation {
        .init {
            print("started operation \(Date())")
            Thread.sleep(forTimeInterval: 5)
            print("ended operation \(Date())")
        }
    }
}
