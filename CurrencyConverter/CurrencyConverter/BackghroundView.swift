import UIKit
import SnapKit

class BackgroundView: UIView {

    private let lowerOvalView = UIView()
    private let middleOvalView = UIView()
    private let upperOvalView = UIView()
    
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let rotationAngle: CGFloat = 1.33 * .pi / 180
        
        lowerOvalView.backgroundColor = .systemBlue
        let lowerOval = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 465, height: 339))
        let lowerMaskLayer = CAShapeLayer()
        lowerMaskLayer.path = lowerOval.cgPath
        lowerOvalView.layer.mask = lowerMaskLayer
        
        addSubview(lowerOvalView)
        lowerOvalView.snp.makeConstraints {
            $0.height.equalTo(339)
            $0.width.equalTo(465)
            $0.trailing.equalToSuperview().offset(46)
            $0.leading.equalToSuperview().offset(-44)
            $0.top.equalToSuperview().offset(-65)
        }
        
        middleOvalView.backgroundColor = .vividBlue
        let middleOval = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 468.62, height: 349.65))
        let middleMaskLayer = CAShapeLayer()
        middleMaskLayer.path = middleOval.cgPath
        middleOvalView.layer.mask = middleMaskLayer
        middleOvalView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        lowerOvalView.addSubview(middleOvalView)
        middleOvalView.snp.makeConstraints {
            $0.width.equalTo(469)
            $0.height.equalTo(350)
            $0.bottom.equalToSuperview().offset(-49.58)
            $0.trailing.equalToSuperview().offset(-33.41)
        }
        
        upperOvalView.backgroundColor = .skyBlue
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 468.62, height: 349.65))
        let maskLayer = CAShapeLayer()
        maskLayer.path = ovalPath.cgPath
        upperOvalView.layer.mask = maskLayer
        upperOvalView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        middleOvalView.addSubview(upperOvalView)
        upperOvalView.snp.makeConstraints {
            $0.width.equalTo(469)
            $0.height.equalTo(350)
            $0.top.equalTo(middleOvalView.snp.top)
            $0.trailing.equalTo(middleOvalView.snp.trailing).offset(-33.41)
        }
        
        titleLabel.text = "Currency Converter"
        titleLabel.font = UIFont(name: "Lato-Bold", size: 24)
        titleLabel.textColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(96)
            $0.leading.equalToSuperview()
        }
    }
}

#Preview {
    BackgroundView()
}
