//
//  AAKPreviewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKPreviewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface AAKPreviewController () {
}

@end

@implementation AAKPreviewController

#pragma mark - IBAction

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAsImage:(id)sender {
	DNSLogMethod
	
	UIImage *image = [self.textView imageForPasteBoard];
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil
						  completionBlock:^(NSURL *assetURL, NSError *error){
							  if (error) {
								  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
																					  message:[error localizedDescription]
																					 delegate:nil
																			cancelButtonTitle:nil
																			otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
								  [alertView show];
							  }
							  else {
								  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AAKeyboard", nil)
																					  message:[NSString stringWithFormat:NSLocalizedString(@"Image has been saved.", nil)]
																					 delegate:nil
																			cancelButtonTitle:nil
																			otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
								  [alertView show];
							  }
						  }];
}

#pragma mark - Instance method

/**
 * テキストビューに再度AAを突っ込みコンテンツを最新のものに更新する．
 **/
- (void)updateTextView {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.text attributes:attributes];
	_textView.attributedString = string;
}

/**
 * データが更新された通知を受け取って実行する．
 * @param notification 通知オブジェクト．
 **/
- (void)keyboardDataManagerDidUpdateNotification:(NSNotification*)notification {
	[self updateTextView];
}

#pragma mark - Override

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_textView.userInteractionEnabled = NO;
	[self updateTextView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDataManagerDidUpdateNotification:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"OpenAAKEditNavigationController"]) {
		UINavigationController *nav = (UINavigationController*)segue.destinationViewController;
		AAKEditViewController *vc = (AAKEditViewController*)nav.topViewController;
		vc.asciiart = self.asciiart;
	}
}

@end
