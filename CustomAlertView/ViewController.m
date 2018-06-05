//
//  ViewController.m
//  CustomAlertView
//
//  Created by Duzj on 2018/6/4.
//  Copyright © 2018年 dzj. All rights reserved.
//

#import "ViewController.h"
#import "TCustomAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnAction:(id)sender {
    TCustomAlertView *alert = [[TCustomAlertView alloc] initWithTitle:@"哈哈啊哈" message:nil];
    TCustomAlertAction *cacelAction = [TCustomAlertAction actionWithTitle:@"取消" titleColor:[UIColor grayColor] handler:^(TCustomAlertAction *action) {
    }];
    TCustomAlertAction *action = [TCustomAlertAction actionWithTitle:@"确定" titleColor:[UIColor blueColor] handler:^(TCustomAlertAction *action) {
    }];
    [alert addAction:cacelAction];
    [alert addAction:action];
    [alert show];
}

- (IBAction)systemAlertAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"fafa" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"fa" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
