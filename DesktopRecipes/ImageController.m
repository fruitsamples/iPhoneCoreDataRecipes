

#import "ImageController.h"
#import "Recipe.h"


@implementation ImageController


@synthesize imageView, arrayController;


static NSString *SelectedObjectsContext;

- (void)awakeFromNib {
	[arrayController addObserver:self forKeyPath:@"selectedObjects" options:0 context:&SelectedObjectsContext];
	[imageView setEditable:NO];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
/*
 Only observing one thing, so short-cut any tests.
 */
	NSArray *selectedObjects = [arrayController selectedObjects];
	NSUInteger count = [selectedObjects count];
	
	if (count != 1) {
		[imageView setImage:nil];
		[imageView setEditable:NO];
		return;
	}
		
	NSImage *image = [[selectedObjects objectAtIndex:0] valueForKeyPath:@"image.image"];
	[imageView setImage:image];
	[imageView setEditable:YES];
}


- (IBAction)imageChanged:sender {
	NSLog(@"- (IBAction)imageChanged:sender");
	
	Recipe *recipe = [[arrayController selectedObjects] objectAtIndex:0];
	NSManagedObject *image = recipe.image;
	if (image == nil) {
		NSManagedObjectContext *context = [arrayController managedObjectContext];
		image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:context];
		recipe.image = image;
	}
	[image setValue:[imageView image] forKey:@"image"];
}


@end
