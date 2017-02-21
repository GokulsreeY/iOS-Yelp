//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    var filteredData: [Business]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    var offset = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.dataSource = self
        //tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self

        self.filteredData = self.businesses

        navigationItem.titleView = searchBar
        
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        //let refreshControl = UIRefreshControl()
        
        //tableView.insertSubview(refreshControl, at: 0)
        loadMoreData()
         //Example of Yelp search with more search options specified
        /*Business.searchWithTerm(term:"Restaurants", sort: YelpSortMode.bestMatched, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
         
         }*/
        
        
        
 
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let businesses = filteredData{
            return businesses.count
        }else{
            return 0
        }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BussinessCell
        cell.business = filteredData[indexPath.row]
        
        
        
       
        return cell
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredData = searchText.isEmpty ? self.businesses : self.businesses.filter({ (bussiness) -> Bool in
            return bussiness.name?.hasPrefix(searchText) ?? true
        })
        self.tableView.reloadData()
        //loadMoreData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            isMoreDataLoading = true
        }
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            isMoreDataLoading = true
            //self.offset += 1
            loadMoreData()
            // ... Code to load more results ...
        }
        // Handle scroll behavior here
    }
    func loadMoreData(){
        self.offset = self.offset + 20
        Business.searchWithTerm(term: "Restaurants",offset: offset, sort: .distance, categories: [], deals: false, completion: { (businesses: [Business]?, error: Error? ) -> Void in
            
            self.filteredData.append(contentsOf: businesses!)
            //self.filteredData = self.businesses
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            
        }
        )
        
        //self.isMoreDataLoading = false

    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
