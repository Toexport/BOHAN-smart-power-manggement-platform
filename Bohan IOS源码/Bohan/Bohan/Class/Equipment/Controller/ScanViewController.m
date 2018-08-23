
//
//  RootViewController.m
//  NewProject
//
//  Created by Summer on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "ScanViewController.h"
#import "DebuggingANDPublishing.pch"
@interface ScanViewController ()

@end

@implementation ScanViewController
@synthesize hideBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = Localize(@"条形码");
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 30)];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel setBackgroundColor:[UIColor clearColor]];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cancel setTitle:Localize(@"取消") forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];

    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (ScreenWidth + 80 - 64)/2, ScreenWidth-80, ScreenWidth -80)] ;
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+15, imageView.frame.origin.y+10, imageView.frame.size.width- 30, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self setupCamera];
    
}
-(void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)animation1 {
    if (upOrdown == NO) {
        num ++;
//        _line.frame = CGRectMake(_line.frame.origin.x, imageView.frame.origin.y+10+2*num, 220, 2);
        _line.frame = CGRectChangeY(_line.frame, imageView.frame.origin.y+10+2*num);
        if (2*num == ScreenWidth -100) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectChangeY(_line.frame, imageView.frame.origin.y+10+2*num);
        if (num == 0) {
            upOrdown = NO;
        }
    }

}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self setupCamera];
//
//}
- (void)setupCamera {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
//    if (_output.availableMetadataObjectTypes.count == 0) {
//        return;
//    }
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    [timer invalidate];
    scanBlock(stringValue);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)getResultStr:(QRScanSuccess)resultBlock {
    scanBlock = resultBlock;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
