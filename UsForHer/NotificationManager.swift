
import CoreLocation
import UserNotifications

class LocationNotificationScheduler: NSObject {
    
    // MARK: - Public Properties
    
    weak var delegate: LocationNotificationSchedulerDelegate? {
        didSet {
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Public Functions
    
    /// Request a geo location notification with optional data.
    ///
    /// - Parameter data: Data that will be sent with the notification.
    func requestNotification(with notificationInfo: LocationNotificationInfo) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("god fucking damn it not determined")
            //locationManager.requestWhenInUseAuthorization()
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .authorizedWhenInUse, .authorizedAlways:
            print("got authroazation")
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .restricted, .denied:
            print("god fucking damn it restrictedxc denied")
            delegate?.locationPermissionDenied()
            break
        default:
            break
        }
    }
    
    public func removeNotificationAfterShow(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    public func clearAll(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    func getCurrentNotif(){
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
    func getCurrentNotif()-> UNUserNotificationCenter{
        return UNUserNotificationCenter.current()
    }
    func deleteNotif(_ notifId: String){
        print("deleted notif")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifId])
    }
    func getNotifList()-> Int{
        var out = [UNNotificationRequest]()
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                out.append(request)
                print("||||")
                print(request)
            }
        })
        return out.count
    }
}

// MARK: - Private Functions
private extension LocationNotificationScheduler {
    
    func askForNotificationPermissions(notificationInfo: LocationNotificationInfo) {
        print("asking for permissions")
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    DispatchQueue.main.async {
                        self?.delegate?.notificationPermissionDenied()
                    }
                    return
                }
                self?.requestNotification(notificationInfo: notificationInfo)
        })
    }
    
    func requestNotification(notificationInfo: LocationNotificationInfo) {
        let notification = notificationContent(notificationInfo: notificationInfo)
        let destRegion = destinationRegion(notificationInfo: notificationInfo)
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationInfo.notificationId,
                                            content: notification,
                                            trigger: trigger)
     //   print(request)

        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.delegate?.notificationScheduled(error: error)
            }
        }
        
    }

    
    func notificationContent(notificationInfo: LocationNotificationInfo) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        
        return notification
    }
    
    func destinationRegion(notificationInfo: LocationNotificationInfo) -> CLCircularRegion {
        let destRegion = CLCircularRegion(center: notificationInfo.coordinates,
                                          radius: notificationInfo.radius,
                                          identifier: notificationInfo.locationId)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        return destRegion
    }
}
