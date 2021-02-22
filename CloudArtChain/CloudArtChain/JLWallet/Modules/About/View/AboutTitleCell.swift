import UIKit

final class AboutTitleCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(red: 00, green: 0.298, blue: 0.718, alpha: 0.3)
        self.selectedBackgroundView = selectedBackgroundView
    }

    func bind(title: String) {
        titleLabel.text = title
    }
}
