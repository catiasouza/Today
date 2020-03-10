//
//  ViewController.swift
//  Today01
//
//  Created by Catia Miranda de Souza on 19/02/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItens: Results<Item>?
    var realm = try! Realm()
    
    @IBOutlet weak var search: UISearchBar!
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
     
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour{
            
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            if let navBarColour = UIColor(hexString: colourHex){
                navBar.backgroundColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour,returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                search.barTintColor = navBarColour
            }
           
            
        }
    }
    
    //MARK: - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItens?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItens?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            //EFEITO GRADIENTE
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:  CGFloat(indexPath.row ) / CGFloat(todoItens!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            //            print("Versao 1: \(CGFloat(indexPath.row / todoItens!.count))")
            //            print("Versao 2: \(CGFloat(indexPath.row ) / CGFloat(todoItens!.count)))")
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Itens Added"
        }
        
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItens?[indexPath.row]{
            do{
                try realm.write{
                    // realm.delete(item)    Exclusao
                    item.done = !item.done
                }
            }catch{
                print("Error")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentgCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()// para pesquisar p data
                        currentgCategory.itens.append(newItem)
                    }
                }catch{
                    print("Error saving new itens,\(error)")
                }
            }
            self.tableView.reloadData()
        }
        //CRIAR UM TEXTFIELD NO ALERT
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manupulation Methods
    
    
    func loadItems(){
        
        todoItens = selectedCategory?.itens.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    override func updatModel(at indexPath: IndexPath) {
        if let item = todoItens?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(item)
                }
            }catch{
                print("Erro no update")
            }
        }
    }
    
}
//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItens = todoItens?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)//P PESQUISAR P TITULO TROQUE DATECREATED POR TITLEtitle CONTAINS[cd] %@"
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

