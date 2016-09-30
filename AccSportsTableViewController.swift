//
//  AccSportsTableViewController.swift
//  ACCSports
//
//  Created by CS3714 on 9/29/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit



class AccSportsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    
    // These two instance variables are used for Search Bar functionality
    
    var searchResults = [String]()
    
    var searchResultsController = UISearchController()
    
    
    
    /*
     
     -------------------------------------------------------------------------------
     
     accSports.plist file contains 3 dictionaries embedded into each other:
     
     -------------------------------------------------------------------------------
     
     Dictionary 1: Key = University Name    Value = object reference of Dictionary 2
     
     Dictionary 2: Key = Sport Category     Value = object reference of Dictionary 3
     
     Dictionary 3: Key = Sport Name         Value = sport's website URL
     
     
     
     -------------------------------------------------------------------------------
     
     accUniversityLogos.plist file contains one dictionary:
     
     -------------------------------------------------------------------------------
     
     Dictionary 4: Key = University Name    Value = University Logo File Name
     
     
     
     -------------------------------------------------------------------------------
     
     sportNames.plist file contains one array:
     
     -------------------------------------------------------------------------------
     
     Array:  sportNames
     
     */
    
    
    
    /*
     
     ===============================================================================================
     
     The Swift Programming Language Version 3.0 guide indicates the following:
     
     
     
     Type Casting for Any and AnyObject
     
     
     
     Swift provides two special types for working with nonspecific types:
     
     
     
     <> Any can represent an instance of any type at all, including function types.
     
     <> AnyObject can represent an instance of any class type.
     
     
     
     Use Any and AnyObject only when you explicitly need the behavior and capabilities they provide.
     
     It is always better to be specific about the types you expect to work with in your code.
     
     ===============================================================================================
     
     */
    
    
    
    //---------- Create and Initialize the Dictionaries -----------------
    
    
    
    var dict1_UniversityName_Dict2  = [String: AnyObject]()
    
    var dict2_SportCategory_Dict3   = [String: AnyObject]()
    
    var dict3_SportName_SportURL    = [String: AnyObject]()
    
    
    
    var dict4_UniversityName_UniversityLogoFileName  = [String: String]()
    
    
    
    /************************************************************************************
     
     The dictionary naming convention, dictN_keyDescriptor_valueDescriptor, as used above
     
     is strongly recommended to make your code highly readable and understandable.
     
     ***********************************************************************************/
    
    
    
    //---------- Create and Initialize the Arrays -----------------------
    
    
    
    var universityNames     = [String]()
    
    var sportCategoryNames  = [String]()
    
    var sportNames          = [String]()
    
    
    
    /*
     
     Instance variable holding the object reference of the Table View (UITableView)
     
     object created in the Storyboard, i.e., Interface Builder (IB).
     
     */
    
    @IBOutlet var accSportsTableView: UITableView!
    
    
    
    /*
     
     When a table view row is expanded, new rows are inserted after it into the table view.
     
     When a table view row is collapsed, the rows expanded under it are deleted.
     
     
     
     These insertions and deletions will change the table view list. We define
     
     tableViewList as a changeable array to hold the current rows of the table view.
     
     */
    
    var tableViewList = [String]()
    
    
    
    // The URL of the sport website to be passed to the WebsiteViewController object
    
    var urlOfWebsite: String = ""
    
    
    
    // Index Paths of the selected table view rows
    
    var selectedIndexPath: IndexPath = IndexPath()
    
    var selectedIndexPathPrevious: IndexPath = IndexPath()
    
    
    
    // Flags created and initialized
    
    var sportNameSelected: Bool = false
    
    var selectedRowNumber: Int = 0
    
    
    
    /*
     
     -----------------------
     
     MARK: - View Life Cycle
     
     -----------------------
     
     */
    
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        //---------------------------------------------------
        
        //          Import accSports.plist File
        
        //---------------------------------------------------
        
        
        
        // Obtain the URL to the accSports.plist file in subdirectory "Plist Files"
        
        let accSportsPlistURL: URL? = Bundle.main.url(forResource: "accSports", withExtension: "plist", subdirectory: "Plist Files")
        
        
        
        /*
         
         NSDictionary manages an *unordered* collection of key-value pairs.
         
         Instantiate an NSDictionary object and initialize it with the contents of the accSports.plist file.
         
         */
        
        let dictionary1FromFile: NSDictionary? = NSDictionary(contentsOf: accSportsPlistURL!)
        
        
        
        if let dictionaryForAccSportsPlistFile = dictionary1FromFile {
            
            
            
            // Typecast the created dictionary of type NSDictionary as Dictionary type and
            
            // store its object reference into the instance variable dict1_UniversityName_Dict2
            
            dict1_UniversityName_Dict2 = dictionaryForAccSportsPlistFile as! Dictionary
            
            
            
            /*
             
             allKeys returns a new Array containing the dictionary’s keys as of type AnyObject.
             
             Therefore, typecast the Array of AnyObject types to be of Array of String types.
             
             The keys in the Array are *unordered*; therefore, they need to be sorted.
             
             */
            
            universityNames = dictionaryForAccSportsPlistFile.allKeys as! [String]
            
            
            
            // Sort the universityNames within itself in alphabetical order
            
            universityNames.sort { $0 < $1 }
            
            
            
            /*
             
             // Print the sorted university names
             
             print(universityNames)
             
             
             
             // Print the entire dictionary: dict1_UniversityName_Dict2
             
             print(dict1_UniversityName_Dict2)
             
             */
            
            
            
        } else {
            
            
            
            // Unable to get the file from the main bundle
            
            showErrorMessageFor("accSports.plist")
            
            return
            
        }
        
        
        
        //---------------------------------------------------
        
        //       Import accUniversityLogos.plist File
        
        //---------------------------------------------------
        
        
        
        // Obtain the URL to the accUniversityLogos.plist file in subdirectory "Plist Files"
        
        let accUniversityLogosPlistURL: URL? = Bundle.main.url(forResource: "accUniversityLogos", withExtension: "plist", subdirectory: "Plist Files")
        
        
        
        // Instantiate an NSDictionary object and initialize it with the contents of the accUniversityLogos.plist file.
        
        let dictionary4FromFile: NSDictionary? = NSDictionary(contentsOf: accUniversityLogosPlistURL!)
        
        
        
        if let dictionaryForAccUniversityLogosPlistFile = dictionary4FromFile {
            
            
            
            // Typecast the created dictionary of type NSDictionary as Dictionary type and assign it.
            
            self.dict4_UniversityName_UniversityLogoFileName = dictionaryForAccUniversityLogosPlistFile as! Dictionary
            
            
            
        } else {
            
            
            
            // Unable to get the file from the main bundle
            
            showErrorMessageFor("accUniversityLogos.plist")
            
            return
            
        }
        
        
        
        //---------------------------------------------------
        
        //           Import sportNames.plist File
        
        //---------------------------------------------------
        
        
        
        // Obtain the URL to the sportNames.plist file in subdirectory "Plist Files"
        
        let sportNamesPlistURL: URL? = Bundle.main.url(forResource: "sportNames", withExtension: "plist", subdirectory: "Plist Files")
        
        
        
        // Instantiate an NSArray object and initialize it with the contents of the sportNames.plist file.
        
        let arrayFromFile: NSArray? = NSArray(contentsOf: sportNamesPlistURL!)
        
        
        
        if let sportNamesArray = arrayFromFile {
            
            
            
            // Typecast the created array of type NSArray as Array type and assign it.
            
            self.sportNames = sportNamesArray as! Array
            
            /*
             
             // Print the sorted university names
             
             print(self.sportNames)
             
             */
            
            
            
        } else {
            
            
            
            // Unable to get the file from the main bundle
            
            showErrorMessageFor("sportNames.plist")
            
            return
            
        }
        
        
        
        //-------------- Initialize the table view list --------------
        
        
        
        // Initialize the current table view rows to be the list of the university names
        
        tableViewList = universityNames
        
        
        
        
        
        // Create a Search Results Controller object for the Search Bar
        
        createSearchResultsController()
        
    }
    
    
    
    // Prepare the view before it appears to the user
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        if sportNameSelected {
            
            
            
            // Reload the table view data so that the selected sport name can be
            
            // colored in blue to indicate that it is the selected row.
            
            accSportsTableView.reloadData()
            
        }
        
        
        
        super.viewWillAppear(animated)
        
    }
    
    
    
    // Scroll the selected sport name row towards the middle of the table view
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        if sportNameSelected {
            
            
            
            // Scroll the selected row towards the middle of the table view
            
            accSportsTableView.scrollToRow(at: selectedIndexPath,
                                           
                                           at: UITableViewScrollPosition.middle, animated: true)
            
        }
        
        
        
        super.viewDidAppear(animated)
        
    }
    
    
    
    /*
     
     -----------------------------
     
     MARK: - Display Error Message
     
     -----------------------------
     
     */
    
    func showErrorMessageFor(_ fileName: String) {
        
        
        
        /*
         
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         
         and store its object reference into local constant alertController
         
         */
        
        let alertController = UIAlertController(title: "Unable to Access the File: \(fileName)!",
                                                
                                                message: "The file does not reside in the application's main bundle (project folder)!",
                                                
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        // Create a UIAlertAction object and add it to the alert controller
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        
        // Present the alert controller
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    /*
     
     ---------------------------------------------
     
     MARK: - Creation of Search Results Controller
     
     ---------------------------------------------
     
     */
    
    func createSearchResultsController() {
        
        /*
         
         Instantiate a UISearchController object and store its object reference into local variable: controller.
         
         Setting the parameter searchResultsController to nil implies that the search results will be displayed
         
         in the same view used for searching (under the same UITableViewController object).
         
         */
        
        let controller = UISearchController(searchResultsController: nil)
        
        
        
        /*
         
         We use the same table view controller (self) to also display the search results. Therefore,
         
         set self to be the object responsible for listing and updating the search results.
         
         Note that we made self to conform to UISearchResultsUpdating protocol.
         
         */
        
        controller.searchResultsUpdater = self
        
        
        
        /*
         
         The property dimsBackgroundDuringPresentation determines if the underlying content is dimmed during
         
         presentation. We set this property to false since we are presenting the search results in the same
         
         view that is used for searching. The "false" option displays the search results without dimming.
         
         */
        
        controller.dimsBackgroundDuringPresentation = false
        
        
        
        controller.searchBar.delegate = self
        
        controller.searchBar.placeholder = "Search University Names"
        
        
        
        // Resize the search bar object based on screen size and device orientation.
        
        controller.searchBar.sizeToFit()
        
        
        
        /***************************************************************************
         
         No need to create the search bar in the Interface Builder (storyboard file).
         
         The statement below creates it at runtime.
         
         ***************************************************************************/
        
        
        
        // Set the tableHeaderView's accessory view displayed above the table view to display the search bar.
        
        self.tableView.tableHeaderView = controller.searchBar
        
        
        
        /*
         
         Set self (Table View Controller) define the presentation context so that the Search Bar subview
         
         does not show up on top of the view (scene) displayed by a downstream view controller.
         
         */
        
        self.definesPresentationContext = true
        
        
        
        /*
         
         Set the object reference (controller) of the newly created and dressed up UISearchController
         
         object to be the value of the instance variable searchResultsController.
         
         */
        
        searchResultsController = controller
        
    }
    
    
    
    /*
     
     -----------------------------------------------
     
     MARK: - UISearchResultsUpdating Protocol Method
     
     -----------------------------------------------
     
     
     
     This UISearchResultsUpdating protocol required method is automatically called whenever the search
     
     bar becomes the first responder or changes are made to the text or scope of the search bar.
     
     You must perform all required filtering and updating operations inside this method.
     
     */
    
    func updateSearchResults(for searchController: UISearchController)
        
    {
        
        // Empty the instance variable searchResults array without keeping its capacity
        
        searchResults.removeAll(keepingCapacity: false)
        
        
        
        // Set searchPredicate to search for any character(s) the user enters into the search bar.
        
        // [c] indicates that the search is case insensitive.
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        
        
        // Obtain the university names that contain the character(s) the user types into the Search Bar.
        
        let listOfUniversityNamesFound = (universityNames as NSArray).filtered(using: searchPredicate)
        
        
        
        // Obtain the search results as an array of type String
        
        searchResults = listOfUniversityNamesFound as! [String]
        
        
        
        // Reload the table view to display the search results
        
        self.tableView.reloadData()
        
    }
    
    
    
    /*
     
     ---------------------------------------
     
     MARK: - Search Bar Cancel Button Tapped
     
     ---------------------------------------
     
     */
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        // No sport should be shown as selected when the search bar Cancel button is tapped.
        
        sportNameSelected = false
        
    }
    
    
    
    /*
     
     ----------------------------------------------
     
     MARK: - UITableViewDataSource Protocol Methods
     
     ----------------------------------------------
     
     */
    
    
    
    /*
     
     A Table View object (UITableView) consists of Sections.
     
     A Section consists of Rows.
     
     A Row contains one Cell object (UITableViewCell).
     
     A Cell object is configured with the UI objects (e.g., image, text, accessory icon) to create the look of a row.
     
     */
    
    
    
    // Asks the data source to return the number of sections in the table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        
        return 1    // Our table view has only one section
        
    }
    
    
    
    // Asks the data source to return the number of rows in a section, the number of which is given
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return searchResultsController.isActive ? searchResults.count : tableViewList.count
        
    }
    
    
    
    //-------------------------------------------------------------
    
    //         Prepare and Return a Table View Cell
    
    //-------------------------------------------------------------
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let rowNumber: Int = (indexPath as NSIndexPath).row    // Identify the row number
        
        
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        
        // "University Name Cell", which was specified in the storyboard.
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "University Name Cell") as UITableViewCell!
        
        
        
        // Obtain the name of the row from the table view list
        
        let rowName: String = searchResultsController.isActive ? searchResults[rowNumber] : tableViewList[rowNumber]
        
        
        
        // Set the label text of the cell to be the row name
        
        cell.textLabel!.text = rowName
        
        
        
        // Cell indentation width of 10.0 points is the default value
        
        cell.indentationWidth = 10.0
        
        
        
        if universityNames.contains(rowName) {    // Rows decomposition level = 0
            
            
            
            // Row name is a university name
            
            cell.indentationLevel = 0;
            
            
            
            let universityLogoFileName: String? = dict4_UniversityName_UniversityLogoFileName[rowName]
            
            
            
            cell.imageView!.image = UIImage(named: universityLogoFileName!)
            
            
            
        } else if rowName == "Men's Sports" {           // Rows decomposition level = 1
            
            
            
            cell.indentationLevel = 1
            
            cell.imageView!.image = UIImage(named:"MenSportIcon")
            
            
            
        } else if rowName == "Women's Sports" {         // Rows decomposition level = 1
            
            
            
            cell.indentationLevel = 1
            
            cell.imageView!.image = UIImage(named:"WomenSportIcon")
            
            
            
        } else {                                        // Rows decomposition level = 2
            
            
            
            // Row name is a sport name
            
            cell.indentationLevel = 2
            
            
            
            // Image name is the same as the sport name
            
            cell.imageView!.image = UIImage(named: rowName)
            
        }
        
        
        
        return cell
        
    }
    
    //---------------------------------------------------------------
    
    // Prepare the Table View Cell before it is displayed to the user
    
    //---------------------------------------------------------------
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        // Set the number of lines to be displayed in each table view cell to 2
        
        cell.textLabel!.numberOfLines = 2
        
        
        
        // Set the text to wrap around on the next line
        
        cell.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        
        // Set the cell label text to use the System font of size 14 pts
        
        cell.textLabel!.font = UIFont(name: "System", size: 14.0)
        
        
        
        if sportNameSelected && (selectedRowNumber == (indexPath as NSIndexPath).row) {
            
            
            
            // Set the cell label text color to blue to indicate its selection
            
            cell.textLabel!.textColor = UIColor.blue
            
            
            
        } else {
            
            // Set the cell label text color to black otherwise
            
            cell.textLabel!.textColor = UIColor.black
            
        }
        
        
        
        switch cell.indentationLevel {
            
        case 0:
            
            // Set level 1 (University Name) row background color to Lavendar (#E6E6FA)
            
            cell.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            
            
            
        case 1:
            
            // Set level 2 (Sport Category Name) row background color to Ivory (#FFFFF0)
            
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            
            
            
        case 2:
            
            // Set level 3 (Sport Name) row background color to PeachPuff (#FFDAB9)
            
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 218.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            
            
            
        default:
            
            print("Cell indentation level is out of range!")
            
            break
            
        }
        
        
        
        // If the cell label is a sport name
        
        if sportNames.contains((cell.textLabel!.text!)) {
            
            
            
            // Then, show the Right Arrow image as Disclosure Indicator
            
            cell.accessoryView = UIImageView(image: UIImage(named: "RightArrow"))
            
            
            
        } else {
            
            
            
            // Otherwise, show the Down Arrow image to indicate that the row has child rows
            
            cell.accessoryView = UIImageView(image: UIImage(named: "DownArrow"))
            
        }
        
    }
    
    
    
    /*
     
     --------------------------------------------
     
     MARK: - UITableViewDelegate Protocol Methods
     
     --------------------------------------------
     
     */
    
    
    
    // Set the height of the table view row to 50 pts
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return 50
        
    }
    
    
    
    //----------------------------------------------------------------------------
    
    // Perform the necessary actions when the user selects a table view row (cell)
    
    //----------------------------------------------------------------------------
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        // Obtain the number of the selected row
        
        var rowNumber: Int = (indexPath as NSIndexPath).row
        
        
        
        // Set the class properties
        
        selectedIndexPath = indexPath
        
        selectedRowNumber = rowNumber
        
        
        
        // Check whether the table view is from the search display controller
        
        var selectedArray = searchResultsController.isActive ? searchResults : tableViewList
        
        
        
        // Obtain the name of the selected row
        
        let nameOfSelectedRow: String = selectedArray[rowNumber]
        
        
        
        // Identify the table view cell object for the selected row
        
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        
        
        // Obtain the indentation level of the selected row
        
        let indentationLevelOfSelectedCell: Int = selectedCell.indentationLevel
        
        
        
        switch indentationLevelOfSelectedCell {
            
            
            
            //-------------------------------------------------------------------------
            
            // University Name is Selected: Expand the row to show its Sport Categories
            
            //-------------------------------------------------------------------------
            
            
            
        case 0:
            
            
            
            sportNameSelected = false
            
            
            
            // If the selected university name is the last row or
            
            // If the row below the selected university name is also a university name, implying that it is not expanded
            
            if rowNumber == (selectedArray.count) - 1 || universityNames.contains(selectedArray[rowNumber+1]) {
                
                
                
                // Expand the selected university name row
                
                
                
                let dictionary2: AnyObject? = dict1_UniversityName_Dict2[nameOfSelectedRow]
                
                
                
                dict2_SportCategory_Dict3 = dictionary2! as! Dictionary
                
                
                
                // Obtain an unordered list of sport categories
                
                var sportCategories: Array = dictionary2!.allKeys as! [String]
                
                
                
                // Sort the sport categories within itself in alphabetical order
                
                sportCategories.sort { $0 < $1 }
                
                
                
                let numberOfSportCategories = sportCategories.count
                
                
                
                // The half-open range operator 0..<numberOfSportCategories defines a range that runs from 0 to numberOfSportCategories - 1.
                
                for i in 0..<numberOfSportCategories {
                    
                    
                    
                    // Insert the sport category names of the selected university.
                    
                    // Make sure the categories are being inserted into the correct array.
                    
                    if self.searchResultsController.isActive {
                        
                        rowNumber = rowNumber + 1
                        
                        searchResults.insert(sportCategories[i], at: rowNumber)
                        
                    } else {
                        
                        rowNumber = rowNumber + 1
                        
                        tableViewList.insert(sportCategories[i], at: rowNumber)
                        
                    }
                    
                }
                
                
                
            } else {    // Shrink the row: Hide the sport categories under the selected university name
                
                
                
                // As long as the next row is not a university name, delete the row from the table view list
                
                // add a cloure to return the right list
                
                while !self.universityNames.contains({return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber + 1] : self.tableViewList[rowNumber + 1])}()) {
                    
                    
                    
                    if self.searchResultsController.isActive {
                        
                        searchResults.remove(at: rowNumber + 1)
                        
                    } else {
                        
                        tableViewList.remove(at: rowNumber + 1)
                        
                    }
                    
                    
                    
                    // If the end of the table view list is reached, then break
                    
                    // add clousure to make sure you return the count of the right array
                    
                    if rowNumber + 1 > {return ((self.searchResultsController.isActive) ? self.searchResults.count : self.tableViewList.count)}() - 1 {
                        
                        break
                        
                    }
                    
                }
                
            }
            
            
            
            // Reload the table view's rows since the table view list is changed
            
            tableView.reloadData()
            
            
            
            //------------------------------------------------------------------------
            
            // Sport Category Name is Selected: Expand the row to show its Sport Names
            
            // -----------------------------------------------------------------------
            
            
            
        case 1:
            
            
            
            self.sportNameSelected = false
            
            
            
            // Special Case: Selected sport category name is the last row of the table view content
            
            if rowNumber == selectedArray.count - 1 {
                
                
                
                for j in (0..<rowNumber).reversed() {
                    
                    
                    
                    let previousRowName = (self.searchResultsController.isActive) ? self.searchResults[j] : self.tableViewList[j]
                    
                    
                    
                    if self.universityNames.contains(previousRowName) {
                        
                        
                        
                        let universityNameOfSelectedRow = previousRowName
                        
                        
                        
                        //---------- Dictionary 2 -------------
                        
                        
                        
                        let dictionary2: AnyObject? = self.dict1_UniversityName_Dict2[universityNameOfSelectedRow]
                        
                        
                        
                        self.dict2_SportCategory_Dict3 = dictionary2! as! Dictionary
                        
                        
                        
                        //---------- Dictionary 3 -------------
                        
                        
                        
                        let dictionary3: AnyObject? = self.dict2_SportCategory_Dict3[nameOfSelectedRow]
                        
                        
                        
                        self.dict3_SportName_SportURL = dictionary3! as! Dictionary
                        
                        
                        
                        // Obtain an unordered list of sport names of selected category
                        
                        var sportNamesOfSelectedCategory: Array = dictionary3!.allKeys as! [String]
                        
                        
                        
                        // Sort the sport names of selected category within itself in alphabetical order
                        
                        sportNamesOfSelectedCategory.sort { $0 < $1 }
                        
                        
                        
                        let numberOfSportNames = sportNamesOfSelectedCategory.count
                        
                        
                        
                        for k in 0..<numberOfSportNames {
                            
                            
                            
                            if self.searchResultsController.isActive {
                                
                                rowNumber = rowNumber + 1
                                
                                searchResults.insert(sportNamesOfSelectedCategory[k], at: rowNumber)
                                
                            } else {
                                
                                rowNumber = rowNumber + 1
                                
                                tableViewList.insert(sportNamesOfSelectedCategory[k], at: rowNumber)
                                
                            }
                            
                        }
                        
                        
                        
                        tableView.reloadData()
                        
                        break
                        
                    }
                    
                }
                
                /*
                 
                 Note the Closure Expression: {return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber+1] : self.tableViewList[rowNumber+1])}()
                 
                 Use of "self." is required in a Closure.
                 
                 */
                
            } else if self.sportNames.contains({return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber+1] : self.tableViewList[rowNumber+1])}()) {
                
                
                
                // If the row after the selected Sport Category Name is a sport name, that means
                
                // it is already expanded; therefore, shrink the selected sport category row
                
                
                
                if nameOfSelectedRow == "Men's Sports" {
                    
                    
                    
                    // As long as the next row is not "Women's Sports", delete that row from the table view
                    
                    while !({return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber+1] : self.tableViewList[rowNumber+1])}() == "Women's Sports") {
                        
                        
                        
                        if self.searchResultsController.isActive {
                            
                            searchResults.remove(at: rowNumber + 1)
                            
                        } else {
                            
                            tableViewList.remove(at: rowNumber + 1)
                            
                        }
                        
                        
                        
                        // If the end of the table view list is reached, then break
                        
                        if rowNumber+1 > {return ((self.searchResultsController.isActive) ? self.searchResults.count : self.tableViewList.count)}() - 1 {
                            
                            break
                            
                        }
                        
                    }
                    
                    
                    
                } else {
                    
                    
                    
                    // As long as the next row is not a university name, delete that row from the table view
                    
                    while !self.universityNames.contains({return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber+1] : self.tableViewList[rowNumber+1])}()) {
                        
                        
                        
                        if self.searchResultsController.isActive {
                            
                            searchResults.remove(at: rowNumber + 1)
                            
                        } else {
                            
                            tableViewList.remove(at: rowNumber + 1)
                            
                        }
                        
                        
                        
                        // If the end of the table view list is reached, then break
                        
                        if rowNumber+1 > {return ((self.searchResultsController.isActive) ? self.searchResults.count : self.tableViewList.count)}() - 1 {
                            
                            break
                            
                        }
                        
                    }
                    
                }
                
                
                
                tableView.reloadData()
                
                
                
            } else {   // Expand the selected sport category row
                
                
                
                // This loop goes from j=(rowNumber - 1) to j=0 with increments of 1
                
                for j in (0..<rowNumber).reversed() {
                    
                    
                    
                    let previousRowName = (self.searchResultsController.isActive) ? self.searchResults[j] : self.tableViewList[j]
                    
                    
                    
                    if self.universityNames.contains(previousRowName) {
                        
                        
                        
                        let universityNameOfSelectedRow = previousRowName
                        
                        
                        
                        //---------- Dictionary 2 -------------
                        
                        
                        
                        let dictionary2: AnyObject? = self.dict1_UniversityName_Dict2[universityNameOfSelectedRow]
                        
                        
                        
                        self.dict2_SportCategory_Dict3 = dictionary2! as! Dictionary
                        
                        
                        
                        //---------- Dictionary 3 -------------
                        
                        
                        
                        let dictionary3: AnyObject? = self.dict2_SportCategory_Dict3[nameOfSelectedRow]
                        
                        
                        
                        self.dict3_SportName_SportURL = dictionary3! as! Dictionary
                        
                        
                        
                        // Obtain an unordered list of sport names of selected category
                        
                        var sportNamesOfSelectedCategory: Array = dictionary3!.allKeys as! [String]
                        
                        
                        
                        // Sort the sport names of selected category within itself in alphabetical order
                        
                        sportNamesOfSelectedCategory.sort { $0 < $1 }
                        
                        
                        
                        let numberOfSportNames = sportNamesOfSelectedCategory.count
                        
                        
                        
                        for k in 0..<numberOfSportNames {
                            
                            
                            
                            if self.searchResultsController.isActive {
                                
                                rowNumber = rowNumber + 1
                                
                                searchResults.insert(sportNamesOfSelectedCategory[k], at: rowNumber)
                                
                            } else {
                                
                                rowNumber = rowNumber + 1
                                
                                tableViewList.insert(sportNamesOfSelectedCategory[k], at: rowNumber)
                                
                            }
                            
                        }
                        
                        
                        
                        tableView.reloadData()
                        
                        break
                        
                    }
                    
                }
                
            }
            
            
            
            //-----------------------------------------------------------------
            
            // Sport Name is Selected: Show the sport's website in another view
            
            //-----------------------------------------------------------------
            
            
            
        case 2:
            
            
            
            sportNameSelected = true
            
            
            
            selectedIndexPathPrevious = selectedIndexPath
            
            selectedIndexPath = indexPath
            
            
            
            var sportCategoryNameOfSelectedRowIdentified = false
            
            
            
            var sportCategoryNameOfSelectedRow: String = ""
            
            
            
            // This loop goes from j=(rowNumber - 1) to j=0 with increments of 1
            
            for n in (0..<rowNumber).reversed() {
                
                
                
                let previousRowName = searchResultsController.isActive ? self.searchResults[n] : self.tableViewList[n]
                
                
                
                if previousRowName == "Men's Sports" || previousRowName == "Women's Sports" {
                    
                    
                    
                    if !sportCategoryNameOfSelectedRowIdentified {
                        
                        sportCategoryNameOfSelectedRow = previousRowName
                        
                        sportCategoryNameOfSelectedRowIdentified = true
                        
                    }
                    
                    
                    
                } else if universityNames.contains(previousRowName) {
                    
                    
                    
                    let universityNameOfSelectedRow = previousRowName
                    
                    
                    
                    //---------- Dictionary 2 -------------
                    
                    
                    
                    let dictionary2: AnyObject? = dict1_UniversityName_Dict2[universityNameOfSelectedRow]
                    
                    
                    
                    dict2_SportCategory_Dict3 = dictionary2! as! Dictionary
                    
                    
                    
                    //---------- Dictionary 3 -------------
                    
                    
                    
                    let dictionary3: AnyObject? = dict2_SportCategory_Dict3[sportCategoryNameOfSelectedRow]
                    
                    
                    
                    dict3_SportName_SportURL = dictionary3! as! Dictionary
                    
                    
                    
                    let websiteURL: AnyObject? = dict3_SportName_SportURL[nameOfSelectedRow]
                    
                    
                    
                    urlOfWebsite = websiteURL! as! String
                    
                    
                    
                    // Perform the segue named Website
                    
                    performSegue(withIdentifier: "Website", sender:self)
                    
                    
                    
                    break
                    
                }
                
            }
            
            
            
        default:
            
            print("Table View Cell Indentation Level is Out of Range!")
            
            break
            
            
            
        }

    }
    
    /*
     
     -------------------------
     
     MARK: - Prepare For Segue
     
     -------------------------
     
     */
    
    
    
    // This method is called by the system whenever you invoke the method performSegue(withIdentifier:sender:)
    
    // You never call this method. It is invoked by the system.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        
        
        if segue.identifier == "Website" {
            
            
            
            // Obtain the object reference of the destination view controller
            
            let websiteViewController: WebsiteViewController = segue.destination as! WebsiteViewController
            
            
            
            // Pass the data object to the destination view controller object
            
            websiteViewController.websiteURL = urlOfWebsite
            
            
            
        }
        
    }
    
    
    
}


