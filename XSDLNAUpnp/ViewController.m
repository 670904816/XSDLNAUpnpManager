//
//  ViewController.m
//  XSDLNAUpnp
//
//  Created by LongLin on 2017/6/11.
//  Copyright © 2017年 LongLin. All rights reserved.
//

#import "ViewController.h"
#import "XSDLNAUpnpManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[XSDLNAUpnpManager sharedInstance] startSearch];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
