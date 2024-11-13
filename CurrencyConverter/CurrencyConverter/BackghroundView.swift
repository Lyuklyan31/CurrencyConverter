import UIKit
import SnapKit

class BackghroundView: UIView {

    private let lowerOvalView = UIView()
    private let middleOvalView = UIView()
    private let upperOvalView = UIView()
    private let titleLabel = UILabel()
    init() {
        super.init(frame: .zero)
        
        setupSubViews()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
        lowerOvalView.backgroundColor = .systemBlue
        lowerOvalView.layer.cornerRadius = 465 / 2
        lowerOvalView.layer.masksToBounds = true
        
        addSubview(lowerOvalView)
        lowerOvalView.snp.makeConstraints {
            $0.width.equalTo(465)
            $0.height.equalTo(339)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(-111)
        }
        
        middleOvalView.backgroundColor = .vividBlue
        middleOvalView.layer.cornerRadius = 468.62 / 2
        middleOvalView.layer.masksToBounds = true
        
        lowerOvalView.addSubview(middleOvalView)
        middleOvalView.snp.makeConstraints {
            $0.width.equalTo(468.62)
            $0.height.equalTo(349.65)
            $0.top.equalTo(lowerOvalView.snp.top).offset(-71)
            $0.trailing.equalTo(lowerOvalView.snp.trailing).offset(-33.41)
        }
        
        upperOvalView.backgroundColor = .skyBlue
        upperOvalView.layer.cornerRadius = 468.62 / 2
        upperOvalView.layer.masksToBounds = true
        
        middleOvalView.addSubview(upperOvalView)
        upperOvalView.snp.makeConstraints {
            $0.width.equalTo(468.62)
            $0.height.equalTo(349.65)
            $0.top.equalTo(middleOvalView.snp.top)
            $0.trailing.equalTo(middleOvalView.snp.trailing).offset(-27)
        }
    }
        func setupTitle() {
            titleLabel.text = "Currency Converter"
            titleLabel.font = UIFont(name: "Lato-Bold", size: 24)
            titleLabel.textColor = .white
            addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.bottom.equalToSuperview().offset(52)
        }
    }
}

#Preview {
    BackghroundView()
}
