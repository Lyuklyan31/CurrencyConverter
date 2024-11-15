import UIKit

class CurrencyNavigationBarView: UIView {
    private let backButton = UIButton(type: .system)
    
    func setupNavBar(for viewController: UIViewController) {
        viewController.view.backgroundColor = .sheetBackground
        viewController.title = "Currency"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.sheetBackground
        viewController.navigationItem.scrollEdgeAppearance = appearance
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        configuration.title = "Converter"
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -7, bottom: 0, trailing: 0)
        
        backButton.configuration = configuration
        backButton.addTarget(viewController, action: #selector(viewController.closeViewController), for: .touchUpInside)
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}

extension UIViewController {
    @objc func closeViewController() {
        dismiss(animated: true, completion: nil)
    }
}
