import SnapKit
import UIKit
import Combine

class CurrenciesViewController: UIViewController {
    private var viewModel: CurrencyViewModel
    
    private let currencyNavigationBarView = CurrenciesNavigationBarView()
    private var currencySearchTextFieldView: CurrenciesSearchTextFieldView!
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<String, CurrencyModel>!
   
    private var sortedKeys: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.loadConverterList()
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
        setupDismissKeyboard()
    }
    
    private func setupCurrencySearchTextField() {
        currencySearchTextFieldView = CurrenciesSearchTextFieldView(viewModel: viewModel)
        view.addSubview(currencySearchTextFieldView)
        currencySearchTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func setupTableView() {
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.15
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.showsVerticalScrollIndicator = false

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
            
            if currencyData.isSelected {
                cell.applyCheckedLook()
            } else {
                cell.applyUncheckedLook()
            }
            
            return cell
        }
    }
    
    private func applySnapShot(with currencies: [CurrencyModel]) {
        let sortedCurrencies = currencies.sorted { $0.code < $1.code }
        let groupedCurrencies = Dictionary(grouping: sortedCurrencies) { $0.code.prefix(1).uppercased() }
        
        var snapShot = NSDiffableDataSourceSnapshot<String, CurrencyModel>()
        sortedKeys = groupedCurrencies.keys.sorted()
        snapShot.appendSections(sortedKeys)
        
        for key in sortedKeys {
            if let items = groupedCurrencies[key] {
                snapShot.appendItems(items, toSection: key)
            }
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
        
        self.selectCityRow()
    }
    
    private func selectCityRow() {
        guard let selectedIndex = viewModel.currencies.firstIndex(where: { $0.code == viewModel.currency.code }) else { return }
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        
        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
        
        if let cell = tableView.cellForRow(at: selectedIndexPath) as? CurrencyCell {
            cell.applyCheckedLook()
        }
    }
}

// MARK: - UITableViewDelegate
extension CurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCurrency = dataSource.itemIdentifier(for: indexPath) else { return }
        
        viewModel.updateConverterList(with: selectedCurrency)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.text = sortedKeys[section]
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray

        headerView.addSubview(label)
        label.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualToSuperview()
        }

        return headerView
    }
}
