//
//  ViewController.swift
//  geoFencingTask
//
//  Created by Aitazaz on 29/05/2024.
//

import UIKit

class MainViewController: UIViewController {

    lazy var button: UIButton = {
        let button = UIButton(type: .system) // Using system type gives a default button style
        button.setTitle("Let's GeoFencing", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        // Add target action
        button.addTarget(self, action: #selector(geoFencingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        setupUI()
    }

    private func setupUI() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}


extension MainViewController {
    
    @objc func geoFencingButtonTapped() {
        navigationController?.pushViewController(GeoFencingViewController(), animated: true)
    }
}

