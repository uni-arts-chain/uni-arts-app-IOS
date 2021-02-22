import UIKit

extension CompoundAttributedStringDecorator {
    static func legal(for locale: Locale?) -> AttributedStringDecoratorProtocol {
        let textColor = UIColor.white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: UIFont.p1Paragraph
        ]

        let rangeDecorator = RangeAttributedStringDecorator(attributes: attributes)

        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPink
        ]

        let termsConditions = "Terms and Conditions"
        let termDecorator = HighlightingAttributedStringDecorator(pattern: termsConditions,
                                                                           attributes: highlightAttributes)

        let privacyPolicy = "Privacy Policy"
        let privacyDecorator = HighlightingAttributedStringDecorator(pattern: privacyPolicy,
                                                                     attributes: highlightAttributes)

        return CompoundAttributedStringDecorator(decorators: [rangeDecorator, termDecorator, privacyDecorator])
    }
}
