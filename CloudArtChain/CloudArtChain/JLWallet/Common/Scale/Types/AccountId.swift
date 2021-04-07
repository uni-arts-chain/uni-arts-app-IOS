import Foundation
import FearlessUtils
import IrohaCrypto

class AccountId: NSObject, ScaleCodable {
    @objc let value: Data

    required init(scaleDecoder: ScaleDecoding) throws {
        value = try scaleDecoder.readAndConfirm(count: 32)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        scaleEncoder.appendRaw(data: value)
    }
    
    @objc func valueDesc() -> String {
        return value.toHex(includePrefix: true)
    }
    
    @objc func address() -> String? {
        let addressFactory = SS58AddressFactory()
        do {
            let address = try addressFactory.address(fromPublicKey: AccountIdWrapper(rawData: value), type: .genericSubstrate)
            return address
        } catch {
            return nil
        }
    }
}
