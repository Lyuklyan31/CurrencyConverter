import SnapKit
import UIKit
import Combine

class CurrenciesViewController: UIViewController {
    private var viewModel: CurrencyViewModel
    
    private let currencyNavigationBarView =  CurrenciesNavigationBarView()
    private let currencySearchTextFieldView = CurrenciesSearchTextFieldView()
    
    private let tableView = UITableView()
    
    private var dataSource: UITableViewDiffableDataSource<Int, CurrencyModel>!
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
        configureDefaults()
    }
    
    private func setupUI() {
        currencyNavigationBarView.setupNavBar(for: self)
        setupCurrencySearchTextField()
        setupTableView()
    }
    
    private func configureDefaults() {
        setupDataSource()
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.$currencies
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] currencies in
                guard let self = self else { return }
                self.applySnapShot(with: currencies)
            }
            .store(in: &cancellables)
    }
    
    private func setupCurrencySearchTextField() {
        view.addSubview(currencySearchTextFieldView)
        currencySearchTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func setupTableView() {
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.15
        tableView.layer.shadowOffset = CGSize(width: 0, height: 6)
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(currencySearchTextFieldView.snp.bottom).offset(54)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.greaterThanOrEqualToSuperview()
        }
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CurrencyModel>(tableView: tableView) { tableView, indexPath, currencyData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell else { return UITableViewCell() }
            
            cell.configure(with: "\(currencyData.code) - \(currencyData.name)")
            
            return cell
        }
    }
    
    private func applySnapShot(with currencies: [CurrencyModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, CurrencyModel>()
        snapShot.appendSections([0])
        snapShot.appendItems(currencies, toSection: 0)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension CurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

#Preview {
    CurrenciesViewController(viewModel: CurrencyViewModel())
}
