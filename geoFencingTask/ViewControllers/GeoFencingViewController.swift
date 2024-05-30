//
//  GeoFencingViewController.swift
//  geoFencingTask
//
//  Created by Aitazaz on 29/05/2024.
//

import UIKit
import CoreLocation

class GeoFencingViewController: UIViewController {
    
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    private let dwellTimeCalculator: DwellTimeCalculator = {
        let timeCalculator = DwellTimeCalculator()
        return timeCalculator
    }()
    
    private let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Latitude"
        textField.text = "30.3753"
        // Set border properties
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0 // Optional: For rounded corners
        
        // Add padding inside the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Longitude"
        textField.text = "69.3451"
        
        // Set border properties
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0 // Optional: For rounded corners
        
        // Add padding inside the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let radiusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter radius"
        textField.text = "20"
        
        // Set border properties
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0 // Optional: For rounded corners
        
        // Add padding inside the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let regionNameTextField: UITextField = {
        let textField = UITextField()
        // Set border properties
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0 // Optional: For rounded corners
        
        // Add padding inside the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.text = "Pakistan"
        textField.placeholder = "Enter Region Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system) // Using system type gives a default button style
        button.setTitle("Create Region", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        // Add target action
        button.addTarget(self, action: #selector(createRegionButtonTapped), for: .touchUpInside)
        
        // Set constraints
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50) // Set the height to 50
        ])
        
        return button
    }()
    
    lazy var VStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [
            latitudeTextField,
            longitudeTextField,
            radiusTextField,
            regionNameTextField,
            button
        ])
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fillEqually
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    
    var geofenceRegion: CLCircularRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()

        for region in locationManager.monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(VStackView)
        NSLayoutConstraint.activate([
            VStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            VStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            VStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
        ])
    }
}

extension GeoFencingViewController {
    
    func setupGeofence(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        radius: CLLocationDistance,
        regionIdentifier: String
    ) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        geofenceRegion = CLCircularRegion(center: center, radius: radius, identifier: regionIdentifier)
        geofenceRegion?.notifyOnEntry = true
        geofenceRegion?.notifyOnExit = true
        if let region = geofenceRegion {
            locationManager.startMonitoring(for: region)
            locationManager.requestState(for: region)
            
            showAlert(title: "Success", text: "Region has been created successfully.")
        }
        
    }
    
    @objc func createRegionButtonTapped() {
        
        self.view.endEditing(true)
        
        if latitudeTextField.text?.isEmpty ?? true ||
            longitudeTextField.text?.isEmpty ?? true ||
            radiusTextField.text?.isEmpty ?? true ||
            regionNameTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", text: "please enter valid/missing data for all fields")
            return
        }
        
        let lat = Double(latitudeTextField.text?.trimmingCharacters(in: .whitespaces) ?? "0") ?? 0.0
        let long = Double(longitudeTextField.text?.trimmingCharacters(in: .whitespaces) ?? "0") ?? 0.0
        let radius = Double(radiusTextField.text?.trimmingCharacters(in: .whitespaces) ?? "0") ?? 0.0
        let identifier = regionNameTextField.text ?? ""
        
        setupGeofence(latitude: lat, longitude: long, radius: radius, regionIdentifier: identifier)
        
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
    
    func showSettongsAlert() {
        let alertController = UIAlertController(title: "Important!",
                                      message: "Please go to Settings and turn on the permissions to use this App for better app experience.",
                                      preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            self.navigationController?.popViewController(animated: true)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }

        
    func showNotification(msg: String, isIntheRegion: Bool, region: CLRegion) {
        let body = "You \(isIntheRegion ? "arrived" : "left") at " + region.identifier + ". \(msg)"
        print(body)
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = body
        notificationContent.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "location_change",
            content: notificationContent,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
}

extension GeoFencingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
//            print("Already inside of the geo-fencing area")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let msg = dwellTimeCalculator.setStartTime(Date())
        print(msg)
        showNotification(msg: msg, isIntheRegion: true, region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let msg = dwellTimeCalculator.setExitTime(Date())
        print(msg)
        showNotification(msg: msg, isIntheRegion: false, region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] // The first location in the array
        print("location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        showAlert(title: "Error", text: error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access granted.")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        case .denied, .restricted:
            showSettongsAlert()
            // Show an alert or guide the user to enable location services
        default:
            break
        }
    }
    
    
}
