//
// Cleaner.m
// Copyright 2014 Chance Hudson
//

#import "Cleaner.h"

const int trkptLineCount = 10;

void removePauses(NSMutableArray *lineArr){
    double *latStack = calloc(5, sizeof(double));
    double *lonStack = calloc(5, sizeof(double));
    int currentLine = 0;
    while(getNextOccurenceOfString(@"trkpt ", currentLine, lineArr, NO) != -1){
        currentLine = getNextOccurenceOfString(@"trkpt ", currentLine, lineArr, NO);
        NSString *line = [lineArr objectAtIndex:currentLine];
        NSRange r1 = [line rangeOfString:@"lat=\""];
        NSRange r2 = [line rangeOfString:@"lon=\""];
        NSString *latString = [line substringWithRange:(NSRange){r1.location+r1.length, 10}];
        NSString *lonString = [line substringWithRange:(NSRange){r2.location+r2.length, 11}];
        double lat = latString.doubleValue;
        double lon = lonString.doubleValue;
        latStack = pushStackItem(latStack, 5, lat);
        lonStack = pushStackItem(lonStack, 5, lon);
        
        if(stackIsConstant(latStack, 5) && stackIsConstant(lonStack, 5)){
            [lineArr removeObjectsInRange:(NSRange){currentLine-(4*trkptLineCount), 5*trkptLineCount}];
            currentLine -= 40;
            while([[lineArr objectAtIndex:currentLine] isEqualToString:line]){
                [lineArr removeObjectsInRange:(NSRange){currentLine, trkptLineCount}];
            }
            continue;
        }
    }
}

void normalizeCadence(NSMutableArray *lineArr) {
    const int maxCad = 130;
    int prev = 0;
    int currentLine = 0;
    while (getNextOccurenceOfString(@"cad>", currentLine, lineArr, NO) != -1) {
        currentLine = getNextOccurenceOfString(@"cad>", currentLine, lineArr, NO);
        int next = 1000;
        int c = currentLine;
        while(next > maxCad){
            c = getNextOccurenceOfString(@"cad>", c, lineArr, NO);
            if(c == -1){
                next = prev;
                break;
            }
            NSString *line2 = [lineArr objectAtIndex:c];
            NSRange r3 = [line2 rangeOfString:@"cad>"];
            NSRange r4 = [line2 rangeOfString:@"</"];
            next = [line2 substringWithRange:(NSRange){r3.location+r3.length, r4.location-(r3.location+r3.length)}].intValue;
        }
        if(prev > maxCad)
            prev = next;
        else if(next > maxCad)
            prev = next = 0;
        
        NSString *line = [lineArr objectAtIndex:currentLine];
        NSRange r1 = [line rangeOfString:@"cad>"];
        NSRange r2 = [line rangeOfString:@"</"];
        
        int cad = [line substringWithRange:(NSRange){r1.location+r1.length, r2.location-(r1.location+r1.length)}].intValue;
        if(cad == 123)
            NSLog(@"no");
        int mid = (prev+next)/2;
        if(cad > maxCad){
            line = [line stringByReplacingCharactersInRange:(NSRange){r1.location+r1.length, r2.location-(r1.location+r1.length)} withString:[NSString stringWithFormat:@"%i", mid]];
            [lineArr replaceObjectAtIndex:currentLine withObject:line];
        }
        else if(cad - MIN(MIN(mid, prev), next) > 20 && cad > 110){
            line = [line stringByReplacingCharactersInRange:(NSRange){r1.location+r1.length, r2.location-(r1.location+r1.length)} withString:[NSString stringWithFormat:@"%i", mid]];
            [lineArr replaceObjectAtIndex:currentLine withObject:line];
        }
        prev = cad;
    }
    
}

BOOL writeArrToFile(NSMutableArray *arr, NSString *file){
    NSString *s = [arr componentsJoinedByString:@"\n"];
    NSError *error = nil;
    BOOL r = [s writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:&error];
    if(error)
        NSLog(@"%@", error.localizedDescription);
    return r;
}

int getNextOccurenceOfString(NSString *str, int startIndex, NSMutableArray *lineArr, BOOL backward){
    startIndex++;
    while([[lineArr objectAtIndex:startIndex] rangeOfString:str].location == NSNotFound && startIndex >= 0){
        backward?startIndex--:startIndex++;
        if(startIndex >= [lineArr count])
            return -1;
    }
    return startIndex;
}

BOOL stackIsConstant(double *stack, int count){
    for (int x = 0; x<count-1; x++) {
        if(stack[x] != stack[x+1])
            return NO;
    }
    return YES;
}

double* pushStackItem(double *stack, int stackCount, double item){
    for(int x = stackCount; x > 0; x--){
        stack[x] = stack[x-1];
    }
    stack[0] = item;
    return stack;
}
