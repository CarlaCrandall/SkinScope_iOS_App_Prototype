//
//  ProductSearchVC.m
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "ProductSearchVC.h"
#import "SkinScopeAppDelegate.h"
#import "ProductVC.h"
#import "Product.h"

#define PRODUCTS 0
#define RELEVANCE 0

@interface ProductSearchVC ()

@end

@implementation ProductSearchVC

@synthesize searchBar, queryResult, savedSearchTerm, ingredientInfo, products;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        ranQuery = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set back button text for detail view controllers
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    // Create a search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
    searchBar.placeholder = @"Search For a Product";
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeAlphabet;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    
    
    // add button to nav bar
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStyleBordered target:self action:@selector(addScanner)];
    self.navigationItem.rightBarButtonItem = scanButton;    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //only display section if we've actually searched for something
    //this prevents "No Results" from showing up all the time
    if(ranQuery){
        //if no products to display, return 1
        //section will be used to display a "no results" message
        if([products count] == 0){
            return 1;
        }
        //if there are products to display, return 2
        //section 1 will be used to display products
        //section 2 will be used to display either a "Load More" button or an "End of Results" message (depending on circumstances)
        else{
            return  2;
        }
    }
    else{
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        
    if(section == PRODUCTS){
        //if there are no results, only display one row
        //row will be used to show a "No Results" message
        if([products count] == 0){
            return 1;
        }
        //if there are results, num rows = num results
        else{
            return [products count];
        }
    }
    //if displaying load more section, number of rows = 1
    else{
        return 1;
    }
}


//create table cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProductIdentifier = @"ProductCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCell";
    static NSString *noResultsIdentifier = @"NoResults";
    
    //if the query returned results...
    if([products count] != 0){
        
        //cell settings for product results
        if(indexPath.section == PRODUCTS)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductIdentifier];
            
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ProductIdentifier];
            
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            }
            
            //get product - textLabel = product name, image = rating, detailText = product brand
            Product *product = [products objectAtIndex:indexPath.row];
            
            //set table cell image based on product rating
            if([[product rating] isEqualToString:@"Good"]){
                cell.imageView.image = [UIImage imageNamed:@"good.png"];
            }
            else if([[product rating] isEqualToString:@"Average"]){
                cell.imageView.image = [UIImage imageNamed:@"average.png"];
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"poor.png"];
            }
            
            cell.textLabel.text = [product name];
            cell.detailTextLabel.text = [product brand];
            
            return cell;
        }
        //cell settings for "Load More" button
        else{
            
            UITableViewCell *loadMore = [tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
            
            if(loadMore == nil){
                loadMore = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreIdentifier];
                loadMore.textLabel.font = [UIFont boldSystemFontOfSize:18];
            }
            
            
            // Notes about Factual API Limits for free accounts...
            // Maximum number of products that can be returned in a single request is 20
            // Row limit (the maximum depth a request can page into using offset + limit) is 100
            // So we check to make sure we're not trying to request > 100 products, by checking the offset value
            
            if([products count] < self.queryResult.totalRows && pageOffset < 80){
                loadMore.textLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(115/255.0) blue:(60/255.0) alpha:1.0];
                loadMore.textLabel.text = @"Load More Results";
            }
    
            // If we're not allowed to load any more results (or we've reached the end of the results), display "End of Results"
            else{
                loadMore.textLabel.textColor = [UIColor colorWithRed:(192/255.0) green:(57/255.0) blue:(43/255.0) alpha:1.0];
                loadMore.textLabel.text = @"End of Results";
            }
            
            return loadMore;
        }
    }
    //if there were no results, display a "No Results" message
    else{
        
        UITableViewCell *noResults = [tableView dequeueReusableCellWithIdentifier:noResultsIdentifier];
        
        if(noResults == nil){
            noResults = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noResultsIdentifier];
            noResults.textLabel.font = [UIFont boldSystemFontOfSize:18];
            noResults.textLabel.textColor = [UIColor colorWithRed:(192/255.0) green:(57/255.0) blue:(43/255.0) alpha:1.0];
        }
        
        noResults.textLabel.text = @"No Results";
        
        return noResults;
    }
    
    return nil;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Don't let user select "End of Results" cell
    if (indexPath.section == 1 && pageOffset >= 80)
    {
        return nil;
    }
    
    return indexPath;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (products != nil) {
        
        if(indexPath.section == 0){
            // get product
            Product *product = [products objectAtIndex:indexPath.row];
            
            // create detail view controller
            ProductVC *productVC = [[ProductVC alloc] initWithNibName:nil bundle:nil];
            productVC.product = product;
            
            // push view controller
            [self.navigationController pushViewController:productVC animated:YES];
        }
        else{
            
            // Notes about Factual API Limits for free accounts...
            // Maximum number of products that can be returned in a single request is 20
            // Row limit (the maximum depth a request can page into using offset + limit) is 100
            // So we check to make sure we're not trying to request > 100 products, by checking the offset value
            
            if(pageOffset < 80){
                
                //increase page offset
                pageOffset += 20;
                
                [self doQuery:nil];
            }
            
        }
        
    }
}




#pragma mark - Factual API Methods
// Used the factual sdk iOS demo for reference: https://github.com/Factual/factual-ios-sdk-demo


-(void)requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResultObj {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (activeRequest == request) {
        
        self.queryResult = queryResultObj;
                
        // results received, create products
        for(int i=0; i < queryResult.rowCount; i++){
            
            // get data from query result
            FactualRow *row = [self.queryResult.rows objectAtIndex:i];
            
            // use data to create a product
            Product *product = [[Product alloc] initWithName:[row valueForName:@"product_name"] brand:[row valueForName:@"brand"] ingredients:[row valueForName:@"ingredients"] ingredientInfo:self.ingredientInfo relevance:[products count]];
            
            // add product to array
            [products addObject:product];
        }
        
        //Create the segmented control to sort results
        NSArray *itemArray = [NSArray arrayWithObjects: @"Relevance", @"Rating", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedControl setWidth:100.0 forSegmentAtIndex:0];
        [segmentedControl setWidth:100.0 forSegmentAtIndex:1];
        [segmentedControl addTarget:self action:@selector(sortProducts:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segmentedControl;

        
        // reload table view ..
        [self.tableView reloadData];
    }
}

//search for product
- (void)doQuery:(id)sender{
    
    //set ranQuery bool to yes - checked in numberOfSectionsInTable
    ranQuery = YES;
    
    //turn on activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //create query object
    FactualQuery* queryObject = [FactualQuery query];
    
    // needed to get the total amount of results
    queryObject.includeRowCount = YES;
    
    // return 20 results per page
    queryObject.limit = 20;
    queryObject.offset = pageOffset;
    
    
    // sort by relevance if full text available ...
    if (self.savedSearchTerm != nil && self.savedSearchTerm.length != 0) {
        FactualSortCriteria *primarySort = [[FactualSortCriteria alloc] initWithFieldName:@"$relevance" sortOrder:FactualSortOrder_Ascending];
        [queryObject setPrimarySortCriteria:primarySort];
    }
    
    
    // full text term
    if (self.savedSearchTerm != nil && self.savedSearchTerm.length != 0) {
        [queryObject addFullTextQueryTerms:self.savedSearchTerm, nil];
    }
    
    
    // set relevant categories
    [queryObject addRowFilter:[FactualRowFilter fieldName:@"category" includesAnyArray:[NSArray arrayWithObjects:
                                  @"Skin Care",
                                  @"Therapeutic Skin Care",
                                  @"Face Moisturizers",
                                  @"Face Cleansers & Scrubs",
                                  @"Face Treatments",
                                  @"Face Toners & Astringents",
                                  @"Bath Products",
                                  @"Body Soaps & Gels",
                                  @"Body Lotions, Oils, Creams, Sprays",
                                  @"Body Scrubs & Muds",
                                  @"Massage Lotions, Oils, Creams",
                                  @"Deodorants & Antiperspirants",
                                  @"Shaving Products",
                                  @"Hand Creams & Lotions",
                                  @"Hand Soaps",
                                  @"Foot Care",
                                  @"Lip Care",
                                  @"Personal Care",
                                  @"Baby Skin Care",
                                  nil]]];
                                                                                
        
    // start the request ...
    activeRequest = [[SkinScopeAppDelegate getAPIObject] queryTable:@"products-cpg-nutrition" optionalQueryParams:queryObject withDelegate:self];
    
}


-(void) requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (activeRequest == request) {
        activeRequest = nil;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Factual API Error"message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        NSLog(@"Active request failed with Error:%@", [error localizedDescription]);
    }
}




#pragma mark - UISearchBarDelegate Methods

//do query when search button is clicked
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //hide the keyboard
    [self.searchBar resignFirstResponder];
    
    
    //hide the cancel button
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    
    //get search term from the search bar
    savedSearchTerm = self.searchBar.text;
    
    
    //prevent overly generic search terms, by checking length
    if([savedSearchTerm length] > 3){
        
        //init the array that will hold our results
        products = [NSMutableArray array];
        
        //set initial page offset
        pageOffset = 0;
        
        //query the factual api to get products
        [self doQuery:nil];
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"" message:@"Search term must be at least 4 characters" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [message show];
    }
    
}


//show cancel button when user begins typing search term
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}


//dismiss keyboard when user clicks cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark - Sorting Method

- (void) sortProducts:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
        
    // if sorting by relevance
    if([segmentedControl selectedSegmentIndex] == RELEVANCE){
        NSSortDescriptor *ascSorter = [[NSSortDescriptor alloc] initWithKey:@"relevance" ascending:YES];
        [products sortUsingDescriptors:[NSArray arrayWithObject:ascSorter]];
    }
    // if sorting by product rating
    else{
        
        // temp arrays
        NSMutableArray *goodProducts = [NSMutableArray array];
        NSMutableArray *avgProducts = [NSMutableArray array];
        NSMutableArray *poorProducts = [NSMutableArray array];
        NSMutableArray *toDelete = [NSMutableArray array];
        
        //loop through all products...
        for(id product in products){
            
            // store products with a "good" rating in the goodProducts array
            if([[product rating] isEqualToString:@"Good"]){
                [goodProducts addObject:product];
                [toDelete addObject:product];
            }
            // store products with an "average" rating in the avgProducts array
            else if([[product rating] isEqualToString:@"Average"]){
                [avgProducts addObject:product];
                [toDelete addObject:product];
            }
            // store products with a "poor" rating in the poorProducts array
            else{
                [poorProducts addObject:product];
                [toDelete addObject:product];
            }
        }
        
        // remove all products from the array
        [products removeObjectsInArray:toDelete];
        
        // add products back into array in new order (sorted by rating)
        [products addObjectsFromArray:goodProducts];
        [products addObjectsFromArray:avgProducts];
        [products addObjectsFromArray:poorProducts];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Add Scanner

//create scan modal view
//uses ZBar iPhone SDK: http://zbar.sourceforge.net/iphone/sdkdoc/index.html

-(IBAction)addScanner{
    //create ZBar reader
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [reader.scanner setSymbology: ZBAR_UPCE config: ZBAR_CFG_ENABLE to: 0];
    reader.readerView.zoom = 1.0;
    
    //display barcode scanner in modal view controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
      break;
    
    if(symbol){
        //set search term to UPC code
        savedSearchTerm = symbol.data;
        
        //init the array that will hold our results
        products = [NSMutableArray array];
        
        //set initial page offset
        pageOffset = 0;
        
        [self doQuery:nil];
        
        //dismiss the modal view controller
        [reader dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
