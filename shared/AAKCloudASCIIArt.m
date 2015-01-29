//
//  AAKCloudASCIIArt.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudASCIIArt.h"

static NSOperationQueue *sharedOperationQueue;

@implementation AAKCloudASCIIArt

+ (NSOperationQueue*)sharedQueue {
	if (sharedOperationQueue == nil) {
		sharedOperationQueue = [[NSOperationQueue alloc] init];
	}
	return sharedOperationQueue;
}

+ (void)uploadAA:(NSString*)AA title:(NSString*)title {
	CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
	
	double refTime = [NSDate timeIntervalSinceReferenceDate];
	CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:@"AAKCloudASCIIArt"];
	
	[newRecord setObject:AA forKey:@"ASCIIArt"];
	[newRecord setObject:@(refTime) forKey:@"time"];
	[newRecord setObject:@(0) forKey:@"downloads"];
	[newRecord setObject:@(0) forKey:@"reported"];
	[newRecord setObject:title forKey:@"title"];
	
	CKModifyRecordsOperation *operation = [CKModifyRecordsOperation testModifyRecordsOperationWithRecordsToSave:@[newRecord] recordIDsToDelete:@[]];
	operation.database = database;
	[[AAKCloudASCIIArt sharedQueue] addOperation:operation];
}

+ (instancetype)cloudASCIIArtWithRecord:(CKRecord*)record {
	AAKCloudASCIIArt *obj = [[AAKCloudASCIIArt alloc] initWithASCIIArt:[record objectForKey:@"ASCIIArt"]
																 title:[record objectForKey:@"title"]
														   createdTime:[record objectForKey:@"time"]
															 downloads:[record objectForKey:@"downloads"]
															  reported:[record objectForKey:@"reported"]
																  like:[record objectForKey:@"like"]
															  recordID:record.recordID];
	return obj;
}

- (instancetype)initWithASCIIArt:(NSString*)ASCIIArt
						   title:(NSString*)title
					 createdTime:(NSNumber*)createdTime
					   downloads:(NSNumber*)downloads
						reported:(NSNumber*)reported
							like:(NSNumber*)like
						recordID:(CKRecordID*)recordID {
	self = [super init];
	_ASCIIArt = [ASCIIArt copy];
	_title = [title copy];
	_createdTime = createdTime.doubleValue;
	_downloads = downloads.integerValue;
	_reported = reported.integerValue;
	_like = like.integerValue;
	_recordID = recordID;
	[self updateRatio];
	return self;
}

- (void)updateRatio {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.ASCIIArt attributes:attributes];
	CGSize size = [UZTextView sizeForAttributedString:string withBoundWidth:CGFLOAT_MAX margin:UIEdgeInsetsZero];
	_ratio = size.width / size.height;
}

@end
