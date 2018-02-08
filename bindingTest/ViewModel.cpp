//
//  ViewModel.cpp
//  bindingTest
//
//  Created by David Ventura on 2017/06/01.
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

// NSKeyValueChangeSetting = 1
// NSKeyValueChangeInsertion = 2
// NSKeyValueChangeRemoval = 3
// NSKeyValueChangeReplacement = 4

void CViewModel::AddDataToVector( SData data, uint32_t index )
{
	std::vector<int> indices;
	indices.push_back( index );
	fListener.IViewModelListener_WillChange( "arrayValue", 2, &indices  );
	fPairVector.insert( fPairVector.begin() + index, data );
	fListener.IViewModelListener_DidChange( "arrayValue", 2, &indices );
}

void CViewModel::RemoveData( uint32_t index )
{
	std::vector<int> indices;
	indices.push_back( index );
	fListener.IViewModelListener_WillChange( "arrayValue", 3, &indices );
	fPairVector.erase( fPairVector.begin() + index );
	fListener.IViewModelListener_DidChange( "arrayValue", 3, &indices );
}
