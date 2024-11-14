import UIKit
import SnapKit

class CurrencyExchangeView: UIView {
    private let cornerRectangle = UIView()
    private let backgroundIndicator = UIView()
    
    private let sellButton = UIButton()
    private let buyButton = UIButton()
    private let addCurrencyButton = UIButton()
    
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
}

#Preview {
    CurrencyExchangeView()
}
