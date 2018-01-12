//
//  MainViewModel.m
//  bindingTest
//
//  Created by David Ventura on 2017/05/29.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

#import "MainViewModel.h"
#import <Foundation/FoundationErrors.h>
#import "ViewModel.hpp"
#import <UIKit/UIKit.h>

@implementation WrappedClass

- (id)initWithColumn:(NSInteger)c andRow:(NSInteger)r
{
	self = [super init];
	
	_column = c;
	_row = r;
	
	return self;
}

@end


static PHMainViewModel* gInstance = nil;

namespace {
	
class CViewModelListener : public IViewModelListener {
	
public: CViewModelListener(PHMainViewModel* iMainViewModel) :
	fMainViewModel(iMainViewModel)
	{
	}
	
public: void IViewModelListener_WillChange(const std::string& iPropertyName) {
	NSString* propertyName = [NSString stringWithUTF8String:iPropertyName.c_str()];
	
	NSString* firstChar = [[propertyName substringToIndex:1] lowercaseString];
	NSString* keyPath = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstChar];
	
	[fMainViewModel willChange:keyPath];
}
	
public: void IViewModelListener_DidChange(const std::string& iPropertyName) {
	NSString* propertyName = [NSString stringWithUTF8String:iPropertyName.c_str()];
	
	NSString* firstChar = [[propertyName substringToIndex:1] lowercaseString];
	NSString* keyPath = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstChar];
	
	[fMainViewModel didChange:keyPath];
}
private: PHMainViewModel* fMainViewModel;
};

} // anonymous namespace


void CreateMainViewModelInstance() {
	NSCAssert(gInstance == nil, @"" );
	gInstance = [[PHMainViewModel alloc] init];
}

void DisposeMainViewModelInstance() {
	NSCAssert(gInstance != nil, @"" );
	gInstance = nil;
}

PHMainViewModel* GetMainViewModelInstance() {
	if ( gInstance == nil )
	{
		CreateMainViewModelInstance();
	}
	NSCAssert(gInstance != nil, @"" );
	return gInstance;
}

@implementation PHMainViewModel {
	std::unique_ptr<CViewModel> fViewModel;
	std::unique_ptr<CViewModelListener> fViewModelListener;
}

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		fViewModelListener.reset(new CViewModelListener(self));
		fViewModel.reset(new CViewModel(*fViewModelListener));
		
		
	}
	return self;
}

- (void)setup
{
	
}

- (void)willChange:(NSString *)keyPath {
	[self willChangeValueForKey:keyPath];
}

- (void)didChange:(NSString*)keyPath {
	[self didChangeValueForKey:keyPath];
}

- (NSInteger)intValue
{
	return fViewModel->GetIntegerValue();
}

- (void)applySliderValue:(NSInteger)valueFrom0to100;
{
	NSLog( @"Slider changed to %ld", (long)valueFrom0to100 );
	fViewModel->SetIntegerValue( (int)valueFrom0to100 );
}

- (NSInteger)countOfArrayValue
{
	return fViewModel->GetVectorData().size();
}

- (NSArray<WrappedClass*>*)arrayValue
{
	NSMutableArray<WrappedClass*>* proxyData = [[NSMutableArray alloc] initWithCapacity:fViewModel->GetVectorData().size()];
	for ( int i = 0; i < fViewModel->GetVectorData().size(); ++i )
	{
		std::pair< int, int > pair = fViewModel->GetVectorData()[i];
		[proxyData addObject:[[WrappedClass alloc] initWithColumn: pair.first andRow: pair.second]];
	}
	return proxyData;
}

- (id)objectInArrayValueAtIndex:(NSUInteger)index {
	std::pair< int, int > pair = fViewModel->GetVectorData()[index];
	return [[WrappedClass alloc] initWithColumn: pair.first andRow: pair.second];
}

@end

