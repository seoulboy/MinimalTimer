import UIKit

final class CircleDrawView: UIView {
    let radius: CGFloat
    private lazy var centerInBounds: CGPoint = { .init(x: radius, y: radius) }()
    private var drawingLayer: CALayer?
    private var currentTouchPosition: CGPoint?
    private var latestTimerAngle: CGFloat?
    private var timer: Timer?
    private let startAngle: CGFloat = 270
    
    init(radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        backgroundColor = .gray.withAlphaComponent(0.1)
        layer.cornerRadius = radius
        layer.cornerCurve = .continuous
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let xRange = (centerInBounds.x - radius)...(centerInBounds.x + radius)
        let yRange = (centerInBounds.y - radius)...(centerInBounds.y + radius)
        
        guard let newTouchPoint = touches.first?.location(in: self),
              xRange.contains(newTouchPoint.x), yRange.contains(newTouchPoint.y) else { return }
        stopTimer()
        currentTouchPosition = newTouchPoint
        drawArc(targetPoint: newTouchPoint)
        backgroundColor = LayoutConstant.backgroundColor
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: self),
              let previousTouchPoint = currentTouchPosition else { return }
        drawArc(targetPoint: newTouchPoint)
        currentTouchPosition = newTouchPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchEndPoint = touches.first?.location(in: self) else { return }
        drawArc(targetPoint: touchEndPoint)
        startTimer(touchEndPoint: touchEndPoint)
    }
    
    var previousPoint: CGPoint = .init(x: 0, y: 0)
    
    private func startTimer(touchEndPoint: CGPoint) {
        previousPoint = touchEndPoint
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(redrawTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc
    private func redrawTimer() {
        let calculatedAngle =  calculateAngle(touchPoint: previousPoint)
        let roundedNextAngleFromPreviousPoint = round(calculatedAngle * 10) / 10.0
#if DEBUG
        print("seconds left : \(Int(roundedNextAngleFromPreviousPoint * 10))")
#endif
        
        let nextLocation = calculateNextLocation(prevAngleInDegrees: roundedNextAngleFromPreviousPoint)
        let newX = centerInBounds.x + nextLocation.x
        let newY = centerInBounds.y + nextLocation.y
        
        let newPointInCircle: CGPoint = .init(x: newX, y: newY)
        
        guard newPointInCircle.x != 150, newPointInCircle.y != 0 else {
            stopTimer()
            drawingLayer?.sublayers?.forEach({ $0.removeFromSuperlayer() })
            self.latestTimerAngle = nil
            return
        }
        
        previousPoint = newPointInCircle
        drawArc(targetPoint: newPointInCircle)
        latestTimerAngle = roundedNextAngleFromPreviousPoint
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func calculateNextLocation(prevAngleInDegrees: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let radian: CGFloat = prevAngleInDegrees.degreeToRadian + .pi - Numbers.degreesPerSecond.degreeToRadian
        let x: CGFloat = radius * sin(radian)
        let y: CGFloat = radius * cos(radian)
        return (x, y)
    }
    
    private func calculateAngle(touchPoint: CGPoint) -> CGFloat {
        var targetAngle = calculateCentralAngleOfCircle(targetPoint: touchPoint)
        if touchPoint.x > centerInBounds.x {
            targetAngle = 2 * .pi - targetAngle
        }
        
        return targetAngle.radianToDegree
    }
    
    private func drawArc(targetPoint: CGPoint) {
        setupDrawingLayerIfNeeded()
        
        drawingLayer?.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        var targetAngle = calculateCentralAngleOfCircle(targetPoint: targetPoint)

        if targetPoint.x > centerInBounds.x {
            targetAngle = 2 * .pi - targetAngle
        }
        
        let finalAngle = startAngle.degreeToRadian - targetAngle

        let path = UIBezierPath(arcCenter: centerInBounds, radius: radius, startAngle: CGFloat(270).degreeToRadian, endAngle: finalAngle, clockwise: false)
        path.addLine(to: centerInBounds)
        
        let line = CAShapeLayer()
        line.contentsScale = UIScreen.main.scale
        line.path = path.cgPath
        line.fillColor = LayoutConstant.highlightedSectionColor.cgColor
        line.opacity = 1
        line.lineWidth = 1
        line.lineCap = .round
        line.strokeColor = LayoutConstant.highlightedSectionColor.cgColor

        drawingLayer?.addSublayer(line)
    }
    
    private func setupDrawingLayerIfNeeded() {
        guard drawingLayer == nil else { return }
        let sublayer = CALayer()
        sublayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(sublayer)
        self.drawingLayer = sublayer
    }
    
    private func calculateCentralAngleOfCircle(targetPoint: CGPoint) -> CGFloat {
        let startingPointOfCircle: CGPoint = .init(x: centerInBounds.x, y: centerInBounds.y - radius)
        let lengthFromCenterToStartingPoint = radius
        let lengthFromCenterToTargetPoint = {
            let widthOfTriangle = abs(centerInBounds.x - targetPoint.x)
            let heightOfTriangle = abs(centerInBounds.y - targetPoint.y)
            let sumOfSquaresOfSides = pow(widthOfTriangle, 2) + pow(heightOfTriangle, 2)
            return sqrt(sumOfSquaresOfSides)
        }()
        let lengthFromStartingPointToTargetPoint: CGFloat = {
            let widthOfTriangle = abs(startingPointOfCircle.x - targetPoint.x)
            let heightOfTriangle = abs(startingPointOfCircle.y - targetPoint.y)
            let sumOfSquaresOfSides = pow(widthOfTriangle, 2) + pow(heightOfTriangle, 2)
            return sqrt(sumOfSquaresOfSides)
        }()
        let topPartOfEquation = pow(lengthFromCenterToStartingPoint, 2) + pow(lengthFromCenterToTargetPoint, 2) - pow(lengthFromStartingPointToTargetPoint, 2)
        let bottomPartOfEquation = 2 * lengthFromCenterToStartingPoint * lengthFromCenterToTargetPoint
        let result = topPartOfEquation / bottomPartOfEquation
        let radians = acos(result)
        return radians
    }
}

extension CircleDrawView {
    enum LayoutConstant {
        static let backgroundColor: UIColor = .gray.withAlphaComponent(0.1)
        static let highlightedSectionColor: UIColor = .systemRed.withAlphaComponent(0.7)
    }
    enum Numbers {
        static let circleInDegrees: CGFloat = 360
        static let minutesPerHour: CGFloat = 60
        static let secondsPerMinute: CGFloat = 60
        static let degreesPerSecond: CGFloat = circleInDegrees / (minutesPerHour * secondsPerMinute)
    }
}
