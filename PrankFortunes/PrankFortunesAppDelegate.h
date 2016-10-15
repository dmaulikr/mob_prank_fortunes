//
//  PrankFortunesAppDelegate.h
//  PrankFortunes
//
//  Created by admin on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrankFortunesViewController;

@interface PrankFortunesAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PrankFortunesViewController *viewController;

@end
