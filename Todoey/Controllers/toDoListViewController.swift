//
//  ViewController.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/21/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class toDoListViewController: SwipeTableViewController{
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    //selected category to load up all relevant items
    var selectedCategory : Category? {
        didSet {  //as soon as the category is set, load items
            loadItems()
        }
    }
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")  //can call it anything
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //can create the context this way
    //let defaults = UserDefaults.standard  //allows app data to persist after app termination
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       tableView.separatorStyle = .none
 //       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let items = defaults.array(forKey: "to do list array") as? [String] // reload this
//        {
//            itemsArray = items
//        }
//       loadItems()
    }


    //MARK: Tableview data soruce methods
    //Tells how many rows are in there total
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    //characteristics of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
            if let color = FlatSkyBlue().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        //Ternary operator
        //value = condition? valueIfTrue :valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
            return cell
    }
    //tells which row has selected by indexPath.row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done  //wanna save this
       
      //  saveItems()
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                //    realm.delete(item)
                item.done = !item.done
            }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark add new items section
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks action button on alert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Can't add a new item \(error)")
                }
                
            }
//            //self.defaults.set(self.toDoItems, forKey: "to do list array")  // now data is created in a plist file so you can retrieve saved item with a key
         
        self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
   

    }
//    func saveItems() {
//        //let encoder = PropertyListEncoder()
//        do {
//            //let data = try encoder.encode(toDoItems)
//            //try data.write(to: dataFilePath!)
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//        tableView.reloadData()  //this resets and reloads taking into account the new array
//        //now show alert
//    }
//    func loadItems() {
//
//        do {
//        let data = try Data(contentsOf: dataFilePath!)
//        let decoder = PropertyListDecoder()
//        toDoItems = try decoder.decode([Item].self, from: data)
//        } catch {
//            print(error)
//        }
//    }
    //sets a default value to request if no parameters are given
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {  //reading from coredata
//        //let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            toDoItems = try context.fetch(request)
//        } catch {
//            print("Error retrieving data \(error)")
//        }
//        tableView.reloadData()
//    }
    
//    //Deleting in CoreData
//    func delete(indexPath : IndexPath) {
//        context.delete(toDoItems[indexPath.row])
//        toDoItems.remove(at: indexPath.row)
//        saveItems()
//    }
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                realm.delete(item)
            }
            } catch {
                print("Error deleting item")
            }
        }
    }
}
//MARK: - Search bar methods
extension toDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        //        let request : NSFetchRequest<Item> = Item.fetchRequest() //read from database
//        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        loadItems(with: request, predicate: predicate)
    }
    //only triggered when search bar is cleared
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadItems()
            DispatchQueue.main.async {  //puts this in the foreground
              searchBar.resignFirstResponder()  //notifies search bar to resign status (no longer selected)
            }

        }
    }
}

