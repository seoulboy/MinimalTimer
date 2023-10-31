import UIKit

final class TimerViewController: UIViewController {
    enum Constant {
        static let dotRadius: CGFloat = circleRadius/8
        static let circleRadius: CGFloat = 150
        static let framePadding: CGFloat = 50
    }
    
    private lazy var timerFrameView: UIView = createTimerFrameView()
    private lazy var circleDrawView: UIView = createCircleDrawView()
    private lazy var centerDot: UIView = createDot()
    private let viewModel: TimerViewModelType
    
    init(viewModel: TimerViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    private func addSubviews() {
        view.addSubview(timerFrameView)
        view.addSubview(circleDrawView)
        view.addSubview(centerDot)
    }
    
    private func layout() {
        layoutCircle()
        layoutDot()
        layoutTimerFrame()
    }
    
    private func layoutTimerFrame() {
        NSLayoutConstraint.activate([
            timerFrameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerFrameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerFrameView.widthAnchor.constraint(equalToConstant: Constant.circleRadius * 2 * 1.28),
            timerFrameView.heightAnchor.constraint(equalToConstant: Constant.circleRadius * 2 * 1.28)
        ])
    }
    
    private func layoutCircle() {
        NSLayoutConstraint.activate([
            circleDrawView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleDrawView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleDrawView.widthAnchor.constraint(equalToConstant: Constant.circleRadius * 2),
            circleDrawView.heightAnchor.constraint(equalToConstant: Constant.circleRadius * 2)
        ])
    }
    
    private func layoutDot() {
        NSLayoutConstraint.activate([
            centerDot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerDot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerDot.heightAnchor.constraint(equalToConstant: Constant.dotRadius * 2),
            centerDot.widthAnchor.constraint(equalTo: centerDot.heightAnchor)
        ])
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func createTimerFrameView() -> TimerFrameView {
        let view = TimerFrameView(radius: Constant.circleRadius)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createCircleDrawView() -> CircleDrawView {
        let view = CircleDrawView(radius: Constant.circleRadius)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createDot() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = Constant.dotRadius
        self.view.addSubview(view)
        return view
    }
}

extension TimerViewController {
    static func create(with viewModel: TimerViewModel) -> TimerViewController {
        let vc = TimerViewController(viewModel: viewModel)
        return vc
    }
}
