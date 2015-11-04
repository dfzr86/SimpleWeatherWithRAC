//
//  SWController.m
//  SimpleWeather
//
//  Created by hanxu on 15/11/2.
//  Copyright © 2015年 __zimu. All rights reserved.
//

#import "SWController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "SWManager.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SWController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation SWController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [[SWManager sharedManager] findCurrentLocation];
}

- (void)setupUI {
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    // 2
    CGFloat inset = 20;
    // 3
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    // 4
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - (2 * inset), hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - (temperatureHeight + hiloHeight), headerFrame.size.width - (2 * inset), temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    // 5
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // 2
    // bottom left
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];
    
    // bottom left
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
    
    // top
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.text = @"Clear";
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:conditionsLabel];
    
    // 3
    // bottom left
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.image = [UIImage imageNamed:@"weather-moon"];
    iconView.contentMode = UIViewContentModeScaleAspectFit; 
    iconView.backgroundColor = [UIColor clearColor]; 
    [header addSubview:iconView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //TODO: 
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}








































@end
