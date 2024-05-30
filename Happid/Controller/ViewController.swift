//
//  ViewController.swift
//  Happid
//
 //

import UIKit

class ViewController: UIViewController {
    
 
    @IBOutlet weak var headingText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let interFont = UIFont(name: "Inter-Bold", size: 24) {
                    let fontMetrics = UIFontMetrics(forTextStyle: .body)
            headingText.font = fontMetrics.scaledFont(for: interFont)
                }
        headingText.numberOfLines = 0
        headingText.lineBreakMode = .byWordWrapping
        headingText.textAlignment = .center
        headingText.textColor = UIColor(named: "#020202")
        

     }
    
    @IBAction func getStarted(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let secondVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                     navigationController?.pushViewController(secondVC, animated: true)
                }
    }
    
    


}

