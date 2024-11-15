import UIKit
import SnapKit

class ConverterView: UIView {
    private let cornerRectangle = UIView()
    private let backgroundIndicator = UIView()
    
    private let sellButton = UIButton()
    private let buyButton = UIButton()
    private let addCurrencyButton = UIButton()
    
    var openSheetAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        cornerRectangle.backgroundColor = .white
        cornerRectangle.layer.cornerRadius = 10
        cornerRectangle.layer.shadowColor = UIColor.black.cgColor
        cornerRectangle.layer.shadowOpacity = 0.15
        cornerRectangle.layer.shadowOffset = CGSize(width: 0, height: 6)
        cornerRectangle.backgroundColor = .white
        addSubview(cornerRectangle)
        
        cornerRectangle.snp.makeConstraints {
            $0.height.equalTo(398)
            $0.top.equalToSuperview().offset(171)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        backgroundIndicator.backgroundColor = .systemBlue
        backgroundIndicator.layer.cornerRadius = 6
        cornerRectangle.addSubview(backgroundIndicator)
        backgroundIndicator.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        sellButton.setTitle("Sell", for: .normal)
        sellButton.setTitleColor(.white, for: .normal)
        sellButton.layer.cornerRadius = 6
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        cornerRectangle.addSubview(sellButton)
        sellButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.setTitleColor(.black, for: .normal)
        buyButton.layer.cornerRadius = 6
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        cornerRectangle.addSubview(buyButton)
        buyButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        var config = UIButton.Configuration.plain()
        config.title = "Add Currency"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 8.22
        
        addCurrencyButton.configuration = config
        addCurrencyButton.setTitleColor(.systemBlue, for: .normal)
        addCurrencyButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 13)
        
        cornerRectangle.addSubview(addCurrencyButton)
        addCurrencyButton.addTarget(self, action: #selector(addCurrencyButtonTapped), for: .touchUpInside)
        addCurrencyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-62)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func buyButtonTapped() {
        buttonTapped(buyButton, changeOn: sellButton)
    }

    @objc private func sellButtonTapped() {
        buttonTapped(sellButton, changeOn: buyButton)
    }
    
    private func buttonTapped(_ selectedButton: UIButton, changeOn: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.backgroundIndicator.snp.remakeConstraints {
                $0.top.equalTo(selectedButton.snp.top)
                $0.leading.equalTo(selectedButton.snp.leading)
                $0.width.equalTo(selectedButton.snp.width)
                $0.height.equalTo(selectedButton.snp.height)
            }
            self.layoutIfNeeded()
            
            selectedButton.setTitleColor(.white, for: .normal)
            changeOn.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc private func addCurrencyButtonTapped() {
        openSheetAction?()  
    }
}

#Preview {
    ConverterView()
}
