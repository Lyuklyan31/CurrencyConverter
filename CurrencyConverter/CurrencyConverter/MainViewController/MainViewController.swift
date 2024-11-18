import UIKit

class MainViewController: UIViewController {
    let viewModel = CurrencyViewModel()
    
    let backgroundView = MainBackgroundView()
    let converterView = ConverterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupBackgroundView()
        setupCurrencyExchangeView()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
    
    private func setupCurrencyExchangeView() {
        converterView.openSheetAction = { [weak self] in
            self?.openSheet()
        }
        view.addSubview(converterView)
        converterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func openSheet() {
        let currenciesVC = CurrenciesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: currenciesVC)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }
}

#Preview {
    MainViewController()
}
