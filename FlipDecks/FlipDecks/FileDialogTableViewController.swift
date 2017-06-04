//
//  FileDialogTableViewController.swift
//  Browse
//
//  Created by Nicola Greth on 31.05.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class FileDialogTableViewController: UITableViewController {
    
    var files : [String] = []
    var selectedFile : String = ""
    var directoryURL : URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("FlipDecks", isDirectory: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listDirectoryContent()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //saves content of FlipDecks directory in string array files
    func listDirectoryContent() {
        do {
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            for file in allFiles {
                if file.contains(".txt") {
                    files.append(file)
                }
            }
        } catch {
            do {
                try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                listDirectoryContent()
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //row count of tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    //show available files in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        cell.textLabel?.text = files[indexPath.row]
        return cell
    }
    
    
    //get selected file
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFile = files[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let openFileDestination = segue.destination as? OpenFileViewController
        openFileDestination?.selectedFile = self.selectedFile
        
    }

    
}
