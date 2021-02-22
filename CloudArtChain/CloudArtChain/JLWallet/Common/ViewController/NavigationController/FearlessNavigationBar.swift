import UIKit

struct FearlessNavigationBarStyle {
    static let background: UIImage? = {
        return UIImage.background(from: UIColor.black)
    }()

    static let darkShadow: UIImage? = {
        return UIImage.background(from: UIColor.darkGray)
    }()

    static let lightShadow: UIImage? = {
        return UIImage.background(from: UIColor.lightGray)
    }()

    static let tintColor: UIColor? = {
        return UIColor.white
    }()

    static let titleAttributes: [NSAttributedString.Key: Any]? = {
        var titleTextAttributes = [NSAttributedString.Key: Any]()

        titleTextAttributes[.foregroundColor] = UIColor.white

        titleTextAttributes[.font] = UIFont.h3Title

        return titleTextAttributes
    }()
}
