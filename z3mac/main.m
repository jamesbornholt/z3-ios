//
//  main.m
//  z3mac
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "Z3Harness.h"

void loadZ3() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* path = [[NSBundle mainBundle] pathForResource:@"libz3" ofType:@"dylib"];
        loadZ3Dylib([path cStringUsingEncoding:NSASCIIStringEncoding]);
    });
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        loadZ3();
        
        NSError *err;
        NSString *smtPath = [[NSBundle mainBundle] pathForResource:@"sat" ofType:@"smt2"];
        NSString *smt = [NSString stringWithContentsOfFile:smtPath encoding:NSASCIIStringEncoding error:&err];
        if (smt == nil) {
            NSLog(@"failed to load smt: %@", err);
            return 0;
        }
        
        NSDate *start = [NSDate date];
        const char* ret = runZ3String([smt cStringUsingEncoding:NSASCIIStringEncoding]);
        double time = [start timeIntervalSinceNow] * -1;
        NSLog(@"Z3 returned [%fs] \"%s\"", time, ret);
        
    }
    return 0;
}
