//
//  ISHHoverBar+Tests.h
//  ISHHoverBar
//
//  Created by Felix Lamouroux on 12.07.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHHoverBar.h"

@interface ISHHoverBar (Testing)
/// The controls associated with the bar's items. Used for testing.
- (NSArray<UIControl *> *)controls;
@end
