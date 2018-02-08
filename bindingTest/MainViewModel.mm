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
#import <Foundation/NSError.h>

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
	
public: void IViewModelListener_WillChange(const std::string& iPropertyName, int iOperationType = 1, std::vector<int>* iIndices = NULL ) {
	NSString* propertyName = [NSString stringWithUTF8String:iPropertyName.c_str()];
	
	NSString* firstChar = [[propertyName substringToIndex:1] lowercaseString];
	NSString* keyPath = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstChar];
	
	NSMutableIndexSet* indices = nil;
	if ( iIndices && iIndices->size() )
	{
		indices = [NSMutableIndexSet indexSetWithIndex:(*iIndices)[0]];
		for ( int i = 1; i < iIndices->size(); ++i )
		{
			[indices addIndex:(*iIndices)[i]];
		}
		[fMainViewModel willChange:(NSKeyValueChange)iOperationType valuesAtIndexes:indices forKey:keyPath];
	}
	else
	{
		[fMainViewModel willChangeValueForKey:keyPath];
	}
}
	
public: void IViewModelListener_DidChange(const std::string& iPropertyName, int iOperationType = 1, std::vector<int>* iIndices = NULL ) {
	NSString* propertyName = [NSString stringWithUTF8String:iPropertyName.c_str()];
	
	NSString* firstChar = [[propertyName substringToIndex:1] lowercaseString];
	NSString* keyPath = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstChar];
	
	NSMutableIndexSet* indices = nil;
	if ( iIndices && iIndices->size() )
	{
		indices = [NSMutableIndexSet indexSetWithIndex:(*iIndices)[0]];
		for ( int i = 1; i < iIndices->size(); ++i )
		{
			[indices addIndex:(*iIndices)[i]];
		}
		[fMainViewModel didChange:(NSKeyValueChange)iOperationType valuesAtIndexes:indices forKey:keyPath];
	}
	else
	{
		[fMainViewModel didChangeValueForKey:keyPath];
	}

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

@dynamic arrayValue;

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

- (NSInteger)intValue
{
	return fViewModel->GetIntegerValue();
}

- (void)applySliderValue:(NSInteger)valueFrom0to100;
{
	NSLog( @"Slider changed to %ld", (long)valueFrom0to100 );
	fViewModel->SetIntegerValue( (int)valueFrom0to100 );
}

- (void)applyButtonTap
{
	SData search = std::make_pair<int, int>( 42, 42 );
	fViewModel->AddDataToVector( search, 0 );
}

- (NSUInteger)countOfArrayValue
{
	return fViewModel->GetVectorData().size();
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
	if ( [key isEqualToString:@"arrayValue"] )
		return NO;
	else
		return YES;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel {
	if ( sel == @selector(arrayValue) ) {
		return [super methodSignatureForSelector:@selector( mutableArrayValueForKey: )];
	} else {
		return [super methodSignatureForSelector:sel];
	}
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	
	if ( [invocation selector] == @selector(arrayValue) ) {
		__unsafe_unretained id value = [self mutableArrayValueForKey:@"arrayValue"];
		[invocation setReturnValue:&value];
	}
}

- (id)objectInArrayValueAtIndex:(NSUInteger)index {
	std::pair< int, int > pair = fViewModel->GetVectorData()[index];
	return [[WrappedClass alloc] initWithColumn: pair.first andRow: pair.second];
}

- (void)insertObject:(WrappedClass *)object inArrayValueAtIndex:(NSUInteger)index
{
	fViewModel->AddDataToVector( std::make_pair( object.row, object.column ), static_cast<uint32_t>(index) );
}

- (NSUInteger)indexInArrayValueOfObject:(id)object
{
	WrappedClass* castObj = (WrappedClass*)object;
	SData search = std::make_pair<int, int>( (int)castObj.column, (int)castObj.row );
	auto i = std::find(fViewModel->GetVectorData().cbegin(), fViewModel->GetVectorData().cend(), search);
	return (i == fViewModel->GetVectorData().cend()) ? NSNotFound : (i - fViewModel->GetVectorData().cbegin());
}

- (NSArray *)arrayValueAtIndexes:(NSIndexSet *)indexes
{
	NSMutableArray<WrappedClass*>* ret = [[NSMutableArray alloc] initWithCapacity:indexes.count];
	[indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		const SData& src = fViewModel->GetVectorData()[idx];
		[ret addObject:[[WrappedClass alloc] initWithColumn:src.first andRow:src.second]];
	}];
	return ret;
}

/*- (void)getBackingArrayValue:(id __unsafe_unretained [])buffer range:(NSRange)range;
{
	NSIndexSet* set = (NSIndexSet*)buffer[0];
	std::vector<SData> objects(set.count);
	objects.resize(set.count);
	for ( auto itr = objects.begin(); itr != objects.end(); ++itr )
	{
		*itr = *(fViewModel->GetVectorData().begin() + (itr - objects.begin()));
	}
//	std::for_each(fViewModel->GetVectorData().cbegin() + range.location, fViewModel->GetVectorData().cbegin() + range.location + range.length, [&](SData * const c){
		(it1++) = c;
	});
}*/

- (void)insertArrayValue:(NSArray*)array atIndexes:(NSIndexSet*)indexes
{
	__block NSUInteger idx1 = 0;
	[indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
		WrappedClass* object = array[idx1++];
		fViewModel->AddDataToVector( std::make_pair<int, int>(static_cast<int32_t>(object.row), static_cast<int32_t>(object.column)), static_cast<uint32_t>(idx) );
	}];
}

- (void)removeObjectFromArrayValueAtIndex:(NSUInteger)index
{
	fViewModel->RemoveData( static_cast<uint32_t>(index) );
}

- (void)removeArrayValueAtIndexes:(NSIndexSet*)indexes
{
	[indexes enumerateRangesWithOptions:NSEnumerationReverse usingBlock:^(NSRange range, BOOL * _Nonnull stop) {
		NSAssert( range.length == 1, @"bad" );
		fViewModel->RemoveData( static_cast<uint32_t>(range.location) );
	}];
}

@end

