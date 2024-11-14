import SnapKit
import UIKit

class CurrencysViewController: UIViewController {
    
    let titleee = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleee.text = "Hello world"
        view.addSubview(titleee)
        titleee.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    

}
