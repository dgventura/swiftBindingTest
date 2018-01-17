//
//  ViewModel.cpp
//  bindingTest
//
//  Created by David Ventura on 2017/06/01.
//  Copyright © 2017年 Propellerhead AB. All rights reserved.
//

#include "ViewModel.hpp"

CViewModel::CViewModel(IViewModelListener& iObserver) : fListener(iObserver), fIntValue(33)
{
	fPairVector.push_back( std::make_pair<int, int>(1,1) );
	fPairVector.push_back( std::make_pair<int, int>(2,1) );
	fPairVector.push_back( std::make_pair<int, int>(3,2) );
	fPairVector.push_back( std::make_pair<int, int>(1,4) );
	fPairVector.push_back( std::make_pair<int, int>(4,2) );
}

int CViewModel::GetIntegerValue() const
{
	return fIntValue;
}

void CViewModel::SetIntegerValue( int value )
{
	fListener.IViewModelListener_WillChange( "intValue" );
	fIntValue = value;
	fListener.IViewModelListener_DidChange( "intValue" );
}

const std::vector< std::pair<int, int> >& CViewModel::GetVectorData() const
{
	return fPairVector;
}

void CViewModel::AddDataToVector( SData data, uint32_t index )
{
	fPairVector.insert( fPairVector.begin() + index, data );
}

void CViewModel::RemoveData( uint32_t index )
{
	fListener.IViewModelListener_WillChange( "arrayValue" );
	fPairVector.erase( fPairVector.begin() + index );
	fListener.IViewModelListener_DidChange( "arrayValue" );
}
