import Foundation

extension CGFloat {
    var degreeToRadian: CGFloat {
        self * .pi / 180
    }
    
    var radianToDegree: CGFloat {
        self * 180 / .pi
    }
}
