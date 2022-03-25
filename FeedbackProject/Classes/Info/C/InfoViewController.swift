//
//  InfoViewController.swift
//  FeedbackProject
//
//  Created by Currie.shen on 2022/2/22.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts
import SwiftUI

class InfoViewController: BaseViewController ,ChartViewDelegate{
    
    let parties = ["1st Qtr", "2nd Qtr", "3rd Qtr", "4th Qtr"]
    private lazy var caregoreTitleLabel: UILabel = {
        let caregoreTitleLabel = UILabel()
        caregoreTitleLabel.text = "Issue By Categary"
        caregoreTitleLabel.textColor = (.black)
        caregoreTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        return caregoreTitleLabel
    }()
    private lazy var typeTitleLabel: UILabel = {
        let typeTitleLabel = UILabel()
        typeTitleLabel.text = "Issue By Type"
        typeTitleLabel.textColor = (.black)
        typeTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        return typeTitleLabel
    }()
    private lazy var barTitleLabel: UILabel = {
        let barTitleLabel = UILabel()
        barTitleLabel.text = "Issue By Assignee"
        barTitleLabel.textColor = (.black)
        barTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        return barTitleLabel
    }()
    private lazy var lineTitleLabel: UILabel = {
        let lineTitleLabel = UILabel()
        lineTitleLabel.text = "Week Income/Resolve/Close Issue Count"
        lineTitleLabel.textColor = (.black)
        lineTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        return lineTitleLabel
    }()

    private lazy var caregorePieChartView: PieChartView = {
        let caregorePieChartView = PieChartView()
        caregorePieChartView.delegate  = self
        caregorePieChartView.backgroundColor = .clear
        caregorePieChartView.drawEntryLabelsEnabled = false
        caregorePieChartView.drawHoleEnabled = false
        caregorePieChartView.highlightPerTapEnabled = false;

        let caregoreL = caregorePieChartView.legend
        caregoreL.horizontalAlignment = .center
        caregoreL.verticalAlignment = .bottom
        caregoreL.orientation = .horizontal
        caregoreL.xEntrySpace = 7
        caregoreL.yEntrySpace = 0
        caregoreL.yOffset = 0
        caregorePieChartView.entryLabelColor = .white
        caregorePieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        caregorePieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        return caregorePieChartView
    }()
    
    private lazy var typechartView: PieChartView = {
        let typechartView = PieChartView()
        typechartView.delegate  = self
        typechartView.backgroundColor = .clear
        typechartView.drawEntryLabelsEnabled = false
        typechartView.drawHoleEnabled = false
        typechartView.highlightPerTapEnabled = false;

        let typechartL = typechartView.legend
        typechartL.horizontalAlignment = .center
        typechartL.verticalAlignment = .bottom
        typechartL.orientation = .horizontal
        typechartL.xEntrySpace = 7
        typechartL.yEntrySpace = 0
        typechartL.yOffset = 0
        typechartView.entryLabelColor = .white
        typechartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        typechartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        return typechartView
    }()

    
    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.delegate  = self
        barChartView.backgroundColor = .clear
        self.view.addSubview(barChartView);
        self.view.backgroundColor = .white
        barChartView.chartDescription?.enabled =  false
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false

//        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
//        marker.chartView = barChartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        barChartView.marker = marker
        let barChartL = barChartView.legend
        barChartL.horizontalAlignment = .center
        barChartL.verticalAlignment = .bottom
        barChartL.orientation = .horizontal
        barChartL.drawInside = false
        barChartL.font = .systemFont(ofSize: 8, weight: .light)
        barChartL.yOffset = 10
        barChartL.xOffset = 10
        barChartL.yEntrySpace = 0

        let xValues = ["Category 1","Category 2","Category 3","Category 4"]
        let xAxis = barChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)



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
        barChartView.scaleYEnabled = false


        self.view.addSubview(linechartView);

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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(caregorePieChartView)
        view.addSubview(caregoreTitleLabel)
        view.addSubview(typechartView)
        view.addSubview(typeTitleLabel)
        view.addSubview(barTitleLabel)
        view.addSubview(barChartView)
        view.addSubview(lineTitleLabel)
        view.addSubview(linechartView)
        self.updateChartData()
    }
    
    func updateChartData() {
        self.setDataCaregoreCount(Int(4), range: UInt32(20))
        self.setDataTypeCount(Int(4), range: UInt32(20))
        self.setDataBarCount(Int(4), range:UInt32(6))
        self.setDataLineCount(Int(5), range: UInt32(100))
    }

    func setDataCaregoreCount(_ count: Int, range: UInt32) {
        
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(20 -  i*4),
                                     label: parties[i % parties.count])
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
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        caregorePieChartView.data = data
        caregorePieChartView.highlightValues(nil)

    }

    func setDataTypeCount(_ count: Int, range: UInt32) {
        
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(20 -  i*3),
                                     label: parties[i % parties.count])
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
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
            
        typechartView.data = data
        typechartView.highlightValues(nil)


    }
    
    func setDataBarCount(_ count: Int, range: UInt32) {
        let groupSpace = 0.10
        let barSpace = 0.05
        let barWidth = 0.25
        // (0.2 + 0.03) * 3 + 0.10 = 1.00 -> interval per "group"

        let randomMultiplier = range

        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
        }
        let yVals1 = (0 ..< count).map(block)
        let yVals2 = (0 ..< count).map(block)
        let yVals3 = (0 ..< count).map(block)

        let set1 = BarChartDataSet(entries: yVals1, label: "Series 1")
        set1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        set1.drawValuesEnabled = false
        let set2 = BarChartDataSet(entries: yVals2, label: "Series 2")
        set2.setColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))
        set2.drawValuesEnabled = false

        let set3 = BarChartDataSet(entries: yVals3, label: "Series 3")
        set3.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
        set3.drawValuesEnabled = false

        let data = BarChartData(dataSets: [set1, set2, set3])
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

        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
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

        let set2 = LineChartDataSet(entries: yVals2, label: "DataSet 2")
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

        let set3 = LineChartDataSet(entries: yVals3, label: "DataSet 3")
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        caregorePieChartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.naviHeight() + 20)
            make.height.equalTo(150)
            make.width.equalTo(CGFloat.screenWidth/2)
        }
        
        caregoreTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(caregorePieChartView.snp.top)
            make.centerX.equalTo(caregorePieChartView.snp.centerX)
        }
        
        typechartView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.naviHeight() + 20)
            make.height.equalTo(150)
            make.width.equalTo(CGFloat.screenWidth/2)
        }
        
        typeTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(typechartView.snp.top)
            make.centerX.equalTo(typechartView.snp.centerX)
        }
        
        barTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(typechartView.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        barChartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(barTitleLabel.snp.bottom)
            make.height.equalTo(120)
            make.width.equalTo(CGFloat.screenWidth)
        }
        
        lineTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(barChartView.snp.bottom)
            make.centerX.equalTo(barChartView.snp.centerX)
        }
        
        linechartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(lineTitleLabel.snp.bottom)
            make.height.equalTo(120)
            make.width.equalTo(CGFloat.screenWidth)
        }

    }


}
