//
// Cleaner.h
// GPXCleaner
//
// Copyright 2014 Chance Hudson
//

#import <Foundation/Foundation.h>

int getNextOccurenceOfString(NSString *str, int startIndex, NSMutableArray *lineArr, BOOL backward);
double* pushStackItem(double *stack, int stackCount, double item);
BOOL stackIsConstant(double *stack, int count);
BOOL writeArrToFile(NSMutableArray *arr, NSString *file);

void removePauses(NSArray *lineArr);
void normalizeCadence(NSMutableArray *lineArr);
