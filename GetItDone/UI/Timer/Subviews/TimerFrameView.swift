import UIKit

final class TimerFrameView: UIView {
    enum Constant {
        static let borderColor: UIColor = .systemGray2
        static let borderWidth: CGFloat = 10
        static let backgroundColor: UIColor = .white
    }
    private let cornerRadius: CGFloat
    private let radius: CGFloat
    
    
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
    
    private func configure() {
        backgroundColor = Constant.backgroundColor
        layer.cornerCurve = .continuous
        layer.cornerRadius = cornerRadius
        layer.borderColor = Constant.borderColor.cgColor
        layer.borderWidth = Constant.borderWidth
    }
    
    private func addNumberLabels() {
        Array(0...11).forEach { number in
            let label = createLabel(with: number * 5)
            positionLabel(number: number, label: label)
        }
    }
    
    private func createLabel(with number: Int) -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = number.description
        view.font = .systemFont(ofSize: 20, weight: .bold)
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
        let padding: CGFloat = 15
        let radius = radius + padding
        let x: CGFloat = radius * sin(radian)
        let y: CGFloat = radius * cos(radian)
        return (x, y)
    }
}

