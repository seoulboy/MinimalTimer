import UIKit

final class TimerViewController: UIViewController {
    enum Constant {
        static let dotRadius: CGFloat = circleRadius/8
        static let circleRadius: CGFloat = (UIScreen.main.bounds.width / 2) - 50
        static let framePadding: CGFloat = 50
    }
    
    private lazy var timerFrameView: TimerFrameView = createTimerFrameView()
    private lazy var circleDrawView: CircleDrawView = createCircleDrawView()
    private lazy var centerDot: UIView = createDot()
    private var enteredBackgroundTime: Date?
    private let viewModel: TimerViewModelType
    private let notificationCenter = UNUserNotificationCenter.current()

    init(viewModel: TimerViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
        addSubviews()
        layout()
        bindNotification()
        requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print(error)
            }
        }
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
            timerFrameView.widthAnchor.constraint(equalToConstant: Constant.circleRadius * 2 * 1.30),
            timerFrameView.heightAnchor.constraint(equalToConstant: Constant.circleRadius * 2 * 1.30)
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
        view.backgroundColor = .systemBackground
    }
    
    private func createTimerFrameView() -> TimerFrameView {
        let view = TimerFrameView(radius: Constant.circleRadius)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createCircleDrawView() -> CircleDrawView {
        let view = CircleDrawView(radius: Constant.circleRadius)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }
    
    private func createDot() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = Constant.dotRadius
        self.view.addSubview(view)
        return view
    }
}

// MARK: Notifications
extension TimerViewController {
    private func bindNotification() {
        bindWillEnterForegroundNotification()
        bindDidEnterBackgroundNotification()
    }
    
    private func bindWillEnterForegroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func bindDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc
    private func willEnterForeground() {
        guard let enteredBackgroundTime else { return }
        subtractElapsedTime(from: enteredBackgroundTime)
        circleDrawView.startTimer()
    }
    
    private func subtractElapsedTime(from enteredBackgroundTime: Date) {
        let elapsedTime = enteredBackgroundTime.distance(to: .now)
        circleDrawView.subtractSeconds = CGFloat(elapsedTime)
    }
    
    @objc
    private func didEnterBackground() {
        guard circleDrawView.timer?.isValid == true else { return }
        circleDrawView.stopTimer()
        enteredBackgroundTime = Date()
    }
}

// MARK: - Schedule Local Push Notification
extension TimerViewController: CircleDrawViewDelegate {
    func didSetTimer(secondsLeft: Int) {
        scheduleNotification(after: secondsLeft)
        timerFrameView.configureNumberLabelVisiblity(isHidden: true)
    }
    
    func touchesBegan() {
        timerFrameView.configureNumberLabelVisiblity(isHidden: false)
    }
    
    func timerDone() {
        timerFrameView.configureNumberLabelVisiblity(isHidden: false)
    }
    
    private func scheduleNotification(after seconds: Int) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.body = "Got'em done!"
        content.sound = UNNotificationSound.default
        
        guard let triggerDate = Calendar.current.date(byAdding: .second, value: seconds, to: .now) else { return }
        let dateComponents = Calendar.current.dateComponents([.minute,.second,.nanosecond], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }
}

extension TimerViewController {
    static func create(with viewModel: TimerViewModel) -> TimerViewController {
        let vc = TimerViewController(viewModel: viewModel)
        return vc
    }
}

extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}

