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

@interface WrappedClass : NSObject

@property (nonatomic, readonly) NSInteger column;
@property (nonatomic, readonly) NSInteger row;

@end

@interface PHMainViewModel : NSObject

- (void)applySliderValue:(NSInteger)valueFrom0to100;
- (void)willChange:(NSString*)keyPath;
- (void)didChange:(NSString*)keyPath;

@property (nonatomic, readonly) NSInteger intValue;
@property (nonatomic, strong) NSMutableArray<WrappedClass*>* arrayValue;

@end

#ifdef __cplusplus
extern "C" {
#endif // ndef __cplusplus
	
PHMainViewModel* GetMainViewModelInstance();
	
#ifdef __cplusplus
} // extern "C"
#endif // ndef __cplusplus

#endif /* MainViewModel_h */
