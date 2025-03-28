//
//  CoinChartView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import SwiftUI
import Charts

struct CoinChartView: View {
    let data: [CoinPricePoint]
    
    var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value(LocalizedKeys.date.value, point.date),
                y: .value(LocalizedKeys.price.value, point.price)
            )
            .foregroundStyle(.blue)
        }
        .frame(height: 200)
        .padding()
    }
}
