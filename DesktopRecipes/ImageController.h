
@interface ImageController : NSObject {

	NSImageView *imageView;
	NSArrayController *arrayController;
}

@property (assign) IBOutlet NSImageView *imageView;
@property (assign) IBOutlet NSArrayController *arrayController;

- (IBAction)imageChanged:sender;

@end
