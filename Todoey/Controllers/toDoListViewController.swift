//
//  ViewController.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/21/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import UIKit

class toDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard  //allows app data to persist after app termination
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Save Mike"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Buy Mike a bear"
        itemArray.append(newItem3)
        //        if let items = defaults.array(forKey: "to do list array") as? [String] // reload this
//        {
//            itemsArray = items
//        }
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //Ternary operator
        //value = condition? valueIfTrue :valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //tells which row has selected by indexPath.row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark add new items section
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks action button on alert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
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

