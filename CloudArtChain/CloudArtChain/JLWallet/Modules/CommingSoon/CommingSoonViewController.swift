import UIKit
import SoraFoundation
import SwiftGifOrigin

final class CommingSoonViewController: UIViewController {
    var presenter: CommingSoonPresenterProtocol!

    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var devStatusButton: TriangularedButton!
    @IBOutlet private var roadmapButton: TriangularedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        loadBackground()

        presenter.setup()
    }

    func loadBackground() {
        backgroundImageView.image = UIImage.gif(name: "animatedBgGif")
    }

    func setupLocalization() {
        let locale = localizationManager?.selectedLocale

        titleLabel.text = "Coming soon…"
        devStatusButton.imageWithTitleView?.title = "Check Dev Status"
        roadmapButton.imageWithTitleView?.title = "Check Roadmap"
    }

    @IBAction func actionDevStatus() {
        presenter.activateDevStatus()
    }

    @IBAction func actionRoadmap() {
        presenter.activateRoadmap()
    }
}

extension CommingSoonViewController: CommingSoonViewProtocol {}

extension CommingSoonViewController: Localizable {
    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
            view.setNeedsLayout()
        }
    }
}
