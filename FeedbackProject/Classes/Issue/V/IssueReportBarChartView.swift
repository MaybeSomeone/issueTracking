//
//  IssueReportBarChartView.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/10.
//

#if canImport(UIKit)
import UIKit
#endif
import Charts
import SwiftUI

class IssueReportBarChartView: UIView {

    var parties: [String?] = []
    var y_value: Int = 0

    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.delegate  = self
        barChartView.backgroundColor = .clear
        barChartView.chartDescription?.enabled =  false
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        let barChartL = barChartView.legend
        barChartL.horizontalAlignment = .center
        barChartL.verticalAlignment = .bottom
        barChartL.orientation = .horizontal
        barChartL.drawInside = false
        barChartL.font = .systemFont(ofSize: 8, weight: .light)
        barChartL.yOffset = 10
        barChartL.xOffset = 10
        barChartL.yEntrySpace = 0
        
        let xAxis = barChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = 12
        xAxis.labelWidth = (CGFloat.screenWidth - 40)/12

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        leftAxis.valueFormatter = IntAxisValueFormatter()
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0
        barChartView.rightAxis.enabled = false
        //        leftAxis.drawGridLinesEnabled = false;
        leftAxis.drawAxisLineEnabled = false;
        return barChartView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    func addSubviews() {
        
        addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setDataCount(_ dict : [String:[IssueModel?]]) {
        
        if dict.keys.count == 0 {
            barChartView.data = nil;
            return;
        }
        let groupSpace = 0.1
        let barSpace = 0.2
        let barWidth = 0.25

        // (0.2 + 0.25) * 2 + 0.10 = 1.00 -> interval per "group"
        // (0.1 + 0.1) * 4 + 0.20 = 1.00 -> interval per "group"

        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: Array(dict.keys))
        
        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            var count = 0
            print(Array(dict.values)[i])
            
            for model in Array(dict.values)[i] where model?.status == "0"{
                count = count+1
            }
            
            return BarChartDataEntry(x: Double(i), y: Double(count))
        }
        let block1: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            var count = 0
            
            for model in Array(dict.values)[i] where model?.status == "1" {
                count = count+1
            }
                        
            return BarChartDataEntry(x: Double(i), y: Double(count))
        }
        let yVals1 = (0 ..< dict.keys.count).map(block)
        let yVals2 = (0 ..< dict.keys.count).map(block1)
        
        let set1 = BarChartDataSet(entries: yVals1, label: "Open")
        set1.setColor(UIColor(red: 0/255, green: 132/255, blue: 255/255, alpha: 1))
        set1.drawValuesEnabled = false
        let set2 = BarChartDataSet(entries: yVals2, label: "Close")
        set2.setColor(UIColor(red: 90/255, green: 216/255, blue: 166/255, alpha: 1))
        set2.drawValuesEnabled = false
        
        
        let data = BarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.barWidth = barWidth
        // restrict the x-axis range
        barChartView.xAxis.axisMinimum = Double(0)
        barChartView.xAxis.labelPosition = .bottom
//
//        let xValues = ["Category 1","Category 2","Category 3","Category 4"]
//        let xAxis = barChartView.xAxis
//        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
//        xAxis.granularity = 1
//        xAxis.centerAxisLabelsEnabled = true
//        xAxis.drawGridLinesEnabled = false
//        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)

        barChartView.drawValueAboveBarEnabled = false
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        barChartView.xAxis.axisMaximum = Double(0) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(dict.keys.count)
        
        data.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        

        barChartView.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - ChartViewDelegate
extension IssueReportBarChartView: ChartViewDelegate {
    
    
}
