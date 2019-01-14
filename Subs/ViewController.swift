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
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Players.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = Players[indexPath.row].name + " (" + Players[indexPath.row].subCount() + ")"
            cell.detailTextLabel?.text = Players[indexPath.row].fieldTime()
            cell.accessoryType = .detailButton
            
            if (Players[indexPath.row].enabled) {
                cell.textLabel?.isEnabled = true
            } else {
                cell.textLabel?.isEnabled = false
            }
        default:
            cell.textLabel?.text = "This shouldn't happen"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "On Field"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let plusAction = UIContextualAction(style: .normal, title: "+") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in

            switch indexPath.section {
            case 0:
                if (self.Players[indexPath.row].enabled) {
                    self.Players[indexPath.row].onTheField += 1
                } else {
                    self.Players[indexPath.row].subbed += 1
                }
            default:
                break
            }

            tableView.reloadData()

            actionPerformed(true)
        }

        let subtractAction = UIContextualAction(style: .normal, title: "-") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in

            switch indexPath.section {
            case 0:
                if (self.Players[indexPath.row].enabled) {
                    self.Players[indexPath.row].onTheField -= 1
                } else {
                    self.Players[indexPath.row].subbed -= 1
                }
            default:
                break
            }

            tableView.reloadData()
            actionPerformed(true)
        }
        
        let nameAction = UIContextualAction(style: .normal, title: "name") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            
            let alert = UIAlertController(title: "Update", message: "Player Name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0].text
                self.Players[indexPath.row].name = (textField)!
                tableView.reloadData()
            }))
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter name:"
            })
            
            self.present(alert, animated: true, completion: nil)
            actionPerformed(true)
        }
        
        return UISwipeActionsConfiguration(actions: [plusAction, subtractAction, nameAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let onAction = UIContextualAction(style: .normal, title: "on") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            
            self.Players[indexPath.row].enabled = true
            
            tableView.reloadData()
            actionPerformed(true)
        }
        
        let offAction = UIContextualAction(style: .normal, title: "off") {
            (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            
            self.Players[indexPath.row].enabled = false
            self.Players[indexPath.row].subbed = 0
            self.Players[indexPath.row].onTheField = 0
            
            tableView.reloadData()
            actionPerformed(true)
        }
        
        return UISwipeActionsConfiguration(actions: [onAction, offAction])
    }
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBAction func resetFieldTime(_ sender: Any) {
        let confirm =  UIAlertController(title: "Are You Sure?", message: "Reset Field Time?", preferredStyle: .alert)
        
        let yesAction =  UIAlertAction(title: "Yes", style: .destructive) {
            action in
            for i in 0..<self.Players.count {
                self.Players[i].onTheField = 0
                self.Players[i].subbed = 0
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
            if (self.Players[i].enabled) {
                self.Players[i].onTheField += 1
                self.Players[i].subbed = 0
            } else {
                self.Players[i].subbed += 1
            }
        }
        
        self.taskTableView.reloadData()
    }

    @IBAction func AddPlayer(_ sender: Any) {
        let length = Players.count
        let player = PlayerStat.init(name: "Player" + String(length + 1), totalField: 0, onTheField: 0, subbed: 0, enabled: true)
        
        Players.append(player)
        self.taskTableView.reloadData()
    }

    @IBAction func RemovePlayer(_ sender: Any) {
        let confirm =  UIAlertController(title: "Are You Sure?", message: "Remove Player?", preferredStyle: .alert)

        let yesAction =  UIAlertAction(title: "Yes", style: .destructive) {
            action in
            
            self.Players.removeLast()
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
    
    //  Create [String] arrays of tasks
    var Players = [
        PlayerStat.init(name: "Alvin", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Anthony", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Brady", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Grayden", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Jackson", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Jahari", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Kaelan", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Nate", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Neil", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Parker", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Ruby", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Sebas", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "Sevi", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "us", totalField: 0, onTheField: 0, subbed: 0, enabled: false),
        PlayerStat.init(name: "them", totalField: 0, onTheField: 0, subbed: 0, enabled: false)
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

