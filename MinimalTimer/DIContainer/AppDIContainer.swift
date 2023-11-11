import Foundation

final class AppDIContainer {
    func makeTimerDIContainer() -> TimerDIContainer {
        return TimerDIContainer()
    }
}
