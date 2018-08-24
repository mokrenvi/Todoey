//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/23/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       
        tableView.separatorStyle = .none //lets colors bleed to the edge
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
           // self.categories.append(newCategory)  not needed automatically updates
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //if its not nill, else return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
        cell.textLabel?.text = category.name ?? "No categories added yet"
        cell.backgroundColor = UIColor(hexString: category.color ?? "2F6DC5")
        }
            return cell  //renders on screen
    }
    
    
    //MarK: - Tableview delegate method (save and load data from core data)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! toDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //Mark: - Data manipulation (add new categories)
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories() {
        categories = realm.objects(Category.self) //pulls out all items outside of realm that are of category objects
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//        categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    override func updateModel(at indexPath: IndexPath) {
        //Update our data model
        // handle action by updating model with deletion
                    if let categoryForDeletion = self.categories?[indexPath.row] {
                        do {
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        } catch {
                            print("Error deleting category, \(error)")
                        }
        
                    }
    }
}

