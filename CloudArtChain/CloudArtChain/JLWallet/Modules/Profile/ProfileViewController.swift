import UIKit
import SoraFoundation
import FearlessUtils

final class ProfileViewController: UIViewController {
    private struct Constants {
        static let optionCellHeight: CGFloat = 48.0
        static let sectionCellHeight: CGFloat = 56.0
        static let detailsCellHeight: CGFloat = 86.0
        static let headerInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16, right: 16.0)
    }

    var presenter: ProfilePresenterProtocol!

    var iconGenerating: IconGenerating?

    @IBOutlet private var tableView: UITableView!

    private(set) var optionViewModels: [ProfileOptionViewModelProtocol] = []
    private(set) var userViewModel: ProfileUserViewModelProtocol?
    private(set) var userIcon: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        configureTableView()

        presenter.setup()
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: Bundle.main),
                                     forCellReuseIdentifier: "profileCellId")

        tableView.register(UINib(nibName: "ProfileDetailsTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "profileDetailsCellId")

        tableView.register(UINib(nibName: "ProfileSectionTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "profileSectionCellId")

        tableView.alwaysBounceVertical = false
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionViewModels.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileSectionCellId",
                                                     for: indexPath) as! ProfileSectionTableViewCell

            let locale = localizationManager?.selectedLocale
            cell.titleLabel.text = "Settings"

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailsCellId",
                                                     for: indexPath) as! ProfileDetailsTableViewCell

            if let userViewModel = userViewModel {
                cell.bind(model: userViewModel, icon: userIcon)
            }

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellId",
                                                     for: indexPath) as! ProfileTableViewCell

            cell.bind(viewModel: optionViewModels[indexPath.row - 2])

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return Constants.sectionCellHeight
        case 1:
            return Constants.detailsCellHeight
        default:
            return Constants.optionCellHeight
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 1 {
            presenter.activateAccountDetails()
        } else if indexPath.row >= 2 {
            presenter.activateOption(at: UInt(indexPath.row) - 2)
        }
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func didLoad(userViewModel: ProfileUserViewModelProtocol) {
        self.userViewModel = userViewModel
        self.userIcon = try! iconGenerating?.generateFromAddress(userViewModel.details)
            .imageWithFillColor(.white,
                                size: UIConstants.normalAddressIconSize,
                                contentScale: UIScreen.main.scale)
        tableView.reloadData()
    }

    func didLoad(optionViewModels: [ProfileOptionViewModelProtocol]) {
        self.optionViewModels = optionViewModels
        tableView.reloadData()
    }
}

extension ProfileViewController: Localizable {
    private func setupLocalization() {
        tableView.reloadData()
    }

    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
            view.setNeedsLayout()
        }
    }
}
