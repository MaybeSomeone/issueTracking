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
        
//        let xValues = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        let xAxis = barChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.granularity = 0.80
        xAxis.centerAxisLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = 12
        xAxis.labelWidth = (CGFloat.screenWidth - 40)/12

//        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)

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
    
    func setDataBarCount(_ count: Int, range: UInt32) {
        let groupSpace = 0.80
        let barSpace = 0.05
        let barWidth = 0.30

        let randomMultiplier = range
        
        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
        }
        let yVals1 = (0 ..< count).map(block)
        let yVals2 = (0 ..< count).map(block)
        let yVals3 = (0 ..< count).map(block)
        
        let set1 = BarChartDataSet(entries: yVals1, label: "Figure legend 1")
        set1.setColor(UIColor(red: 0/255, green: 132/255, blue: 255/255, alpha: 1))
        set1.drawValuesEnabled = false
        let set2 = BarChartDataSet(entries: yVals2, label: "Figure legend 2")
        set2.setColor(UIColor(red: 90/255, green: 216/255, blue: 166/255, alpha: 1))
        set2.drawValuesEnabled = false
        
//        let set3 = BarChartDataSet(entries: yVals3, label: "Series 3")
//        set3.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
//        set3.drawValuesEnabled = false
//        let data = BarChartData(dataSets: [set1, set2, set3])
        
        let data = BarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.barWidth = barWidth
        // restrict the x-axis range
        barChartView.xAxis.axisMinimum = Double(0)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.drawValueAboveBarEnabled = false
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        barChartView.xAxis.axisMaximum = Double(0) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(count)
        
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
