//
//  CTPaletteTVC.m
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison and Kevin Tabb. All rights reserved.
//

#import "CTPaletteTVC.h"
#import "CTColorTVC.h"
#import "Colors+Saved.h"
#import "Palettes+Saved.h"
#import "CTAppDelegate.h"
#import "CTGrabberViewController.h"

@interface CTPaletteTVC ()

@end

@implementation CTPaletteTVC


- (NSManagedObjectContext *) managedObjectContext
{
    if(_managedObjectContext==nil){
        CTAppDelegate* appDelegate=[[UIApplication sharedApplication] delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
    }
    return _managedObjectContext;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void) initializeDataWithTestCase:(BOOL) testing
{
    NSError *error = nil;
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Palette" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paletteName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    if(self.fetchingFromImageFileName != nil){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"fileName = %@",self.fetchingFromImageFileName];
        [request setPredicate:predicate];
    }
    
    
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Retrieval from DB failed with error:%@",error.description);
    }
    self.palettes=mutableFetchResults;
    
    // Testing Code
    if (testing){
        //For testing purposes
        Palettes* newPalette= [Palettes newPaletteInContext:self.managedObjectContext withName:@"testPal1" andFileName:[NSURL URLWithString:@"Test1"]];
        [Colors newColorFromUIColor:[UIColor colorWithRed:.5 green:1 blue:.75 alpha:.35] inContext:self.managedObjectContext inPalette:newPalette];
        
        Palettes* otherNewPalette= [Palettes newPaletteInContext:self.managedObjectContext withName:@"testPal2" andFileName:[NSURL URLWithString:@"Test2"]];
        [Colors newColorFromUIColor:[UIColor redColor] inContext:self.managedObjectContext inPalette:otherNewPalette];
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error during color save: %@",error.description);
        }
        
        [self.palettes insertObject:newPalette atIndex:0];
        [self.palettes insertObject:otherNewPalette atIndex:0];
    }
    //END testing code
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title=@"Palettes";
    
    [self initializeDataWithTestCase:NO];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToColors"]){
        if([segue.destinationViewController isKindOfClass:[CTColorTVC class]]){
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            CTColorTVC* colorTVC= segue.destinationViewController;
            colorTVC.palette=self.palettes[indexPath.row];
        }
    }
    if([segue.identifier isEqualToString:@"paletteListToGrabber"] && [segue.destinationViewController isKindOfClass:[CTGrabberViewController class]]){
        // Pass the info to the color grabber.  I dont know what this needs yet --ACE
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CTGrabberViewController* grabber = segue.destinationViewController;
        grabber.palette = self.palettes[indexPath.row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.palettes count];
}

- (NSString *)titleForPath:(NSIndexPath *)indexPath
{
    Palettes* palette=self.palettes[indexPath.row];
    return palette.paletteName;
}



- (void)getImageForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    Palettes* palette=self.palettes[indexPath.row];
    
    NSURL* assetURL = [NSURL URLWithString:palette.fileName];
    
    __block UIImage *thumbImage;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        CGImageRef thumbRef = [myasset thumbnail];
        if (thumbRef){
            thumbImage = [UIImage imageWithCGImage:thumbRef];
            cell.imageView.image = thumbImage;
        }
    };
    
    //
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Cant get image - %@",myerror);
    };
    
    if(palette.fileName && [palette.fileName length])
    {
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:assetURL
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"paletteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForPath:indexPath];
    
    //Drop in a placeholder image for the cell that can be replaced
    //by our thumbnail later
    CGSize size= CGSizeMake(75., 75.);
    UIColor* color = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //Go get the real image for the cell from the asset library
    [self getImageForCell:cell atIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // Delete the managed object at the given index path.
        Palettes *paletteToDelete=self.palettes[indexPath.row];
        
        [paletteToDelete removePaletteColors:paletteToDelete.paletteColors];
        [self.managedObjectContext deleteObject:paletteToDelete];
        
        // Update the array
        [self.palettes removeObjectAtIndex:indexPath.row];
        
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        // Commit the change.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



@end
