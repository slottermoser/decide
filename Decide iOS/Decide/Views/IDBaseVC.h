//
//  IDBaseVC.h
//  Decide
//
//  Created by Robert Brown on 3/24/12.
//  Copyright (c) 2012 Robert Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBCoreDataManager.h"

@interface IDBaseVC : UIViewController

@property (nonatomic, strong, readonly) NSManagedObjectContext * moc;

@end
