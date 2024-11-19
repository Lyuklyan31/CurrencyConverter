import UIKit

class ConverterCell: UITableViewCell {
    private let currencyButton = UIButton()
    private let converterTextField = UITextField()
    private let backgroundTextFieldView = UIView()
    private let conteinerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        contentView.addSubview(conteinerView)
        conteinerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        backgroundTextFieldView.backgroundColor = .textFieldBackgroundGrey
        backgroundTextFieldView.layer.cornerRadius = 6
        
        conteinerView.addSubview(backgroundTextFieldView)
        backgroundTextFieldView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.lessThanOrEqualToSuperview().offset(121)
            $0.right.equalToSuperview()
        }
        
        converterTextField.font = UIFont(name: "Lato-Bold", size: 14)
        converterTextField.textColor = .black
        converterTextField.backgroundColor = .textFieldBackgroundGrey
        converterTextField.placeholder = "0.00"
        converterTextField.keyboardType = .decimalPad
        
        backgroundTextFieldView.addSubview(converterTextField)
        converterTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        var configuration = UIButton.Configuration.plain()
        let originalImage = UIImage(systemName: "chevron.right")
        configuration.image = originalImage?.withTintColor(.black, renderingMode: .alwaysOriginal)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 11
        
        currencyButton.configuration = configuration
        currencyButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        currencyButton.setTitleColor(.black, for: .normal)
        currencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        currencyButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        conteinerView.addSubview(currencyButton)
        currencyButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.right.greaterThanOrEqualToSuperview().offset(-279)
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func currencyButtonTapped() {
        print("Currency button tapped")
    }
    
    func configure(with text: String) {
        currencyButton.setTitle(text, for: .normal)
    }
}

#Preview {
    ConverterCell()
}
