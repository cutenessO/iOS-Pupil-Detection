//
//  ViewController.h
//  Image
//
//  Created by MacHome on 4/21/17.
//  Copyright © 2017 exam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *ipc;
}

@property (weak, nonatomic) IBOutlet UIImageView *originalImage;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UIButton *gallaryButton;
@property (weak, nonatomic) IBOutlet UITextField *serverUrl;

- (IBAction)chooseImage:(id)sender;
- (IBAction)uploadImage:(id)sender;

@end

