//
//  ViewController.swift
//  PicDemo
//
//  Created by ko on 2020/9/22.
//  Copyright © 2020 SM. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var apiWorker = AllenRequestCenter.sharedInstance
    let nextViewButton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        //navigationController
        title = "JSONPlaceholder"
        
        //Button
        nextViewButton.translatesAutoresizingMaskIntoConstraints = false
        nextViewButton.addTarget(self, action: #selector(toSecondViewController(_ :)), for: .touchUpInside)
        nextViewButton.setTitle("Request API", for: .normal)
        nextViewButton.setTitleColor(.blue, for: .normal)
        nextViewButton.backgroundColor = .clear
        
        self.view.addSubview(nextViewButton)
        
        NSLayoutConstraint.activate([
            nextViewButton.widthAnchor.constraint(equalToConstant: 120),
            nextViewButton.heightAnchor.constraint(equalToConstant: 120),
            nextViewButton.centerYAnchor.constraint(lessThanOrEqualTo: self.view.centerYAnchor, constant: -80),
            nextViewButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    
    }
    
    
    func addActivityIndicator() {
        let indicatorView = UIActivityIndicatorView(style:.large)
        indicatorView.color = .blue
        indicatorView.backgroundColor = .white
        indicatorView.alpha = 0.5
        indicatorView.layer.cornerRadius = 10
        indicatorView.frame = indicatorView.frame.insetBy(dx: -10, dy: -10)
        indicatorView.center = self.view.center
        indicatorView.tag = 1001
        self.view.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
    func removeActivityIndicator() {
        self.view.viewWithTag(1001)?.removeFromSuperview()
    }
    
    @objc func toSecondViewController(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false;
        
        addActivityIndicator()
        apiWorker.getDatasWithUrl(url: APPURL.Jsonplaceholder , success: { [weak self] (params: Array<Dictionary<String,Any>>, code: Int) in
            guard let self = self else { return }
            
            self.selectTabControllerForButton(sender)
            do {
                let data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let decodePhotos = try decoder.decode([Photo].self, from: data)
                
                DispatchQueue.main.async {
                    let secondVC = SecondViewController(nibName: nil, bundle: nil)
                    secondVC.photoViewmodel = PhotoViewModel(photos: decodePhotos)
                    secondVC.view.backgroundColor = .white
                    self.navigationController?.pushViewController(secondVC, animated: true)
                    self.removeActivityIndicator()
                }
                
            }catch {
                debugPrint("Error occurred")
            }
            
        }, failure: { [weak self](AFError, code ,desc) in
                guard let self = self else { return }
                self.selectTabControllerForButton(sender)
                self.removeActivityIndicator()
        })
    }
    
 
    func selectTabControllerForButton(_ sender: UIButton) {
        sender.isUserInteractionEnabled = true
    }
}

