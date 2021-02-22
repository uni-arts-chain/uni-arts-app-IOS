/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

/**
 *  Enum is designed to provide definitions
 *  for most common network errors.
 */

public enum NetworkBaseError: Error {
    /// Invalid url provided to request.
    case invalidUrl

    /// Can't serialize request.
    case badSerialization

    /// Can't deserialize response.
    case badDeserialization

    /// Unexpected empty data received in response.
    case unexpectedEmptyData

    /// Unexpected response type received.
    /// For example, http response was expected but another type is received.
    case unexpectedResponseObject
}

/**
 *  Enum is designed to define errors corresponding to http status codes.
 */

public enum NetworkResponseError: Error {
    /// Status code 400 - invalid parameters in request.
    case invalidParameters

    /// Status code 404 - resource not found.
    case resourceNotFound

    /// Status code 401 - can't authorize the request.
    case authorizationError

    /// Status code 500 - internal server error.
    case internalServerError

    /// Unexpected status code.
    case unexpectedStatusCode

    static func createFrom(statusCode: Int) -> NetworkResponseError? {
        switch statusCode {
        case 200:
            return nil
        case 400:
            return NetworkResponseError.invalidParameters
        case 401:
            return NetworkResponseError.authorizationError
        case 404:
            return NetworkResponseError.resourceNotFound
        case 500:
            return NetworkResponseError.internalServerError
        default:
            return NetworkResponseError.unexpectedStatusCode
        }
    }
}
