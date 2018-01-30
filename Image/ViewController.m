//
//  ViewController.m
//  Image
//
//  Created by MacHome on 4/21/17.
//  Copyright © 2017 exam. All rights reserved.
//

#import "ViewController.h"
static NSString * BaseURLString;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ipc= [[UIImagePickerController alloc] init];
    [ipc setDelegate:self];
    [self addTextField];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTextField{
    
    
    UILabel *prefixLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    prefixLabel.text = @"http://";
    
    [prefixLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [prefixLabel sizeToFit];
    
    // This sets the border style of the text field
    self.serverUrl.borderStyle = UITextBorderStyleRoundedRect;
    self.serverUrl.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [self.serverUrl setFont:[UIFont boldSystemFontOfSize:14]];
    
    //Placeholder text is displayed when no text is typed
    self.serverUrl.placeholder = @"Url for the Server";
    
    //Prefix label is set as left view and the text starts after that
    self.serverUrl.leftView = prefixLabel;
    
    //It set when the left prefixLabel to be displayed
    self.serverUrl.leftViewMode = UITextFieldViewModeAlways;
    
    }


// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)serverUrl{
    NSLog(@"Text field ended editing");
    BaseURLString = self.serverUrl.text;
    
}

- (IBAction)chooseImage:(id)sender {
    ipc.allowsEditing = false;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (IBAction)uploadImage:(id)sender {
    BaseURLString =  self.serverUrl.text;

    NSString *string = [NSString stringWithFormat:@"http://%@/uploader", BaseURLString];
    NSData *imageData = UIImageJPEGRepresentation(self.originalImage.image, 0.5);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:string parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:@"img.jpeg"
                                mimeType:@"multipart/form-data"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          NSLog(@"%f", uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                          if (string != NULL) {
                              [self.resultLabel setText:string];
                              NSLog(@"%@ %@", response, responseObject);
                          } else {
                              UIImage *image = [[UIImage alloc] initWithData:responseObject];
                              [self.resultLabel setText:@"The image is obfuscated successfully and safe for internet use."];
                              [self.resultImage setImage:image];
                          }
                      }
                  }];
    
    [uploadTask resume];
}

#pragma mark - ImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _originalImage.contentMode = UIViewContentModeScaleAspectFit;
    _resultImage.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _originalImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
