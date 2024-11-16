import SnapKit
import UIKit
import Combine

class CurrenciesViewController: UIViewController {
    private var viewModel: CurrencyViewModel
    
    private let currencyNavigationBarView = CurrenciesNavigationBarView()
    private let currencySearchTextFieldView = CurrenciesSearchTextFieldView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var sortedKeys: [String] = []
    
    private var dataSource: UITableViewDiffableDataSource<String, CurrencyModel>!
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        
        tableView.delegate = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(currencySearchTextFieldView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview().offset(-16)
        }
    }
    
    private func configureDefaults() {
        setupDataSource()
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.$currencies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currencies in
                guard let self = self else { return }
                self.applySnapShot(with: currencies)
            }
            .store(in: &cancellables)
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<String, CurrencyModel>(tableView: tableView) { tableView, indexPath, currencyData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: "\(currencyData.code) - \(currencyData.name)")
            
            return cell
        }
    }
    
    private func applySnapShot(with currencies: [CurrencyModel]) {
        let groupedCurrencies = Dictionary(grouping: currencies) { (currency: CurrencyModel) -> String in
            return String(currency.code.prefix(1)).uppercased()
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<String, CurrencyModel>()
        sortedKeys = groupedCurrencies.keys.sorted()
        snapShot.appendSections(sortedKeys)
        
        for key in sortedKeys {
            if let items = groupedCurrencies[key] {
                snapShot.appendItems(items, toSection: key)
            }
        }
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension CurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = sortedKeys[section]
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray

        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        return headerView
    }
}
