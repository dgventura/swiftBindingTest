//
//  ViewModel.hpp
//  bindingTest
//
//  Created by David Ventura on 2017/06/01.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

#ifndef ViewModel_hpp
#define ViewModel_hpp

#include <string>
#include <vector>
#include <map>

typedef std::pair<int, int> SData;

class IViewModelListener {
public: virtual void IViewModelListener_WillChange( const std::string& iPropertyName, int iOperationType = 1, std::vector<int>* iIndices = NULL ) = 0;
public: virtual void IViewModelListener_DidChange( const std::string& iPropertyName, int iOperationType = 1, std::vector<int>* iIndices = NULL ) = 0;
};

class CViewModel {
public:
	CViewModel(IViewModelListener& iObserver);
	
	int GetIntegerValue() const;
	void SetIntegerValue( int value );
	
	const std::vector< SData >& GetVectorData() const;
	void AddDataToVector( SData data, uint32_t index );
	void RemoveData( uint32_t index );
	
private:
	IViewModelListener& fListener;
	int fIntValue;
	std::vector< SData > fPairVector;
};

#endif /* ViewModel_hpp */
