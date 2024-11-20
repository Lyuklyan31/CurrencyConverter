import UIKit
import Combine
import SnapKit

class ConverterView: UIView {
    var viewModel: CurrencyViewModel
    
    private let cornerRectangleView = UIView()
    private let buttonIndicatorView = UIView()
    
    private let sellButton = UIButton()
    private let buyButton = UIButton()
    private let addCurrencyButton = UIButton()
    private let tableView = UITableView()
    
    private var dataSource: UITableViewDiffableDataSource<Int, CurrencyViewModel.ConverterCurrencyModel>!
    private var cancellables = Set<AnyCancellable>()
    
    var openSheetAction: (() -> Void)?
    
    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        setupDataSource()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        cornerRectangleView.backgroundColor = .white
        cornerRectangleView.layer.cornerRadius = 10
        cornerRectangleView.layer.shadowColor = UIColor.black.cgColor
        cornerRectangleView.layer.shadowOpacity = 0.15
        cornerRectangleView.layer.shadowOffset = CGSize(width: 0, height: 6)
        addSubview(cornerRectangleView)
        
        cornerRectangleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(398)
        }
        
        buttonIndicatorView.backgroundColor = .systemBlue
        buttonIndicatorView.layer.cornerRadius = 6
        cornerRectangleView.addSubview(buttonIndicatorView)
        buttonIndicatorView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        configureButton(sellButton, title: "Sell", titleColor: .white)
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        cornerRectangleView.addSubview(sellButton)
        sellButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        configureButton(buyButton, title: "Buy", titleColor: .black)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        cornerRectangleView.addSubview(buyButton)
        buyButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        cornerRectangleView.addSubview(addCurrencyButton)
        
        tableView.register(ConverterCell.self, forCellReuseIdentifier: "ConverterCell")
        tableView.separatorStyle = .none
        
        cornerRectangleView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(buyButton.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(addCurrencyButton.snp.top).offset(-16)
        }
        
        var config = UIButton.Configuration.plain()
        config.title = "Add Currency"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 8.22
        
        addCurrencyButton.configuration = config
        addCurrencyButton.setTitleColor(.systemBlue, for: .normal)
        addCurrencyButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 13)
        addCurrencyButton.addTarget(self, action: #selector(addCurrencyButtonTapped), for: .touchUpInside)
        
        addCurrencyButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CurrencyViewModel.ConverterCurrencyModel>(tableView: tableView) { tableView, indexPath, currency in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConverterCell", for: indexPath) as? ConverterCell else {
                return UITableViewCell()
            }
            cell.configure(with: currency.code, value: currency.value, viewModel: self.viewModel)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private func applySnapshot(with currencies: [CurrencyViewModel.ConverterCurrencyModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyViewModel.ConverterCurrencyModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(currencies, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupBinding() {
        viewModel.$converterList
            .sink { [weak self] currencies in
                guard let self = self else { return }
                self.applySnapshot(with: currencies)
            }
            .store(in: &cancellables)
    }
    
    @objc private func buyButtonTapped() {
        buttonTapped(buyButton, changeOn: sellButton)
    }

    @objc private func sellButtonTapped() {
        buttonTapped(sellButton, changeOn: buyButton)
    }
    
    private func buttonTapped(_ selectedButton: UIButton, changeOn: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.buttonIndicatorView.snp.remakeConstraints {
                $0.edges.equalTo(selectedButton)
            }
            self.layoutIfNeeded()
            
            selectedButton.setTitleColor(.white, for: .normal)
            changeOn.setTitleColor(.black, for: .normal)
        }
    }
    
    private func configureButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        button.layer.cornerRadius = 6
    }
    
    @objc private func addCurrencyButtonTapped() {
        openSheetAction?()
    }
}
