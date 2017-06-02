//
//  MainViewModel.h
//  bindingTest
//
//  Created by David Ventura on 2017/05/29.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

#ifndef MainViewModel_h
#define MainViewModel_h

#import <Foundation/Foundation.h>

@interface PHMainViewModel : NSObject

- (void)applySliderValue:(NSInteger)valueFrom0to100;

@end

#ifdef __cplusplus
extern "C" {
#endif // ndef __cplusplus
	
PHMainViewModel* GetMainViewModelInstance();
	
#ifdef __cplusplus
} // extern "C"
#endif // ndef __cplusplus

#endif /* MainViewModel_h */
