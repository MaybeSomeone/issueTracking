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

struct DataModel {
    var type: String
    var value: String
}
class IssueReportLineChartView: UIView {
    
    var parties: [String?] = []
    var y_value: Int = 0
    var dataDictionary = Dictionary<String,[DataModel?]>()
    var dataArr: [DataModel?] = {
        let dataArr: [DataModel?] = []
        return dataArr
    }()
    
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
        
        let xAxis1 = linechartView.xAxis
        xAxis1.labelFont = .systemFont(ofSize: 9)
        xAxis1.labelTextColor = .black
        xAxis1.drawAxisLineEnabled = false
        xAxis1.drawGridLinesEnabled = false
        xAxis1.forceLabelsEnabled = true;
        
        let leftAxis1 = linechartView.leftAxis
        leftAxis1.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
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
    
    func setDataCount(_ array : [IssueModel?] , _ timeDict : [String : Any]) {
        var _minTinem = timeDict["startDate"]
        var _maxTinem = timeDict["endDate"]
        self.dataArr.removeAll()
        if array.count == 0 {
            linechartView.data = nil;
            return;
        }
        for model in array{

            if _minTinem == nil || (model!.createDate!.compare(_minTinem as! Date) == .orderedAscending || model!.createDate!.compare(_minTinem as! Date) == .orderedSame){
                _minTinem = model?.createDate
                _maxTinem = Calendar.current.startOfDay(for: Date())
            }
            if model!.createDate != nil && ( model!.createDate?.compare(_minTinem as! Date) == .orderedDescending || model!.createDate!.compare(_minTinem as! Date) == .orderedSame){
                let model =  DataModel(type: "createDate", value: GetWeekByDate(date: model!.createDate!))
                dataArr.append(model)
            }
            if model!.closeDate != nil && (model!.closeDate?.compare((_minTinem as! Date)) == .orderedDescending || model!.createDate!.compare(_minTinem as! Date) == .orderedSame){
                let model =  DataModel(type: "closeDate", value: GetWeekByDate(date: model!.closeDate!))
                dataArr.append(model)

            }
            if model!.resolveDate != nil && (model!.resolveDate?.compare((_minTinem as! Date)) == .orderedDescending || model!.createDate!.compare(_minTinem as! Date) == .orderedSame){
                
                let model =  DataModel(type: "resolveDate", value: GetWeekByDate(date: model!.resolveDate!))
                dataArr.append(model)

            }
           
        }
        
        dataDictionary = Dictionary(grouping: dataArr, by: { ($0?.value)!})
        
        let keys : Array = dataDictionary.sorted(by: {$0.0 < $1.0})
        print(keys)

        let yVals1 = (0..<keys.count).map { (i) -> ChartDataEntry in
            var count = 0
            for model in keys[i].value where model!.type == "createDate"{
                count = count+1
            }
            print(ChartDataEntry(x: Double(i), y: Double(count)))
            return ChartDataEntry(x: Double(i), y:  Double(count))
        }
        let yVals2 = (0..<keys.count).map { (i) -> ChartDataEntry in
            var count = 0
            for model in keys[i].value where model!.type == "closeDate"{
                count = count+1
            }
            print(ChartDataEntry(x: Double(i), y: Double(count)))
            return ChartDataEntry(x: Double(i), y: Double(count))
        }
        let yVals3 = (0..<keys.count).map { (i) -> ChartDataEntry in
            var count = 0
            for model in keys[i].value where model!.type == "resolveDate"{
                count = count+1
            }
            print(ChartDataEntry(x: Double(i), y: Double(count)))
            return ChartDataEntry(x: Double(i), y: Double(count))
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
        linechartView.data = data
        
       var xArray = [String]();
        for str in keys{
            xArray.append(str.key)
            
        }
        
        linechartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xArray)
        linechartView.xAxis.granularity = 1
//        linechartView.xAxis.axisMinimum = 0
//        linechartView.xAxis.axisMaximum = Double(xArray.count) + 1

        func GetWeekByDate(date:Date) ->String{
                guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
                    return ""
                }
            let components = calendar.components([.weekOfYear,.weekOfMonth,.weekday,.weekdayOrdinal,.year,.month], from: date)
                //今年的第几周
                let weekOfYear = components.weekOfYear!
                
                //这个月第几周
                let weekOfMonth = components.weekOfMonth!
            
                //周几
                let weekday = components.weekday!
                //这个月第几周
                let weekdayOrdinal = components.weekdayOrdinal!
                let year = components.year!
                let month = components.month!
                print(weekOfYear)
                print(weekOfMonth)
                print(weekday)
                print(weekdayOrdinal)
            switch components.weekOfMonth {
            case 1:
                return "\(year)-\(month)-\(components.weekOfMonth!)st";
            case 2:
                return "\(year)-\(month)-\(components.weekOfMonth!)nd";
            case 3:
                return "\(year)-\(month)-\(components.weekOfMonth!)rd";
            case 4:
                return "\(year)-\(month)-\(components.weekOfMonth!)th";
            default:
                return "\(year)-\(month)-\(components.weekOfMonth!)th";
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - ChartViewDelegate
extension IssueReportLineChartView: ChartViewDelegate {
    
    
}
