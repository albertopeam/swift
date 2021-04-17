import UIKit
import PlaygroundSupport

//TODO: completion blocks in present, or replace by delegates
protocol RouterComponent {
    func set(viewControllers: [UIViewController], animated: Bool)
    func push(viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

struct LeafRouter: RouterComponent {
    weak var navigationController: UINavigationController?

    func set(viewControllers: [UIViewController], animated: Bool) {
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }

    func push(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}

struct CompoundRouter: RouterComponent {
    weak var navigationController: UINavigationController?

    var routers: [RouterComponent] = .init()

    func set(viewControllers: [UIViewController], animated: Bool) {
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }

    func push(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    //DOES IT WORK?
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if viewController is UINavigationController {
            let router = CompoundRouter(navigationController: navigationController)
            router.present(viewController: viewController, animated: animated)
        } else {
            navigationController?.present(viewController, animated: animated, completion: completion)
        }
    }

    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}

let viewController = UIViewController()
viewController.view.backgroundColor = .red
let modalViewController = UIViewController()
modalViewController.view.backgroundColor = .blue
let rootViewController = UINavigationController(rootViewController: viewController)
let modalNavigationController = UINavigationController(rootViewController: modalViewController)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = rootViewController

rootViewController.present(modalViewController, animated: true, completion: nil)
