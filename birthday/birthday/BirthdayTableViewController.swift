//
//  BirthdayTableViewController.swift
//  birthday
//
//  Created by Maria Teresa Rojo on 1/31/18.
//  Copyright © 2018 Maria Rojo. All rights reserved.
//

import UIKit
import CoreData

class BirthdayTableViewController: UITableViewController, AddBirthdayDelegate {

    var birthdays = [BirthdayItem]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell

        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "d"
        
        cell.nameLabel.text = birthdays[indexPath.row].name
        cell.giftListLabel.text = birthdays[indexPath.row].gifts
        cell.monthLabel.text = formatter1.string(from: birthdays[indexPath.row].date!)
        cell.dayLabel.text = formatter2.string(from: birthdays[indexPath.row].date!)

        return cell
    }
    
    func fetchAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BirthdayItem")
        do {
            let result = try managedObjectContext.fetch(request)
            birthdays = result as! [BirthdayItem]
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func save(_ controller: AddEditViewController, with name: String, gifts: String, and date: Date, at indexPath: IndexPath?) {
        if let ip = indexPath {
            let item = birthdays[ip.row]
            item.name = name
            item.gifts = gifts
            item.date = date
        } else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "BirthdayItem", into: managedObjectContext) as! BirthdayItem
            item.name = name
            item.gifts = gifts
            item.date = date
            birthdays.append(item)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        dismiss(animated: true, completion: nil)
        fetchAll()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addSegue", sender: indexPath)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = birthdays[indexPath.row]
        managedObjectContext.delete(item)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        birthdays.remove(at: indexPath.row)
        fetchAll()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addEditViewController = navigationController.topViewController as! AddEditViewController
        addEditViewController.delegate = self
        
        if let indexPath = (sender as? IndexPath) {
            addEditViewController.name = birthdays[indexPath.row].name
            addEditViewController.gifts = birthdays[indexPath.row].gifts
            addEditViewController.date = birthdays[indexPath.row].date
            addEditViewController.indexPath = indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
