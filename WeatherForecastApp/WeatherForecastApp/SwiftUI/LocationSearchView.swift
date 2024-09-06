//
//  LocationSearchView.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import Foundation
import SwiftUI
struct LocationSearchView: View {
    @StateObject var searchModel = LocationSearchViewModel()
    var body: some View {
        VStack {
            NavigationView {
                List(searchModel.locationResult, id: \.self) { results in
                    Button(action: {
                        searchModel.selectedCity = results.title
                        searchModel.dismiss()
                    }) {
                        Text(results.title)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(AppStrings.TITLE_CloseButton) {
                            searchModel.dismiss()
                        }
                    }
                }
                .navigationTitle(AppStrings.TITLE_SearchForCity)
            }
            .searchable(text: $searchModel.searchText)
            .onChange(of: searchModel.searchText) { newValue in
                searchModel.completer.queryFragment = searchModel.searchText
            }
        }
    }
}



struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
