//
//  ViewController.h
//  z3
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIDocumentPickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *smtInputView;
@property (weak, nonatomic) IBOutlet UITextView *outputView;


@end

