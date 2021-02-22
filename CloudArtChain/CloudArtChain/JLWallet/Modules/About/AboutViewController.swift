import UIKit
import SoraUI

final class AboutViewController: UIViewController, AdaptiveDesignable {
    private struct Constants {
        static let logoTopOffset: CGFloat = 102.0
        static let tableTopOffset: CGFloat = 279
        static let heightFriction: CGFloat = 0.85
    }

    private enum Row {
        static let height: CGFloat = 48.0

        case website
        case opensource
        case social
        case writeUs
        case terms
        case privacy
    }

    private enum Section: Int, CaseIterable {
        static let height: CGFloat = 68.0

        case about

        var rows: [Row] {
            switch self {
            case .about:
                return [.website, .opensource, .social, .writeUs, .terms, .privacy]
            }
        }
    }

    var presenter: AboutPresenterProtocol!

    var locale: Locale?

    @IBOutlet private var tableView: UITableView!

    @IBOutlet private var logoTop: NSLayoutConstraint!
    @IBOutlet private var tableTop: NSLayoutConstraint!

    private var viewModel: AboutViewModel = AboutViewModel(website: "",
                                                           version: "",
                                                           social: "",
                                                           email: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        adjustLayout()
        configureTableView()

        presenter.setup()
    }

    private func adjustLayout() {
        if isAdaptiveHeightDecreased {
            logoTop.constant = Constants.logoTopOffset * designScaleRatio.height
                * Constants.heightFriction
            tableTop.constant = Constants.tableTopOffset * designScaleRatio.height
                * Constants.heightFriction
        }
    }

    // MARK: UITableView

    private func title(for section: Section) -> String {
        switch section {
        case .about:
            return "About"
        }
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "AboutTitleCell", bundle: Bundle.main), forCellReuseIdentifier: "aboutTitleCellId")
        tableView.register(UINib(nibName: "AboutDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "aboutDetailsCellId")

        let hiddableFooterSize = CGSize(width: tableView.bounds.width, height: 1.0)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero,
                                                         size: hiddableFooterSize))
    }

    private func prepareTitleCell(for tableView: UITableView,
                                  indexPath: IndexPath,
                                  title: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutTitleCellId",
                                                 for: indexPath) as! AboutTitleCell

        cell.bind(title: title)

        return cell
    }

    private func prepareDetailsCell(for tableView: UITableView,
                                    indexPath: IndexPath,
                                    title: String,
                                    subtitle: String,
                                    icon: UIImage?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutDetailsCellId",
                                                 for: indexPath) as! AboutDetailsCell

        cell.bind(title: title, subtitle: subtitle, icon: icon)

        return cell
    }
}

extension AboutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)!.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)!.rows[indexPath.row] {
        case .website:
            return prepareDetailsCell(for: tableView,
                                      indexPath: indexPath,
                                      title: "Official Website",
                                      subtitle: viewModel.website,
                                      icon: UIImage(named: "iconAboutWeb"))
        case .opensource:
            let versionTitle = "App version" + " " + viewModel.version
            return prepareDetailsCell(for: tableView,
                                         indexPath: indexPath,
                                         title: "Github Source Code",
                                         subtitle: versionTitle,
                                         icon: UIImage(named: "iconAboutGit"))
        case .social:
            return prepareDetailsCell(for: tableView,
                                      indexPath: indexPath,
                                      title: "Join Telegram Group",
                                      subtitle: viewModel.social,
                                      icon: UIImage(named: "iconAboutTg"))
        case .writeUs:
            return prepareDetailsCell(for: tableView,
                                      indexPath: indexPath,
                                      title: "Contact Us",
                                      subtitle: viewModel.email,
                                      icon: UIImage(named: "iconAboutEmail"))
        case .terms:
            return prepareTitleCell(for: tableView,
                                         indexPath: indexPath,
                                         title: "Terms and conditions")
        case .privacy:
            return prepareTitleCell(for: tableView,
                                    indexPath: indexPath,
                                    title: "Privacy policy")
        }
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Row.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let multiplier = isAdaptiveHeightDecreased ? designScaleRatio.height : 1.0
        return Section.height * multiplier
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = UINib(nibName: "AboutHeaderView", bundle: Bundle.main)
            .instantiate(withOwner: nil, options: nil).first as? AboutHeaderView else {
                return nil
        }

        view.bind(title: title(for: Section(rawValue: section)!))

        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section(rawValue: indexPath.section)!.rows[indexPath.row] {
        case .website:
            presenter.activateWebsite()
        case .opensource:
            presenter.activateOpensource()
        case .social:
            presenter.activateSocial()
        case .writeUs:
            presenter.activateWriteUs()
        case .terms:
            presenter.activateTerms()
        case .privacy:
            presenter.activatePrivacyPolicy()
        }
    }
}

extension AboutViewController: AboutViewProtocol {
    func didReceive(viewModel: AboutViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}
