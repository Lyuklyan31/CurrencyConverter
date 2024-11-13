import UIKit

class CurrencyExchangeView: UIView {
    private let cornerRectangle = UIView()
    
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
        sellButton.backgroundColor = .systemBlue
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
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.backgroundColor = .systemBlue
        buyButton.layer.cornerRadius = 6
        
        cornerRectangle.addSubview(buyButton)
        buyButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
    }
    
    @objc private func sellButtonTapped() {
        sellButton.backgroundColor = .systemBlue
        buyButton.backgroundColor = .white
        buyButton.setTitleColor(.black, for: .normal)
    }
    
    @objc private func buyButtonTapped() {
        
    }
}

#Preview {
    CurrencyExchangeView()
}
