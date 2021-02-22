import UIKit

final class AboutDetailsCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(red: 0.0, green: 0.298, blue: 0.718, alpha: 0.3)
        self.selectedBackgroundView = selectedBackgroundView
    }

    func bind(title: String, subtitle: String, icon: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconView.image = icon
    }
}
