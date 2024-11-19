import UIKit

class MainViewController: UIViewController {
    let viewModel = CurrencyViewModel()
    
    private let backgroundView = MainBackgroundView()
    private var converterView: ConverterView!
        
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupBackgroundView()
        setupScrollView()
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
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(scrollView)
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
        contentView.addSubview(converterView)
        converterView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
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
