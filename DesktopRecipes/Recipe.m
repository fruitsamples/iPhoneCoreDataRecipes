
/*
     File: Recipe.m
 Abstract: Model class to represent a recipe.
  It includes a custom value transformer to convert from an NSImage object to NSData.  This is used for the transformable image properties.
 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#import "Recipe.h"

@implementation Recipe

@dynamic name, image, overview, thumbnailImage, instructions, ingredients, type, prepTime;


+ (void)initialize {
	if ( self == [Recipe class] ) {
		NSImageToDataTransformer *transformer = [[NSImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"NSImageToDataTransformer"];
	}
}

@end



@implementation NSImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	
	/*
	 This is a very simplistic transformation -- it just looks for a bitmap image rep in the incoming NSImage object and extracts JPEG data from it.  There's no error checking etc.
	 */
	NSArray *representations = [value representations];
	NSBitmapImageRep *bitmapImageRep;
	
	for (id representation in representations) {
		if ([representation class] == [NSBitmapImageRep class]) {
			bitmapImageRep = representation;
		}
	}	
	NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.25] forKey:NSImageCompressionFactor];
	NSData *data = [bitmapImageRep representationUsingType:NSJPEGFileType properties:properties];
	
	return data;
}


- (id)reverseTransformedValue:(id)value {
	return [[[NSImage alloc] initWithData:value] autorelease];
}


@end