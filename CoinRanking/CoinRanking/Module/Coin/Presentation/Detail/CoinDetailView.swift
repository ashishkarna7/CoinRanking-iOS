//
//  CoinDetailView.swift
//  CoinRanking
//
//  Created by Ashish Karna on 22/02/2025.
//

import UIKit
import SwiftUI
import Charts

class CoinDetailView: BaseView {
 
    private lazy var headingView: CoinHeadingView = {
        let view = CoinHeadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chartTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.heading
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chartContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [ChartPeriodType.day.value,
                                                          ChartPeriodType.week.value,
                                                          ChartPeriodType.month.value,
                                                          ChartPeriodType.year.value])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var chartStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chartTitleLabel, chartContainerView, segmentedControl])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var statisticTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.heading
        label.textColor = AppColor.textPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statisticView: CoinStatisticsView = {
        let view = CoinStatisticsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statisticStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statisticTitleLabel, statisticView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headingView, chartStackView, statisticStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(containerStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(containerView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    override func create() {
        self.backgroundColor = AppColor.tableViewBackgroundColor
        addSubview(scrollView)
        generateChildren()
        chartTitleLabel.text = "Price chart"
        statisticTitleLabel.text = "Statistics"
    }
    
    private func generateChildren() {
        scrollView.snp.makeConstraints({ make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        })
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        chartContainerView.snp.makeConstraints { make in
            make.height.equalTo(220) // Adjust height as needed
        }
    }
    
    private func setupChartView(with data: [CoinPricePoint]) {
        // Remove any previously added chart view
        chartContainerView.subviews.forEach { $0.removeFromSuperview() }
        let chartView = UIHostingController(rootView: CoinChartView(data: data))
        chartView.view.backgroundColor = .clear
        chartView.view.translatesAutoresizingMaskIntoConstraints = false
        
        chartContainerView.addSubview(chartView.view)
        chartView.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func config(vm: CoinDetailItemViewModel) {
        headingView.config(vm: vm)

        if let hexValue = vm.chartBackgroundColor {
            let color =  UIColor(hex: hexValue)
            chartContainerView.backgroundColor = color.withAlphaComponent(0.2)
            statisticView.backgroundColor = color.withAlphaComponent(0.2)
        }
        if !vm.chartData.isEmpty {
            setupChartView(with: vm.chartData)
        }
        
        statisticView.config(vm: vm)
        
    }
}
