//
//  BookSeatViewController.swift
//  HeroKuApp
//
//  Created by Azhar on 25/01/19.
//  Copyright © 2019 Orbysol Systems Pvt Ltd. All rights reserved.
//

import UIKit

class BookSeatViewController: UIViewController {

    @IBOutlet weak var seatsView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var seatsTableView: UITableView!
    
    var desks = [[String:Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAvailableDesks()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDesksResponce(_:)), name: .DidReceiveDesksResponce, object: nil)
        
        self.seatsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "seatsTableViewCell")

    }
    
    func getAvailableDesks()  {
        let service = Services()
        service.getAvailabeDesks()
    }
    
    @objc func didReceiveDesksResponce(_ notification: Notification) {
        DispatchQueue.main.sync {
            desks = (UserDefaults.standard.object(forKey: "desks") as? [[String:Any?]])!
            self.seatsTableView.reloadData()
        }
    }
    
    @IBAction func selectSeatButtonTapped(_ sender: Any) {
        self.seatsView.isHidden = false
        self.datePickerView.isHidden = true
    }
    
    @IBAction func selectDateButtonTapped(_ sender: Any) {
        self.seatsView.isHidden = true
        self.datePickerView.isHidden = false
    }
    
    
    @IBAction func seatsViewDoneButtonTapped(_ sender: Any) {
        seatsView.isHidden = true
    }
    
    @IBAction func datePickerDoneButtonTapped(_ sender: Any) {
        datePickerView.isHidden = true
    }
    
    @IBAction func bookSeatButtonTapped(_ sender: Any) {
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
    }

}
extension BookSeatViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:"seatsTableViewCell") as UITableViewCell!

        return cell
    }
}
