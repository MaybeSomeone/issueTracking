//
//  FormReportCell.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/17.
//

import UIKit
import Charts

class FormReportCell: UITableViewCell,ChartViewDelegate{
    var xStr : [String]?
    var values : [Double]?

    private lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = (.black)
        title.font = .systemFont(ofSize: 14, weight: .bold)
        title.numberOfLines = 0
        return title
    }()
    private lazy var question: UILabel = {
        let question = UILabel()
        question.textColor = (.black)
        question.font = .systemFont(ofSize: 14, weight: .bold)
        question.numberOfLines = 0

        return question
    }()
    private lazy var chartBgView: UIView = {
        let chartBgView = UIView()
        chartBgView.backgroundColor = .white
        return chartBgView
    }()
    

    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.noDataText = "暂无统计数据" //无数据的时候显示
        barChartView.chartDescription?.enabled = false //是否显示描述
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false

        barChartView.leftAxis.drawGridLinesEnabled = false //左侧y轴设置，不画线
        barChartView.rightAxis.drawGridLinesEnabled = false //右侧y轴设置，不画线
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.legend.enabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false;

        return barChartView
    }()
    
    private lazy var pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.delegate  = self
        pieChartView.backgroundColor = .clear
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.highlightPerTapEnabled = false;
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
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .none

    }
    
    var labelTitle: String? {
        didSet {
            title.text = "Participation count: \(labelTitle ?? "")"
            self.contentView.addSubview(title)
            title.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    
    }

    func setBarChartViewData(_ dataPoints: [String], _ values: [String], _title : String) {
        
        question.text = "Question 2: \(_title)"
        self.contentView.addSubview(question)
        self.contentView.addSubview(chartBgView)
        self.contentView.addSubview(barChartView)
        question.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }
        chartBgView.snp.makeConstraints { (make) in
            make.top.equalTo(question.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(256)
            make.right.equalToSuperview()
        }
        barChartView.snp.makeConstraints { (make) in
            make.top.equalTo(chartBgView.snp.top).offset(60)
            make.left.equalTo(chartBgView.snp.left).offset(30)
            make.right.equalTo(chartBgView.snp.right).offset(-30)
            make.bottom.equalTo(chartBgView.snp.bottom).offset(-15)
        }
           //x轴样式
           let xAxis = barChartView.xAxis
           xAxis.labelPosition = .bottom //x轴的位置
           xAxis.labelFont = .systemFont(ofSize: 10)
           xAxis.drawGridLinesEnabled = false
           xAxis.granularity = 1.0
           xAxis.drawAxisLineEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
           var dataEntris: [BarChartDataEntry] = []
           for (idx, _) in dataPoints.enumerated() {
               var num = 0
               for str in values{
                   if str == dataPoints[idx]{
                       num = num+1
                   }
               }
               let dataEntry = BarChartDataEntry(x: Double(idx), y: Double(num))
               dataEntris.append(dataEntry)
           }
        let chartDataSet = BarChartDataSet(entries: dataEntris, label: "")
           let color = UIColor(hex: "#84B7FF")
           chartDataSet.drawValuesEnabled = false
           chartDataSet.colors = [color, color, color, color, color]
           let chartData = BarChartData(dataSet: chartDataSet)
           chartData.barWidth = 0.7
           self.barChartView.data = chartData
           self.barChartView.animate(yAxisDuration: 0.4)
       }
    
    func setDataCount(_ dataPoints: [String], _ values: [String], _title : String) {
        
        self.contentView.addSubview(question)
        self.contentView.addSubview(chartBgView)
        self.contentView.addSubview(pieChartView)
        question.text = "Question 1: \(_title)"
        question.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }
        chartBgView.snp.makeConstraints { (make) in
            make.top.equalTo(question.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(256)
            make.right.equalToSuperview()
        }
        pieChartView.snp.makeConstraints { (make) in
            make.top.equalTo(chartBgView.snp.top)
            make.left.equalTo(chartBgView.snp.left)
            make.right.equalTo(chartBgView.snp.right)
            make.bottom.equalTo(chartBgView.snp.bottom)
        }
        let entries = (0..<dataPoints.count).map { (i) -> PieChartDataEntry in
            var num = 0
            for str in values{
                if str == dataPoints[i]{
                    num = num+1
                }
            }
            return PieChartDataEntry(value: Double(num),
                                     label:dataPoints[i])
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
    

    func settextCount(_ title:Int) {
        
    }

    
//    func addSubviews() {
//        self.contentView.addSubview(title)
//        self.contentView.addSubview(question)
//        self.contentView.addSubview(chartBgView)
//        self.chartBgView.addSubview(barChartView)
//        self.contentView.addSubview(title)
//
//        title.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.top.equalToSuperview().offset(10)
//        }
//        question.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.top.equalTo(title.snp.bottom).offset(16)
//        }
//        chartBgView.snp.makeConstraints { (make) in
//            make.top.equalTo(question.snp.bottom).offset(10)
//            make.left.equalToSuperview()
//            make.height.equalTo(256)
//            make.right.equalToSuperview()
//        }
//        barChartView.snp.makeConstraints { (make) in
//            make.top.equalTo(chartBgView.snp.top).offset(60)
//            make.left.equalTo(chartBgView.snp.left).offset(30)
//            make.right.equalTo(chartBgView.snp.right).offset(-30)
//            make.bottom.equalTo(chartBgView.snp.bottom).offset(-15)
//        }
//
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

