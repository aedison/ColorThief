//
//  CTPaletteTVC.m
//  ColorThief
//
//  Created by Alex Edison on 4/19/13.
//  Copyright (c) 2013 Alex Edison. All rights reserved.
//

#import "CTPaletteTVC.h"
#import "Palettes.h"
#import "Colors.h"
#import "Colors+Saved.h"
#import "Palettes.h"
#import "Palettes+Saved.h"
#import "CTAppDelegate.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Saved Palettes";
    NSError *error = nil;
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Palette" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paletteName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Retrieval from DB failed with error:%@",error.description);
    }
    self.palettes=mutableFetchResults;
    
    if ([self.palettes count]==0){
        //For testing purposes
        Palettes* newPalette= [Palettes newPaletteInContext:self.managedObjectContext withName:@"testPal1" andFileName:[NSURL URLWithString:@"Test1"]];
        [newPalette addPaletteColorsObject:[Colors newColorFromUIColor:[UIColor colorWithRed:.5 green:1 blue:.75 alpha:.35] inContext:self.managedObjectContext]];
        
        Palettes* otherNewPalette= [Palettes newPaletteInContext:self.managedObjectContext withName:@"testPal2" andFileName:[NSURL URLWithString:@"Test2"]];
        [otherNewPalette addPaletteColorsObject:[Colors newColorFromUIColor:[UIColor redColor] inContext:self.managedObjectContext]];
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error during color save: %@",error.description);
        }

        [self.palettes insertObject:newPalette atIndex:0];
        [self.palettes insertObject:otherNewPalette atIndex:0];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.palettes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Palettes* palette=self.palettes[section];
    return [palette.paletteColors count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.palettes[section] paletteName];
}


- (NSString *)titleForPath:(NSIndexPath *)indexPath
{
    Colors* colorForCell=[self.palettes[indexPath.section] paletteColorsSortedByKey:@"red"][indexPath.row];
    NSString* colorDescription=[NSString stringWithFormat:@"%g, %g, %g",colorForCell.red.floatValue,colorForCell.green.floatValue,colorForCell.blue.floatValue];
    return colorDescription;
}


- (UIImage *)imageForPath:(NSIndexPath *)indexPath{
    Colors* colorForCell=[self.palettes[indexPath.section] paletteColorsSortedByKey:@"red"][indexPath.row];
    return [colorForCell imageFromSelf];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"paletteCell";
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
        Colors *colorToDelete = [self.palettes[indexPath.section] paletteColorsSortedByKey:@"red"][indexPath.row];
        [self.managedObjectContext deleteObject:colorToDelete];
        
        // Update the array
        [self.palettes[indexPath.section]  removePaletteColorsObject:colorToDelete];
        
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        // If we emptied the palette, delete it too
        if([[self.palettes[indexPath.section] paletteColors] count]==0){
            Palettes* paletteToDelete = self.palettes[indexPath.section];
            [self.managedObjectContext deleteObject:paletteToDelete];
            [self.palettes removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
        }
        
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
