//
//  ViewController.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/21/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import UIKit

class toDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demorogon"]
    let defaults = UserDefaults.standard  //allows app data to persist after app termination
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "to do list array") as? [String] // reload this
        {
            itemsArray = items
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Tableview data soruce methods
    //Tells how many rows are in there total
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //characteristics of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //tells which row has selected by indexPath.row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark add new items section
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks action button on alert
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "to do list array")  // now data is created in a plist file so you can retrieve saved item with a key
            
            self.tableView.reloadData()  //this resets and reloads taking into account the new array
            //now show alert
          }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

