import UIKit

class MainViewController: UIViewController {

    let backgroundView = BackgroundView()
    let currencyExchangeView = CurrencyExchangeView()
    
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
        view.addSubview(currencyExchangeView)
        currencyExchangeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(171)
            $0.horizontalEdges.equalToSuperview()
        }
        
    }
}

#Preview {
    MainViewController()
}
