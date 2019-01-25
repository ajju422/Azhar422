//
//  StaffViewController.swift
//  HeroKuApp
//
//  Created by Azhar on 25/01/19.
//  Copyright © 2019 Orbysol Systems Pvt Ltd. All rights reserved.
//

import UIKit

class StaffViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var staffTableView: UITableView!
    
    var seatBookings = [[String:Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.staffTableView.delegate = self
        self.staffTableView.dataSource = self
        self.staffTableView.register(UINib.init(nibName: "StaffTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffTableViewCell")
        
    }

    func getSeats() {
            let service = Services()
            service.getAllSeatsBooking()
            NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSeatsResponce(_:)), name: .DidReceiveSeatsResponce, object: nil)
    }
    
    @objc func didReceiveSeatsResponce(_ notification: Notification) {
        DispatchQueue.main.async {
            let bookings = UserDefaults.standard.object(forKey: "bookings")
            self.seatBookings = bookings as! [[String:Any?]]
            self.staffTableView.reloadData()
        }
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
    @IBAction func bookNewSeatButtonTapped(_ sender: Any) {
        let bookSeatVc = BookSeatViewController.init(nibName: "BookSeatViewController", bundle: nil)
        self.present(bookSeatVc, animated: true, completion: nil)
    }
}

extension StaffViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seatBookings.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StaffTableViewCell = tableView.dequeueReusableCell(withIdentifier:"StaffTableViewCell") as! StaffTableViewCell!
        
        return cell
    }
}
