//
//  HomeViewController.swift
//  MySampled
//
//  Created by Lion on 30/12/2023.
//
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var beginButton: UIButton!
    @IBAction func passOtherView(_: Any) {
        let firstViewController = ViewController()
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType(rawValue: "flip")
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(firstViewController, animated: false)
    }

}
