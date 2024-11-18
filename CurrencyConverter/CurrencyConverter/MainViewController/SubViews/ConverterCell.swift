import UIKit

class ConverterCell: UITableViewCell {
    let currencyButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.imagePadding = 11.04
        configuration.imagePlacement = .trailing
        
        currencyButton.configuration = configuration
        currencyButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        currencyButton.setTitleColor(.black, for: .normal)
        
//        currencyButton.semanticContentAttribute = .forceLeftToRight

        currencyButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        currencyButton.setTitle(text, for: .normal)
    }
}
