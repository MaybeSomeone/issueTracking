//
//  IssueReportPieChartView.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/3/10.
//

#if canImport(UIKit)
import UIKit
#endif
import Charts
import SwiftUI

class IssueReportPieChartView: UIView {

    var parties: [String?] = []
    
    private lazy var pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.delegate  = self
        pieChartView.backgroundColor = .clear
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.highlightPerTapEnabled = false;
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawCenterTextEnabled = true
        
        let caregoreL = pieChartView.legend
        caregoreL.horizontalAlignment = .center
        caregoreL.verticalAlignment = .bottom
        caregoreL.orientation = .horizontal
        caregoreL.xEntrySpace = 7
        caregoreL.yEntrySpace = 0
        caregoreL.yOffset = 0
        pieChartView.entryLabelColor = .white
        pieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        return pieChartView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    func addSubviews() {
        
        addSubview(pieChartView)
        pieChartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(Int(100 -  i*5)),
                                     label: parties[i % parties.count])
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.drawValuesEnabled = true
        set.colors = ChartColorTemplates.vordiplom()
        + ChartColorTemplates.joyful()
        + ChartColorTemplates.colorful()
        + ChartColorTemplates.liberty()
        + ChartColorTemplates.pastel()
        + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
//        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ChartViewDelegate
extension IssueReportPieChartView: ChartViewDelegate {
    
    
}


