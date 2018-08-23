//
//  ViewController.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/21/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import UIKit
import CoreData

class toDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")  //can call it anything
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //can create the context this way
    //let defaults = UserDefaults.standard  //allows app data to persist after app termination
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let items = defaults.array(forKey: "to do list array") as? [String] // reload this
//        {
//            itemsArray = items
//        }
       loadItems()
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done  //wanna save this
       
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark add new items section
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks action button on alert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "to do list array")  // now data is created in a plist file so you can retrieve saved item with a key
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
   

    }
    func saveItems() {
        //let encoder = PropertyListEncoder()
        do {
            //let data = try encoder.encode(itemArray)
            //try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()  //this resets and reloads taking into account the new array
        //now show alert
    }
//    func loadItems() {
//
//        do {
//        let data = try Data(contentsOf: dataFilePath!)
//        let decoder = PropertyListDecoder()
//        itemArray = try decoder.decode([Item].self, from: data)
//        } catch {
//            print(error)
//        }
//    }
    func loadItems() {  //reading from coredata
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error retrieving data \(error)")
        }
    }
    
    //Deleting in CoreData
    func delete(indexPath : IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveItems()
    }
}

