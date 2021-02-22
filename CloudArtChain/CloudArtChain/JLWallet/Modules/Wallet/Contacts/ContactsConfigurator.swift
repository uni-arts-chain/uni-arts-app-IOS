import Foundation
import IrohaCrypto
import CommonWallet
import SoraFoundation

final class ContactsConfigurator {
    private var localSearchEngine: ContactsLocalSearchEngine

    private lazy var contactsViewStyle: ContactsViewStyleProtocol = {
        let searchTextStyle = WalletTextStyle(font: UIFont.p1Paragraph,
                                              color: UIColor.white)
        let searchPlaceholderStyle = WalletTextStyle(font: UIFont.p1Paragraph,
                                                     color: UIColor.lightGray)

        let searchStroke = WalletStrokeStyle(color: UIColor.gray,
                                             lineWidth: 1.0)
        let searchFieldStyle = WalletRoundedViewStyle(fill: .clear,
                                                      cornerRadius: 8.0,
                                                      stroke: searchStroke)

        return ContactsViewStyle(backgroundColor: UIColor.black,
                                 searchHeaderBackgroundColor: UIColor.black,
                                 searchTextStyle: searchTextStyle,
                                 searchPlaceholderStyle: searchPlaceholderStyle,
                                 searchFieldStyle: searchFieldStyle,
                                 searchIndicatorStyle: UIColor.gray,
                                 searchIcon: UIImage(named: "iconSearch"),
                                 searchSeparatorColor: .clear,
                                 tableSeparatorColor: UIColor.darkGray,
                                 actionsSeparator: WalletStrokeStyle(color: .clear, lineWidth: 0.0))
    }()

    private lazy var contactCellStyle: ContactCellStyleProtocol = {
        let iconStyle = WalletNameIconStyle(background: .white,
                                            title: WalletTextStyle(font: UIFont.p1Paragraph, color: .black),
                                            radius: 12.0)
        return ContactCellStyle(title: WalletTextStyle(font: UIFont.p1Paragraph, color: .white),
                                nameIcon: iconStyle,
                                accessoryIcon: UIImage(named: "iconSmallArrow"),
                                lineBreakMode: .byTruncatingMiddle,
                                selectionColor: UIColor.blue.withAlphaComponent(0.3))
    }()

    private lazy var sectionHeaderStyle: ContactsSectionStyleProtocol = {
        let title = WalletTextStyle(font: UIFont.capsTitle,
                                    color: UIColor.lightGray)
        return ContactsSectionStyle(title: title,
                                    uppercased: true,
                                    height: 30.0,
                                    displaysSeparatorForLastCell: false)
    }()

    init(networkType: SNAddressType) {
        let viewModelFactory = ContactsViewModelFactory()
        localSearchEngine = ContactsLocalSearchEngine(networkType: networkType,
                                                      contactViewModelFactory: viewModelFactory)
    }

    func configure(builder: ContactsModuleBuilderProtocol) {
        let listViewModelFactory = ContactsListViewModelFactory()

        let searchPlaceholder = LocalizableResource { locale in
            "Account address or account name"
        }

        builder
            .with(cellClass: ContactTableViewCell.self, for: ContactsConstants.contactCellIdentifier)
            .with(localSearchEngine: localSearchEngine)
            .with(listViewModelFactory: listViewModelFactory)
            .with(canFindItself: true)
            .with(supportsLiveSearch: true)
            .with(searchEmptyStateDataSource: WalletEmptyStateDataSource.search)
            .with(contactsEmptyStateDataSource: WalletEmptyStateDataSource.contacts)
            .with(viewStyle: contactsViewStyle)
            .with(contactCellStyle: contactCellStyle)
            .with(sectionHeaderStyle: sectionHeaderStyle)
            .with(searchPlaceholder: searchPlaceholder)
            .with(viewModelFactoryWrapper: localSearchEngine.contactViewModelFactory)
    }
}
