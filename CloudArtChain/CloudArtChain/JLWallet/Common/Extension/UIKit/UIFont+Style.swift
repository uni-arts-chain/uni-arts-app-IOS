import UIKit

extension UIFont {
    static var h1Title: UIFont { UIFont.systemFont(ofSize: 30) }

    static var h2Title: UIFont { UIFont.systemFont(ofSize: 22) }

    static var h3Title: UIFont { UIFont.systemFont(ofSize: 18) }

    static var h4Title: UIFont { UIFont.systemFont(ofSize: 16) }

    static var h5Title: UIFont { UIFont.systemFont(ofSize: 14) }

    static var h6Title: UIFont { UIFont.systemFont(ofSize: 12) }

    static var capsTitle: UIFont { UIFont.systemFont(ofSize: 10) }

    static var p0Paragraph: UIFont { UIFont.systemFont(ofSize: 16) }

    static var p0Digits: UIFont {
        let fontFeatures = [
            [
                UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
            ],

            [
                UIFontDescriptor.FeatureKey.featureIdentifier: kNumberCaseType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseNumbersSelector
            ]
        ]

        let fontDescriptor = UIFont.systemFont(ofSize: 16).fontDescriptor
            .addingAttributes([UIFontDescriptor.AttributeName.featureSettings: fontFeatures])

        return UIFont(descriptor: fontDescriptor, size: 16)
    }

    static var p1Paragraph: UIFont { UIFont.systemFont(ofSize: 14) }

    static var p2Paragraph: UIFont { UIFont.systemFont(ofSize: 12) }

    static var p3Paragraph: UIFont { UIFont.systemFont(ofSize: 10) }
}
