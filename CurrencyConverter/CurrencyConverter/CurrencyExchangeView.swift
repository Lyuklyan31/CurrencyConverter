import UIKit
import SnapKit

class CurrencyExchangeView: UIView {
    private let cornerRectangle = UIView()
    private let backgroundIndicator = UIView()
    
    private let sellButton = UIButton()
    private let buyButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        cornerRectangle.backgroundColor = .systemBackground
        cornerRectangle.layer.cornerRadius = 10
        cornerRectangle.layer.shadowColor = UIColor.black.cgColor
        cornerRectangle.layer.shadowOpacity = 0.15
        cornerRectangle.layer.shadowOffset = CGSize(width: 0, height: 6)
        cornerRectangle.backgroundColor = .white
        addSubview(cornerRectangle)
        
        cornerRectangle.snp.makeConstraints {
            $0.height.equalTo(398)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        sellButton.setTitle("Sell", for: .normal)
        sellButton.setTitleColor(.white, for: .normal)
        sellButton.layer.cornerRadius = 6
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        cornerRectangle.addSubview(sellButton)
        sellButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.setTitleColor(.black, for: .normal)
        buyButton.layer.cornerRadius = 6
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        cornerRectangle.addSubview(buyButton)
        buyButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        backgroundIndicator.backgroundColor = .systemBlue
        backgroundIndicator.layer.cornerRadius = 6
        cornerRectangle.addSubview(backgroundIndicator)
        backgroundIndicator.snp.makeConstraints {
            $0.top.equalTo(sellButton.snp.top)
            $0.leading.equalTo(sellButton.snp.leading)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
    }
    
    @objc private func buyButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundIndicator.snp.remakeConstraints {
                $0.top.equalTo(self.buyButton.snp.top)
                $0.leading.equalTo(self.buyButton.snp.leading)
                $0.width.equalTo(self.buyButton.snp.width)
                $0.height.equalTo(self.buyButton.snp.height)
            }
            self.layoutIfNeeded()

            self.buyButton.setTitleColor(.white, for: .normal)
            self.sellButton.backgroundColor = .white
            self.sellButton.setTitleColor(.black, for: .normal)
        })
    }

    @objc private func sellButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundIndicator.snp.remakeConstraints {
                $0.top.equalTo(self.sellButton.snp.top)
                $0.leading.equalTo(self.sellButton.snp.leading)
                $0.width.equalTo(self.sellButton.snp.width)
                $0.height.equalTo(self.sellButton.snp.height)
            }
            self.layoutIfNeeded()
            self.sellButton.setTitleColor(.white, for: .normal)
            self.buyButton.backgroundColor = .white
            self.buyButton.setTitleColor(.black, for: .normal)
        })
    }
}

#Preview {
    CurrencyExchangeView()
}
