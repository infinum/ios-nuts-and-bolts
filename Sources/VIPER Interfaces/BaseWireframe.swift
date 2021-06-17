import UIKit
import RxSwift
import RxCocoa
import SafariServices

protocol WireframeInterface: AnyObject {
    func openAlert<T>(
        title: String?,
        message: String?,
        actions: [AlertAction<T>],
        style: UIAlertController.Style
    ) -> Maybe<T>
}

open class BaseWireframe {
    
    let disposeBag = DisposeBag()

    // Needs to have an underscore to diferentiate it from the
    // computed one.
    private unowned var _viewController: UIViewController
    
    // To retain view controller reference upon first access
    private var temporaryStoredViewController: UIViewController?
    
    public init(viewController: UIViewController) {
        temporaryStoredViewController = viewController
        _viewController = viewController
    }
    
    public func openURL(_ url: URL?, insideApp: Bool = true) {
        guard let url = url else { return }
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") && insideApp {
            // Can open with SFSafariViewController
            let safariViewController = SFSafariViewController(url: url)
            viewController.present(safariViewController, animated: true)
        } else {
            // Scheme is not supported or no scheme is given, use openURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension BaseWireframe: WireframeInterface {
    
    func openAlert<T>(
        title: String?,
        message: String?,
        actions: [AlertAction<T>],
        style: UIAlertController.Style
    ) -> Maybe<T> {
        return UIAlertController.present(
            on: viewController,
            title: title,
            message: message,
            actions: actions,
            style: style
        )
    }
    
}

extension BaseWireframe {
    
    var viewController: UIViewController {
        defer { temporaryStoredViewController = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
}

extension UIViewController {
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
}

extension UINavigationController {
    
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        setViewControllers([wireframe.viewController], animated: animated)
    }
    
}
