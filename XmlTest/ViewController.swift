//
//  ViewController.swift
//  XmlTest
//
//  Created by Дмитрий Чепанов on 23.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    let lock = NSLock()

    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(makeRequest),
                                         userInfo: nil,
                                         repeats: true)
    }

    
    @objc func makeRequest() {
        guard let url = URL(string: "https://www.timeanddate.com/worldclock/russia/moscow") else { return }

        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                guard
                    let data = data,
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                else { return }
                guard
                    let date = dataString.components(separatedBy: "class=h1>").last?.prefix(8)
                else { return }
                
//                print("DONE: \(date)")
                
                self.lock.lock()
                DispatchQueue.main.async {
                    self.label.text = String(date)
                }
                self.lock.unlock()
            }
//            print("TASK: \(task)")
            task.resume()
        }
        
    }
}

