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
    
    func setDataCount(_ dict : [String:[IssueModel?]] , type : String) {
        
        if dict.keys.count == 0 {
            pieChartView.data = nil;
            return;
        }
        

        let entries = (0..<dict.keys.count).map { (i) -> PieChartDataEntry in
            print(i)
            return PieChartDataEntry(value: Double(Array(dict.values)[i].count),
                                     label:tolabelStr(_type: type, _x_value:  Array(dict.keys)[i]))
        }        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.drawValuesEnabled = false
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
    
    func tolabelStr(_type:String , _x_value:String) -> String {if _type == "type"{
        switch _x_value {
        case "0":
            return "all"
        case "1":
            return "Feature"
        case "2":
            return "Task"
        case "3":
            return "Bug"
        default:
            break
        }
    }
    else{
        
        switch _x_value {
        case "0":
            return "all"
        case "1":
            return "Finance"
        case "2":
            return "Sales"
        case "3":
            return "Human Resources"
        default:
            break
        }
    }
        return ""
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ChartViewDelegate
extension IssueReportPieChartView: ChartViewDelegate {
    
    
}


