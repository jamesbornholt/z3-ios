//
//  ViewController.m
//  z3
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#import "ViewController.h"

#import "Z3Harness.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadZ3];
    [self loadSMT];
}

- (void)loadZ3 {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* path = [[NSBundle mainBundle] pathForResource:@"libz3" ofType:@"dylib"];
        loadZ3Dylib([path cStringUsingEncoding:NSASCIIStringEncoding]);
    });
}

- (void) loadSMT {
    NSError *err;
    NSString *smtPath = [[NSBundle mainBundle] pathForResource:@"sat" ofType:@"smt2"];
    NSString *smt = [NSString stringWithContentsOfFile:smtPath encoding:NSASCIIStringEncoding error:&err];
    if (smt == nil) {
        NSLog(@"failed to load smt: %@", err);
        return;
    }
    
    [self.inputView setText:smt];
}

- (IBAction)runStuff:(id)sender {
    NSString *smt = [self.inputView text];
    dispatch_queue_global_t q = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(q, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.timeLabel setText:@"Running..."];
        });
        
        NSDate *start = [NSDate date];
        const char* ret = runZ3String([smt cStringUsingEncoding:NSASCIIStringEncoding]);
//        const char* ret = runZ3String("(declare-const x Bool)(assert x)(check-sat)");
        double time = [start timeIntervalSinceNow] * -1;
        NSLog(@"Z3 returned [%fs] \"%s\"", time, ret);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timeLabel setText:[NSString stringWithFormat:@"%f s", time]];
            [self.outputView setText:[NSString stringWithUTF8String:ret]];
        });
    });

}

@end
