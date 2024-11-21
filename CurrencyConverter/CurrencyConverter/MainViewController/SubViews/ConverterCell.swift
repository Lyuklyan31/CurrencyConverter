import UIKit
import Combine

class ConverterCell: UITableViewCell {
    var viewModel: CurrencyViewModel!
    
    private let currencyButton = UIButton()
    private let converterTextField = UITextField()
    private let backgroundTextFieldView = UIView()
    private let containerView = UIView()
    
    private var cancellables = Set<AnyCancellable>()
    private var textCode = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        converterTextField.textPublisher
            .compactMap { text in
                return Double(text)
            }
            .sink { [weak self] value in
                guard let self = self else { return }
                self.viewModel.updateValue(for: self.textCode, newValue: value)
            }
            .store(in: &cancellables)

        viewModel.$converterList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] converterList in
                guard let self = self else { return }
                guard let currentCurrency = converterList.first(where: { $0.code == self.textCode }) else { return }
                
                if !self.converterTextField.isFirstResponder {
                    self.converterTextField.placeholder = String(format: "%.2f", currentCurrency.value)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        backgroundTextFieldView.backgroundColor = .textFieldBackgroundGrey
        backgroundTextFieldView.layer.cornerRadius = 6
        containerView.addSubview(backgroundTextFieldView)
        backgroundTextFieldView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.leading.lessThanOrEqualToSuperview().offset(121)
            $0.trailing.equalToSuperview()
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
        
        containerView.addSubview(currencyButton)
        currencyButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.greaterThanOrEqualToSuperview().offset(-279)
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func currencyButtonTapped() {
        print("Currency button tapped")
    }
    
    func configure(with code: String, value: Double, viewModel: CurrencyViewModel) {
        self.textCode = code
        self.viewModel = viewModel
        currencyButton.setTitle(code, for: .normal)
        converterTextField.placeholder = String(format: "%.2f", value)
        setupBindings()
    }
}
