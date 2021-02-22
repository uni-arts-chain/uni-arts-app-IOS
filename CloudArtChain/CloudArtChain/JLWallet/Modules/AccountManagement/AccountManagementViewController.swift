import UIKit
import SoraFoundation
import SoraUI

final class AccountManagementViewController: UIViewController {
    private struct Constants {
        static let cellHeight: CGFloat = 48.0
        static let headerHeight: CGFloat = 33.0
        static let headerId = "accountHeaderId"
        static let bottomContentHeight: CGFloat = 48
    }

    var presenter: AccountManagementPresenterProtocol!

    @IBOutlet private var tableView: UITableView!

    @IBOutlet private var bottomBarHeight: NSLayoutConstraint!

    @IBOutlet private var addActionControl: IconCellControlView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationItem()
        setupLocalization()

        presenter.setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bottomBarHeight.constant = Constants.bottomContentHeight + view.safeAreaInsets.bottom
    }

    private func setupNavigationItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(actionEdit))

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.h5Title
        ]

        rightBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        rightBarButtonItem.setTitleTextAttributes(attributes, for: .highlighted)

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setupLocalization() {
        title = "Accounts"

        addActionControl.imageWithTitleView?.title = "Add account"

        updateRightItem()
    }

    private func updateRightItem() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "accountCellId")
        tableView.register(UINib(nibName: "IconTitleHeaderView", bundle: Bundle.main),
                           forHeaderFooterViewReuseIdentifier: Constants.headerId)
    }

    @objc func actionEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        updateRightItem()

        for cell in tableView.visibleCells {
            if let accountCell = cell as? AccountTableViewCell {
                accountCell.setReordering(tableView.isEditing, animated: true)
            }
        }
    }

    @IBAction func actionAdd() {
        presenter.activateAddAccount()
    }
}

// swiftlint:disable force_cast
extension AccountManagementViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerId) as! IconTitleHeaderView

        let section = presenter.section(at: section)
        view.bind(title: section.title, icon: section.icon)

        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.section(at: section).items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCellId",
                                                 for: indexPath) as! AccountTableViewCell

        cell.delegate = self
        cell.setReordering(tableView.isEditing, animated: false)

        let item = presenter.section(at: indexPath.section).items[indexPath.row]
        cell.bind(viewModel: item)

        return cell
    }
}
// swiftlint:enable force_cast

extension AccountManagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        presenter.selectItem(at: indexPath.row, in: indexPath.section)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        presenter.moveItem(at: sourceIndexPath.row,
                           to: destinationIndexPath.row,
                           in: destinationIndexPath.section)
    }

    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section < sourceIndexPath.section {
            return IndexPath(row: 0, section: sourceIndexPath.section)
        } else if proposedDestinationIndexPath.section > sourceIndexPath.section {
            let count = tableView.numberOfRows(inSection: sourceIndexPath.section)
            return IndexPath(row: count - 1, section: sourceIndexPath.section)
        } else {
            return proposedDestinationIndexPath
        }
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        !presenter.section(at: indexPath.section).items[indexPath.row].isSelected ? .delete : .none
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)

        if numberOfRows == 1 {
            presenter.removeSection(at: indexPath.section)
        } else {
            presenter.removeItem(at: indexPath.row, in: indexPath.section)
        }
    }
}

extension AccountManagementViewController: AccountManagementViewProtocol {
    func reload() {
        tableView.reloadData()
    }

    func didRemoveItem(at index: Int, in section: Int) {
        let indexPath = IndexPath(row: index, section: section)
        tableView.deleteRows(at: [indexPath], with: .left)
    }

    func didRemoveSection(at section: Int) {
        tableView.deleteSections([section], with: .automatic)
    }
}

extension AccountManagementViewController: Localizable {
    func applyLocalization() {
        if isViewLoaded {
            setupLocalization()
        }
    }
}

extension AccountManagementViewController: AccountTableViewCellDelegate {
    func didSelectInfo(_ cell: AccountTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        presenter.activateDetails(at: indexPath.row, in: indexPath.section)
    }
}
