//
//  ShaderTableViewController.m
//  OpenGLAtestation
//
//  Created by Alexander Shipin on 28/01/2017.
//  Copyright © 2017 Sibers. All rights reserved.
//

#import "ShaderTableViewController.h"
#import "HRShaderController.h"
#import "ViewController.h"
#import <HRSubclasses/NSObject+HRGetSubclass.h>

@interface ShaderTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray<HRShaderController*>* controllers;

@end

@implementation ShaderTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
        ((ViewController*)segue.destinationViewController).controller = self.controllers[[sender row]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray<Class>* classes = [HRShaderController hrSubclasses];
    NSMutableArray* list = [NSMutableArray new];
    for (Class cl in classes) {
        if (cl != [HRShaderController class]) {
            [list addObject:[cl new]];
        }
    }
    _controllers = list;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    cell.textLabel.text = [self.controllers[indexPath.row] shaderName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"go" sender:indexPath];
}

@end
