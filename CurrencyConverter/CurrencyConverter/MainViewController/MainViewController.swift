import UIKit

class MainViewController: UIViewController {
    let viewModel = CurrencyViewModel()
    
    private let backgroundView = MainBackgroundView()
    private var converterView: ConverterView!
        
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDismissKeyboard()
    }
    
    private func setupUI() {
        setupBackgroundView()
        setupTitle()
        setupCurrencyExchangeView()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(339)
        }
    }
    
    private func setupTitle() {
        titleLabel.text = "Currency Converter"
        titleLabel.font = UIFont(name: "Lato-Bold", size: 24)
        titleLabel.textColor = .white
        
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(92)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    private func setupCurrencyExchangeView() {
        converterView = ConverterView(viewModel: viewModel)
        converterView.openSheetAction = { [weak self] in
            self?.openSheet()
        }
        converterView.shareAction = { [weak self] in
            self?.presentShareSheet()
        }
        view.addSubview(converterView)
        converterView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(171)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-243)
        }
    }
    
    private func openSheet() {
        let currenciesVC = CurrenciesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: currenciesVC)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }
    
    private func presentShareSheet() {
        let textToShare = "Currency Converter"
        let urlToShare = URL(string: "https://google.com")!
        let activityViewController = UIActivityViewController(activityItems: [textToShare, urlToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

#Preview {
    MainViewController()
}
