//
//  SwipeTableViewController.swift
//  Today01
//
//  Created by Catia Miranda de Souza on 04/03/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //aumentar altura celula
        tableView.rowHeight = 80.0
    }
    //TableView datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Delete cell")
            self.updatModel(at: indexPath)

        }
      
        deleteAction.image = UIImage(named: "delete.png")
        
        return [deleteAction]
    }
    //deletar a celula inteira
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    func updatModel(at indexPath: IndexPath){
        print("updatemodel")
    }
}
