//
//  ViewController.m
//  z3
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#import "ViewController.h"

#import "z3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadSMT];
}


- (void) loadSMT {
    NSError *err;
    NSString *smtPath = [[NSBundle mainBundle] pathForResource:@"sat" ofType:@"smt2"];
    NSString *smt = [NSString stringWithContentsOfFile:smtPath encoding:NSASCIIStringEncoding error:&err];
    if (smt == nil) {
        NSLog(@"failed to load smt: %@", err);
        return;
    }
    
    [self.smtInputView setText:smt];
}

- (IBAction)loadSMTPressed:(id)sender {
    NSArray<NSString*>* utis = @[@"public.item"];
    UIDocumentPickerViewController* dpvc =
    [[UIDocumentPickerViewController alloc] initWithDocumentTypes:utis inMode:UIDocumentPickerModeOpen];
    dpvc.delegate = self;
    [self presentViewController:dpvc animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if ([urls count] > 0) {
        NSURL* url = [urls objectAtIndex:0];
        if ([url startAccessingSecurityScopedResource]) {
            NSString* smt = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
            if (smt != nil) {
                [self.smtInputView setText:smt];
            }
        }
    }
}

static void z3_noexit_error_handler(Z3_context ctx, Z3_error_code c) {
    fprintf(stderr, "Z3 Error: %s\n", Z3_get_error_msg(ctx, c));
}

- (IBAction)runStuff:(id)sender {
    NSString *smt = [self.smtInputView text];
    dispatch_queue_global_t q = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(q, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.timeLabel setText:@"Running..."];
        });

        Z3_context ctx = Z3_mk_context(NULL);
        Z3_set_error_handler(ctx, &z3_noexit_error_handler);
        
        NSDate *start = [NSDate date];
        Z3_string z3ret = Z3_eval_smtlib2_string(ctx, [smt cStringUsingEncoding:NSASCIIStringEncoding]);
        double time = [start timeIntervalSinceNow] * -1;
        
        // copy output string to buffer before we free the context
        size_t len = strlen(z3ret);
        char *ret = calloc(sizeof(char), len + 1);
        strcpy(ret, z3ret);
        
        Z3_del_context(ctx);

        NSLog(@"Z3 returned [%fs] \"%s\"", time, ret);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timeLabel setText:[NSString stringWithFormat:@"%f s", time]];
            [self.outputView setText:[NSString stringWithUTF8String:ret]];
        });
    });

}

@end
