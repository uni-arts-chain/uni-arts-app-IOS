import UIKit
import IrohaCrypto

final class ExportMnemonicConfirmInteractor {
    weak var presenter: AccountConfirmInteractorOutputProtocol!

    var mnemonic: IRMnemonicProtocol?
    let shuffledWords: [String]
    let origialWords: [String]

    init(mnemonic: IRMnemonicProtocol) {
        self.mnemonic = mnemonic
        self.origialWords = mnemonic.allWords()
        self.shuffledWords = mnemonic.allWords().shuffled()
    }
    init(words: [String]) {
        self.origialWords = words
        self.shuffledWords = words.shuffled()
    }
}

extension ExportMnemonicConfirmInteractor: AccountConfirmInteractorInputProtocol {
    func requestWords() {
        presenter.didReceive(words: shuffledWords, afterConfirmationFail: false)
    }

    func confirm(words: [String]) {
        guard words == origialWords else {
            presenter.didReceive(words: shuffledWords,
                                 afterConfirmationFail: true)
            return
        }

        presenter.didCompleteConfirmation()
    }

    func skipConfirmation() {
        presenter.didCompleteConfirmation()
    }
}
