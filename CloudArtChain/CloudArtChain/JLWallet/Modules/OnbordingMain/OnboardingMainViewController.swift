import UIKit
import SoraUI

final class OnboardingMainViewController: JLBaseViewController, AdaptiveDesignable {
    var presenter: OnboardingMainPresenterProtocol!

    @IBOutlet private var signUpButton: UIButton!
    @IBOutlet private var restoreButton: UIButton!
    @IBOutlet private var logoView: UIImageView!
    // MARK: Appearance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "钱包登录";
        self.addBackItem()
        self.setupSubViews()
        presenter.setup()
    }
    
    private func setupSubViews() {
        signUpButton.layer.cornerRadius = 23.0
        signUpButton.layer.masksToBounds = true;
        
        restoreButton.layer.cornerRadius = 23.0
        restoreButton.layer.masksToBounds = true
        restoreButton.layer.borderWidth = 1.0
        restoreButton.layer.borderColor = UIColor(hex: "50C3FF").cgColor
    }
    
    override func backClick() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Action

    @IBAction private func actionSignup(sender: AnyObject) {
        presenter.activateSignup()
    }

    @IBAction private func actionRestoreAccess(sender: AnyObject) {
        presenter.activateAccountRestore()
    }
}

extension OnboardingMainViewController: OnboardingMainViewProtocol {}
