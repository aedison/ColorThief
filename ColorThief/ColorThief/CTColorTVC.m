//
//  CTColorTVC.m
//  ColorThief
//
//  Created by Alex Edison on 4/22/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//


#import "CTColorTVC.h"
#import "Colors+Saved.h"
#import "Palettes+Saved.h"
#import "CTAppDelegate.h"
#import "CTColorEditorController.h"

@interface CTColorTVC ()

@end

@implementation CTColorTVC

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title=self.palette.paletteName;
    self.colors=[NSMutableArray arrayWithArray:[self.palette paletteColorsSortedByKey:@"red"]];
    
    NSError* error;
    
    if ([self.colors count]==0){
        //For testing purposes
        Colors* newColor=[Colors newColorFromUIColor:[UIColor redColor] inContext:self.managedObjectContext];
        Colors* otherNewColor=[Colors newColorFromUIColor:[UIColor blueColor] inContext:self.managedObjectContext];
        
        [self.palette addPaletteColors:[NSSet setWithObjects:newColor, otherNewColor, nil]];
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error during color save: %@",error.description);
        }
        
        [self.colors insertObject:newColor atIndex:0];
        [self.colors insertObject:otherNewColor atIndex:0];
    }
    
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
    if([segue.identifier isEqualToString:@"editColor"]){
        if([segue.destinationViewController isKindOfClass:[CTColorEditorController class]]){
            CTColorEditorController* colorEditor = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            colorEditor.color = self.colors[indexPath.row];
            colorEditor.palette = self.palette;
        }
    }
    else if([segue.identifier isEqualToString:@"newColor"]){
        if([segue.destinationViewController isKindOfClass:[CTColorEditorController class]]){
            CTColorEditorController* colorEditor = segue.destinationViewController;
            colorEditor.palette = self.palette;
            colorEditor.color=[Colors newColorFromUIColor:[UIColor blackColor] inContext:self.managedObjectContext];
        }
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.colors count];
}

- (NSString *)titleForPath:(NSIndexPath *)indexPath
{
    Colors* colorForCell=self.colors[indexPath.row];
    NSString* colorDescription=[NSString stringWithFormat:@"%g, %g, %g",colorForCell.red.floatValue,colorForCell.green.floatValue,colorForCell.blue.floatValue];
    return colorDescription;
}


- (UIImage *)imageForPath:(NSIndexPath *)indexPath{
    Colors* colorForCell=self.colors[indexPath.row];
    return [colorForCell imageFromSelf];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"colorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForPath:indexPath];
    cell.imageView.image= [self imageForPath:indexPath];
    
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
        Colors *colorToDelete = self.colors[indexPath.row];
        [self.managedObjectContext deleteObject:colorToDelete];
        
        // Update the array
        [self.palette  removePaletteColorsObject:colorToDelete];
        [self.colors removeObjectAtIndex:indexPath.row];
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
