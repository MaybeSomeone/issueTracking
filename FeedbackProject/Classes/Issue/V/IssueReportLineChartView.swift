//
//  IssueReportLineChartView.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/10.
//


#if canImport(UIKit)
import UIKit
#endif
import Charts
import SwiftUI


class IssueReportLineChartView: UIView {
    
    var parties: [String?] = []
    
    private lazy var linechartView: LineChartView = {
        let linechartView = LineChartView()
        linechartView.delegate = self
        linechartView.chartDescription?.enabled = false
        linechartView.dragEnabled = true
        linechartView.setScaleEnabled(true)
        linechartView.pinchZoomEnabled = true
        linechartView.rightAxis.enabled = false
        linechartView.xAxis.labelPosition = .bottom
        linechartView.legend.enabled = true
        linechartView.backgroundColor = .clear
        linechartView.xAxis.granularity = 1.0;
        linechartView.scaleXEnabled = false;
        linechartView.scaleYEnabled = false

        let linechartL = linechartView.legend
        linechartL.form = .line
        linechartL.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        linechartL.textColor = .black
        linechartL.horizontalAlignment = .center
        linechartL.verticalAlignment = .bottom
        linechartL.orientation = .horizontal
        linechartL.drawInside = false
        linechartL.yOffset = 20;
        linechartL.stackSpace = 20
        linechartL.xEntrySpace = 20
        
        let xValues4 = ["Category 1","Category 2","Category 3","Category 4"]
        let xAxis1 = linechartView.xAxis
        xAxis1.labelFont = .systemFont(ofSize: 9)
        xAxis1.labelTextColor = .black
        xAxis1.drawAxisLineEnabled = false
        xAxis1.drawGridLinesEnabled = false
        xAxis1.forceLabelsEnabled = true;
        linechartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues4)
        
        let leftAxis1 = linechartView.leftAxis
        leftAxis1.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis1.axisMaximum = 6
        leftAxis1.axisMinimum = 0
        leftAxis1.drawGridLinesEnabled = true
        leftAxis1.granularityEnabled = true
        linechartView.animate(xAxisDuration: 2.5)
        return linechartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    func addSubviews() {
        
        addSubview(linechartView)
        linechartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setDataLineCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = range / 2
            let val = Double(arc4random_uniform(mult) + 50)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals3 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 500)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(entries: yVals1, label: "Income")
        set1.axisDependency = .right
        set1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        set1.setCircleColor(.black)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        
        let set2 = LineChartDataSet(entries: yVals2, label: "Resolve")
        set2.axisDependency = .right
        set2.setColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))
        set2.setCircleColor(.black)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false
        set2.drawCirclesEnabled = false
        set2.drawValuesEnabled = false
        
        let set3 = LineChartDataSet(entries: yVals3, label: "Close")
        set3.axisDependency = .right
        set3.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
        set3.lineWidth = 2
        set3.circleRadius = 3
        set3.fillAlpha = 65/255
        set3.fillColor = UIColor.yellow.withAlphaComponent(200/255)
        set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set3.drawCircleHoleEnabled = false
        set3.drawCirclesEnabled = false
        set3.drawValuesEnabled = false
        
        let data = LineChartData(dataSets: [set1, set2, set3])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        linechartView.xAxis.axisMinimum = -0.8
        linechartView.data = data
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - ChartViewDelegate
extension IssueReportLineChartView: ChartViewDelegate {
    
    
}
