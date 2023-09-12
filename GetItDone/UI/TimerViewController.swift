import UIKit

final class TimerViewController: UIViewController {
    private let viewModel: TimerViewModelType
    
    lazy var label: UILabel = createLabel()
    lazy var button: UIButton = createButton()
    
    init(viewModel: TimerViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addSubviews()
        layout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    private func addSubviews() {
        self.view.addSubview(label)
        self.view.addSubview(button)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    private func configure() {
        view.backgroundColor = .white
        configureButtonAction()
    }
    
    private func configureButtonAction() {
        let action = UIAction { [weak self] _ in self?.viewModel.showAlert() }
        button.addAction(action, for: .touchUpInside)
    }
    
    private func createLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "hello timer ! ⏲️"
        return view
    }
    
    private func createButton() -> UIButton {
        let configuration = UIButton.Configuration.filled()
        let view = UIButton(configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("tap me 💓", for: .normal)
        return view
    }
}

extension TimerViewController {
    static func create(with viewModel: TimerViewModel) -> TimerViewController {
        let vc = TimerViewController(viewModel: viewModel)
        return vc
    }
}
