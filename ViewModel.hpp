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

class IViewModelListener {
public: virtual void IViewModelListener_OnChange(const std::string& iPropertyName) = 0;
};

class CViewModel /*: public NSBeanCounter::IMOMSubscriber*/ {
public: CViewModel(IViewModelListener& iObserver);
	
#if DEBUG
public:  bool CheckInvariant() const;
#endif // DEBG

	
private: IViewModelListener& fListener;
};

#endif /* ViewModel_hpp */
