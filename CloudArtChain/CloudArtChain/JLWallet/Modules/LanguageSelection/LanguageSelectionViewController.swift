import UIKit
import Rswift
import SoraFoundation

final class LanguageSelectionViewController: SelectionListViewController<SelectionSubtitleTableViewCell> {
    var presenter: LanguageSelectionPresenterProtocol!

    override var selectableCellIdentifier: ReuseIdentifier<SelectionSubtitleTableViewCell>! {
        return Rswift.ReuseIdentifier(identifier: "selectionSubtitleCellId")
    }

    override var selectableCellNib: UINib? {
        return UINib(nibName: "SelectionSubtitleTableViewCell", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyLocalization()

        presenter.setup()
    }
}

extension LanguageSelectionViewController: LanguageSelectionViewProtocol {}

extension LanguageSelectionViewController: Localizable {
    func applyLocalization() {
        let languages = localizationManager?.preferredLocalizations
        title = "Language"
    }
}
