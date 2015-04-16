//
//  WorkTableViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/16/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class WorkTableViewController: UITableViewController {
    
    @IBOutlet weak var myPocketCell: WorkTableViewCell!
    @IBOutlet weak var lapkaCell: WorkTableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCells()
    }
    
    func configureCells() {
        let cells = [myPocketCell, lapkaCell]
        
        for cell in cells {
            cell.appStoreButton.layer.borderColor = cell.appStoreButton.tintColor?.CGColor
            cell.iconImageView.clipsToBounds = true
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
