import UIKit
import Combine
import SnapKit

class ConverterView: UIView {
    var viewModel: CurrencyViewModel
    
    private let cornerRectangle = UIView()
    private let backgroundIndicator = UIView()
    
    private let sellButton = UIButton()
    private let buyButton = UIButton()
    private let addCurrencyButton = UIButton()
    
    private let tableView = UITableView()
    private var tableViewHeightConstraint: Constraint?
    
    private var dataSource: UITableViewDiffableDataSource<Int, CurrencyModel>!
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
        cornerRectangle.backgroundColor = .white
        cornerRectangle.layer.cornerRadius = 10
        cornerRectangle.layer.shadowColor = UIColor.black.cgColor
        cornerRectangle.layer.shadowOpacity = 0.15
        cornerRectangle.layer.shadowOffset = CGSize(width: 0, height: 6)
        addSubview(cornerRectangle)
        
        cornerRectangle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        backgroundIndicator.backgroundColor = .systemBlue
        backgroundIndicator.layer.cornerRadius = 6
        cornerRectangle.addSubview(backgroundIndicator)
        backgroundIndicator.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        configureButton(sellButton, title: "Sell", titleColor: .white)
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        cornerRectangle.addSubview(sellButton)
        sellButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        
        configureButton(buyButton, title: "Buy", titleColor: .black)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        cornerRectangle.addSubview(buyButton)
        buyButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(139)
            $0.height.equalTo(44)
        }
        cornerRectangle.addSubview(addCurrencyButton)
        
        tableView.register(ConverterCell.self, forCellReuseIdentifier: "ConverterCell")
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        cornerRectangle.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(buyButton.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            self.tableViewHeightConstraint = $0.height.equalTo(44).constraint
            $0.bottom.equalTo(addCurrencyButton.snp.top).offset(-40)
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
            $0.top.equalTo(tableView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CurrencyModel>(tableView: tableView) { tableView, IndexPath, currency in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConverterCell", for: IndexPath) as? ConverterCell else { return UITableViewCell() }
            
            cell.configure(with: currency.code)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private func applySnapshot(with currencies: [CurrencyModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(currencies, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint?.update(offset: contentHeight)
    }
    
    private func setupBinding() {
        viewModel.$converterList
            .sink { [weak self] currency in
                guard let self = self else { return }
                self.applySnapshot(with: currency)
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
            self.backgroundIndicator.snp.remakeConstraints {
                $0.top.equalTo(selectedButton.snp.top)
                $0.leading.equalTo(selectedButton.snp.leading)
                $0.width.equalTo(selectedButton.snp.width)
                $0.height.equalTo(selectedButton.snp.height)
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

extension ConverterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
