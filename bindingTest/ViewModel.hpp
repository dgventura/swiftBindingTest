//
//  ViewModel.hpp
//  bindingTest
//
//  Created by David Ventura on 2017/06/01.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

#ifndef ViewModel_hpp
#define ViewModel_hpp

//#include "Parts/MobileJukebox/Klister/MOMSubscriber.h"
#include <string>
#include <vector>
#include <map>

class IViewModelListener {
public: virtual void IViewModelListener_WillChange(const std::string& iPropertyName) = 0;
public: virtual void IViewModelListener_DidChange(const std::string& iPropertyName) = 0;
};

class CViewModel {
public: CViewModel(IViewModelListener& iObserver);
	
#if DEBUG
public:  bool CheckInvariant() const;
#endif // DEBG

public: int GetIntegerValue() const;
public: void SetIntegerValue( int value );
	
public: const std::vector< std::pair<int, int> >& GetVectorData() const;
	
private: IViewModelListener& fListener;
private: int fIntValue;
private: std::vector< std::pair<int, int> > fPairVector;
};

#endif /* ViewModel_hpp */
