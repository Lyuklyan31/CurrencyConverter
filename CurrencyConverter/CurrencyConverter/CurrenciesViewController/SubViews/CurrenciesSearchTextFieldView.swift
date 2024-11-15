import UIKit
import SnapKit

class CurrenciesSearchTextFieldView: UIView {
    private let searchTextField = UISearchTextField()
    private let microphoneButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupSearchTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSearchTextField() {
        searchTextField.placeholder = "Search Currency"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholderGray,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        searchTextField.textColor = .black
        
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        microphoneButton.frame.size = CGSize(width: 11, height: 16.37)
        
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.edges.equalToSuperview()
        }
    }
}
