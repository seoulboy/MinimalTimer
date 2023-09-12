import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let timerDIContainer = appDIContainer.makeTimerDIContainer()
        let flow = timerDIContainer.makeTimerCoordinator(navigationController: navigationController)
        flow.start()
    }
}
