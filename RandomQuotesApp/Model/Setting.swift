import UIKit

struct SettingItem {
    let title: String
    let detail: String?
    let action: SettingAction
}

enum SettingAction {
    case push(viewController: UIViewController)
    case openWeb(url: URL)
    case selector(action: () -> Void)
    case none
}
