/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import UIKit

public protocol EmptyStateDelegate: class {
    var shouldDisplayEmptyState: Bool { get }
}

public protocol EmptyStateDataSource {
    var viewForEmptyState: UIView? { get }
    var imageForEmptyState: UIImage? { get }
    var titleForEmptyState: String? { get }
    var titleColorForEmptyState: UIColor? { get }
    var titleFontForEmptyState: UIFont? { get }
    var verticalSpacingForEmptyState: CGFloat? { get }
    var trimStrategyForEmptyState: EmptyStateView.TrimStrategy { get }
}

public protocol EmptyStateViewOwnerProtocol: class {
    var emptyStateDelegate: EmptyStateDelegate { get }
    var emptyStateDataSource: EmptyStateDataSource { get }

    func reloadEmptyState(animated: Bool)
    func updateEmptyState(animated: Bool)
    func updateEmptyStateInsets()

    var contentViewForEmptyState: UIView { get }
    var displayInsetsForEmptyState: UIEdgeInsets { get }
    var appearanceAnimatorForEmptyState: ViewAnimatorProtocol? { get }
    var dismissAnimatorForEmptyState: ViewAnimatorProtocol? { get }
}

public protocol EmptyStateListViewModelProtocol: class {
    var emptyStateView: UIView { get }

    var displayInsetsForEmptyState: UIEdgeInsets { get }
}
