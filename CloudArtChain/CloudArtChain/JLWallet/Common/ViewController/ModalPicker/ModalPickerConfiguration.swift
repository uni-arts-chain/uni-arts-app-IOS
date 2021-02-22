import Foundation
import SoraUI

extension ModalSheetPresentationStyle {
    static var fearless: ModalSheetPresentationStyle {
        let indicatorSize = CGSize(width: 35.0, height: 2.0)
        let headerStyle = ModalSheetPresentationHeaderStyle(preferredHeight: 20.0,
                                                            backgroundColor: UIColor.white,
                                                            cornerRadius: 20.0,
                                                            indicatorVerticalOffset: 2.0,
                                                            indicatorSize: indicatorSize,
                                                            indicatorColor: UIColor.lightGray)
        //UIColor(red: 0.0, green: 0.298, blue: 0.718, alpha: 0.7)
        let style = ModalSheetPresentationStyle(backdropColor: UIColor.black.withAlphaComponent(0.5),
                                                headerStyle: headerStyle)
        return style
    }
}

extension ModalSheetPresentationConfiguration {
    static var fearless: ModalSheetPresentationConfiguration {
        let appearanceAnimator = BlockViewAnimator(duration: 0.25,
                                                   delay: 0.0,
                                                   options: [.curveEaseOut])
        let dismissalAnimator = BlockViewAnimator(duration: 0.25,
                                                  delay: 0.0,
                                                  options: [.curveLinear])

        let configuration = ModalSheetPresentationConfiguration(contentAppearanceAnimator: appearanceAnimator,
                                                                contentDissmisalAnimator: dismissalAnimator,
                                                                style: ModalSheetPresentationStyle.fearless,
                                                                extendUnderSafeArea: true,
                                                                dismissFinishSpeedFactor: 0.6,
                                                                dismissCancelSpeedFactor: 0.6)
        return configuration
    }
}
