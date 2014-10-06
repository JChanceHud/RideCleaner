//
//  main.m
//  GPXCleaner
//
//  Created by Chance Hudson on 10/5/14.
//  Copyright (c) 2014 Chance Hudson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cleaner.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
		if(argc != 2)
			return 0;
		NSString *path = [NSString stringWithFormat:@"%s", argv[1]];
		NSError *error = nil;
		NSString *gpxString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
		if(error != nil){
			NSLog(@"%@", error.localizedDescription);
			exit(0);
		}
		NSMutableArray *gpxArr = (NSMutableArray*)[gpxString componentsSeparatedByString:@"\n"];
		removePauses(gpxArr);
		normalizeCadence(gpxArr);
		writeArrToFile(gpxArr, path);
	}
	return 0;
}
