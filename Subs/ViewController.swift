//
//  ViewController.swift
//  Subs
//
//  Created by Mark Saunders on 2/6/18.
//  Copyright © 2018 Jenark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Table View Data Source Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row) in \(indexPath.section)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Players.count
        case 1:
            return Players.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = Players[indexPath.row].name
            cell.detailTextLabel?.text = Players[indexPath.row].fieldTime()
            cell.accessoryType = .detailButton
        case 1:
            cell.textLabel?.text = Players[indexPath.row].name
            cell.detailTextLabel?.text = Players[indexPath.row].subCount()
        default:
            cell.textLabel?.text = "This shouldn't happen"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "On Field"
        case 1:
            return "Sub Count : Total On Field"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title: "+") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            
            switch indexPath.section {
            case 0:
                self.Players[indexPath.row].onTheField += 1
                self.Players[indexPath.row].totalField += 1
            case 1:
                self.Players[indexPath.row].subbed += 1
                self.Players[indexPath.row].onTheField = 0
            default:
                break
            }
            
            tableView.reloadData()
            
            actionPerformed(true)
        }
        
        let removeAction = UIContextualAction(style: .normal, title: "-") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            
            switch indexPath.section {
            case 0:
                self.Players[indexPath.row].onTheField -= 1
                self.Players[indexPath.row].totalField -= 1
            case 1:
                self.Players[indexPath.row].subbed -= 1
            default:
                break
            }
            
            tableView.reloadData()
            
            actionPerformed(true)
        }

        let resetAction = UIContextualAction(style: .normal, title: "reset") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            
            switch indexPath.section {
            case 0:
                self.Players[indexPath.row].onTheField = 0
            case 1:
                self.Players[indexPath.row].subbed = 0
            default:
                break
            }

            
            tableView.reloadData()
            
            actionPerformed(true)
        }

        
        return UISwipeActionsConfiguration(actions: [addAction, removeAction, resetAction])
    }
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBAction func resetFieldTime(_ sender: Any) {
        let confirm =  UIAlertController(title: "Are You Sure?", message: "Reset Field Time?", preferredStyle: .alert)
        
        let yesAction =  UIAlertAction(title: "Yes", style: .destructive) {
            action in
            for i in 0..<self.Players.count {
                self.Players[i].onTheField = 0
            }
            
            self.taskTableView.reloadData()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) {
            action in
            print("That was a close one!")
        }
        
        // add actions to alert controller
        confirm.addAction(yesAction)
        confirm.addAction(noAction)
        
        // show it
        present(confirm, animated: true, completion: nil)
    }
    
    @IBAction func AddFieldTime(_ sender: Any) {
        for i in 0..<self.Players.count {
            self.Players[i].onTheField += 1
            self.Players[i].totalField += 1
        }
        
        self.taskTableView.reloadData()
    }
    
    //  Create [String] arrays of tasks
    var Players = [
        PlayerStat.init(name: "Alvin", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Brady", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Jack W", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Jackson", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Jahari", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Kaelan", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Nate", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Ruby", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Tyson", totalField: 0, onTheField: 0, subbed: 0),
        PlayerStat.init(name: "Zack", totalField: 0, onTheField: 0, subbed: 0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

