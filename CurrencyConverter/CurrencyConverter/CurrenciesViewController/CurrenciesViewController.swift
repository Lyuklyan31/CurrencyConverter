import SnapKit
import UIKit
import Combine

class CurrenciesViewController: UIViewController {
    private var viewModel: CurrencyViewModel

    private let currencyNavigationBarView = CurrencyNavigationBarView()
    private let currencySearchTextFieldView = CurrencySearchTextFieldView()
    
    private let tableView = UITableView()
    private var searchTextField = UITextField()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, CurrencyModel>!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupBinding()
        currencyNavigationBarView.setupNavBar(for: self)
        setupCurrencySearchTextField()
    }
    
    private func setupBinding() {
        
       
    }
    
    private func setupCurrencySearchTextField() {
        view.addSubview(currencySearchTextFieldView)
        currencySearchTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
}

#Preview {
    CurrenciesViewController(viewModel: CurrencyViewModel())
}

