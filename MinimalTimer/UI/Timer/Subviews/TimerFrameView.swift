import UIKit

final class TimerFrameView: UIView {
    enum Constant {
        static let borderColor: UIColor = .systemBackground
        static let borderWidth: CGFloat = 10
        static let backgroundColor: UIColor = .systemBackground
    }
    private var numberLabels: [UILabel] = []
    private let cornerRadius: CGFloat
    private let radius: CGFloat
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = Constant.borderColor.cgColor
    }
    
    init(radius: CGFloat) {
        self.radius = radius
        cornerRadius = radius / 1.9
        super.init(frame: .zero)
        configure()
        addNumberLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureNumberLabelVisiblity(isHidden: Bool) {
        numberLabels.forEach { (label: UILabel) in
            let animator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut)
            animator.addAnimations {
                label.alpha = isHidden ? 0 : 1
            }
            animator.startAnimation()
        }
    }
    
    private func configure() {
        backgroundColor = Constant.backgroundColor
        layer.cornerCurve = .continuous
        layer.cornerRadius = cornerRadius
        layer.borderColor = Constant.borderColor.cgColor
        layer.borderWidth = Constant.borderWidth
    }
    
    private func addNumberLabels() {
        numberLabels = Array(0...11).map { number in
            let label = createLabel(with: number * 5)
            positionLabel(number: number, label: label)
            return label
        }
    }
    
    private func createLabel(with number: Int) -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = number.description
        view.font = LayoutConstant.labelFont
        view.textColor = LayoutConstant.labelColor
        return view
    }
    
    private func positionLabel(number: Int, label: UILabel) {
        let nextLocation = calculateNextLocation(position: number)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: nextLocation.x),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: nextLocation.y)
        ])
    }
    
    private func calculateNextLocation(position: Int) -> (x: CGFloat, y: CGFloat) {
        let radian = CGFloat(30 * position).degreeToRadian + .pi
        let padding: CGFloat = 20
        let radiusWithPadding = radius + padding
        let x: CGFloat = radiusWithPadding * sin(radian)
        let y: CGFloat = radiusWithPadding * cos(radian)
        return (x, y)
    }
    
    enum LayoutConstant {
        static let labelColor: UIColor = .init(named: "TimerNumberLabelColorSet") ?? .systemGray3
        static let labelFont: UIFont = .systemFont(ofSize: 20, weight: .medium)
    }
}

