import SnapKit
import UIKit

class CurrencyCell: UITableViewCell {
    private let cellLabel = UILabel()
    private let backgroundCell = UIView()
    private let cheсkmark = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        cellLabel.textColor = .black
        cellLabel.font = UIFont(name: "Lato-Regular", size: 17)
        cellLabel.numberOfLines = 0
        
        addSubview(cellLabel)
        cellLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.verticalEdges.equalToSuperview().inset(13)
        }
    }
    
    func configure(with text: String) {
        cellLabel.text = text
    }
}
