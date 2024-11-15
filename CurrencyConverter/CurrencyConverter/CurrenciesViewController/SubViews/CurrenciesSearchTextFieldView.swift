import UIKit
import Combine
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
    
//    func  setupBinding() {
//        searchTextField.textPublisher
//            .sink { [weak self] textFieldText in
//                guard let self = self else { return }
//            }
//    }
    
    func setupSearchTextField() {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.placeholderGray,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Currency", attributes: placeholderAttributes)
        
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        microphoneButton.frame.size = CGSize(width: 11, height: 16.37)
        microphoneButton.tintColor = .microphoneGray
        
        searchTextField.rightView = microphoneButton
        searchTextField.rightViewMode = .always
        
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.edges.equalToSuperview()
        }
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
