//
//  ViewController.m
//  Accelerometers&Gyroscope
//
//  Created by Kostya on 09.10.2017.
//  Copyright © 2017 SKS. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *staticButton;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *stop;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.staticLabel.text = @"no data";
    self.dynamicLabel.text = @"no data";
    self.staticButton.enabled = NO;
    self.start.enabled = NO;
    self.stop.enabled = NO;
    self.imageView.image = [UIImage imageNamed:@"image"];
    
    self.manager = [[CMMotionManager alloc]init];
    if(self.manager.accelerometerAvailable)
    {
        self.staticButton.enabled = YES;
        self.start.enabled = YES;
        [self.manager startAccelerometerUpdates];
    }
    else
    {
        self.staticLabel.text = @"NO AccelerometerAvailable";
        self.dynamicLabel.text = @"NO AccelerometerAvailable";
    }
    
}

- (IBAction)staticRequest:(id)sender
{
    CMAccelerometerData *aData = self.manager.accelerometerData;
    if(aData != nil)
    {
        CMAcceleration acceleration = aData.acceleration;
        self.staticLabel.text = [NSString stringWithFormat:@":%f\ny:%f\nz:%f",acceleration.x,acceleration.y,acceleration.z];
    }
}
- (IBAction)startDynamicCallBacs:(id)sender
{
    self.stop.enabled = YES;
    self.start.enabled = NO;
    
    self.manager.accelerometerUpdateInterval = 0.01;
    
    ViewController * __weak weakSelf = self; //break the loop in ios
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [self.manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        double x = accelerometerData.acceleration.x;
        double y = accelerometerData.acceleration.y;
        double z = accelerometerData.acceleration.z;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakSelf.dynamicLabel.text = [NSString stringWithFormat:@":%f\ny:%f\nz:%f",x,y,z];
        }];
        
    }];
}

- (IBAction)stopDynamicCallbacks:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
