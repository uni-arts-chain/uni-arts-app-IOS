/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

/**
 *  Class is designed to apply type erasure technique to ```DataProviderRepositoryProtocol```.
 */

public final class AnyDataProviderRepository<T: Identifiable>: DataProviderRepositoryProtocol {
    public typealias Model = T

    private let _fetchByModelId: (String, RepositoryFetchOptions) -> BaseOperation<Model?>
    private let _fetchAll: (RepositoryFetchOptions) -> BaseOperation<[Model]>
    private let _fetchByOffsetCount: (RepositorySliceRequest, RepositoryFetchOptions)
    -> BaseOperation<[Model]>
    private let _save: (@escaping () throws -> [Model], @escaping () throws -> [String]) -> BaseOperation<Void>
    private let _replace: (@escaping () throws -> [Model]) -> BaseOperation<Void>
    private let _deleteAll: () -> BaseOperation<Void>
    private let _fetchCount: () -> BaseOperation<Int>

    /**
     *  Initializes type erasure wrapper for repository implementation.
     *
     *  - parameters:
     *    - repository: Repository implementation to erase type of.
     */

    public init<U: DataProviderRepositoryProtocol>(_ repository: U) where U.Model == Model {
        _fetchByModelId = repository.fetchOperation
        _fetchAll = repository.fetchAllOperation
        _fetchByOffsetCount = repository.fetchOperation
        _save = repository.saveOperation
        _replace = repository.replaceOperation
        _deleteAll = repository.deleteAllOperation
        _fetchCount = repository.fetchCountOperation
    }

    public func fetchOperation(by modelId: String,
                               options: RepositoryFetchOptions) -> BaseOperation<T?> {
        return _fetchByModelId(modelId, options)
    }

    public func fetchOperation(by request: RepositorySliceRequest,
                               options: RepositoryFetchOptions) -> BaseOperation<[T]> {
        return _fetchByOffsetCount(request, options)
    }

    public func fetchAllOperation(with options: RepositoryFetchOptions) -> BaseOperation<[T]> {
        return _fetchAll(options)
    }

    public func saveOperation(_ updateModelsBlock: @escaping () throws -> [T],
                              _ deleteIdsBlock: @escaping () throws -> [String]) -> BaseOperation<Void> {
        return _save(updateModelsBlock, deleteIdsBlock)
    }

    public func replaceOperation(_ newModelsBlock: @escaping () throws -> [T]) -> BaseOperation<Void> {
        return _replace(newModelsBlock)
    }

    public func deleteAllOperation() -> BaseOperation<Void> {
        return _deleteAll()
    }

    public func fetchCountOperation() -> BaseOperation<Int> {
        return _fetchCount()
    }
}
