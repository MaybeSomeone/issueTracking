//
//  FormReportCell.swift
//  FeedbackProject
//
//  Created by peter.wang61235 on 2022/3/17.
//

import UIKit
import Charts

class FormReportCell: UITableViewCell,ChartViewDelegate{


    private lazy var title: UILabel = {
        let title = UILabel()
        title.text = "Participation count: xxxxxx"
        title.textColor = (.black)
        title.font = .systemFont(ofSize: 14, weight: .bold)
        return title
    }()
    private lazy var question: UILabel = {
        let question = UILabel()
        question.text = "Question 1: xxxxxx"
        question.textColor = (.black)
        question.font = .systemFont(ofSize: 14, weight: .bold)
        return question
    }()
    private lazy var chartBgView: UIView = {
        let chartBgView = UIView()
        chartBgView.backgroundColor = .white
        return chartBgView
    }()
    

    private lazy var answerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("By Answer", for: .normal)
        btn.setTitleColor( UIColor(hex: "#84B7FF"), for: .selected)
        btn.setTitleColor(UIColor(hex: "#2D373C"), for: .normal)
        btn.titleLabel?.font = UIFont.font_commonViewTitle
        btn.isSelected = true
        btn.addTarget(self, action: #selector(typeBtnAction(_btn:)), for: .touchUpInside)
        return btn
    }()

    private lazy var typeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("By Type", for: .normal)
        btn.setTitleColor( UIColor(hex: "#84B7FF"), for: .selected)
        btn.setTitleColor(UIColor(hex: "#2D373C"), for: .normal)
        btn.titleLabel?.font = UIFont.font_commonViewTitle
        btn.addTarget(self, action: #selector(typeBtnAction(_btn:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hex: "#84B7FF")
        line.layer.cornerRadius = 1
        line.layer.masksToBounds = true
        return line
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
    
    let xStr = ["1","2","3","4","5","6","7","8","9","10","11"] //x轴类别项
    let values = [38.0, 27.3, 14.1, 18.2,18.0, 27.3, 14.1, 8.2,19.0, 27.3, 29.1] //x轴对应的y轴数据

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .none
        addSubviews()
        setBarChartViewData(xStr, values)

    }
    
    func setBarChartViewData(_ dataPoints: [String], _ values: [Double]) {
           //x轴样式
           let xAxis = barChartView.xAxis
           xAxis.labelPosition = .bottom //x轴的位置
           xAxis.labelFont = .systemFont(ofSize: 10)
           xAxis.drawGridLinesEnabled = false
           xAxis.granularity = 1.0
           xAxis.valueFormatter = self
           xAxis.drawAxisLineEnabled = false
           let xFormatter = IndexAxisValueFormatter()
           xFormatter.values = dataPoints

           var dataEntris: [BarChartDataEntry] = []
           for (idx, _) in dataPoints.enumerated() {
               let dataEntry = BarChartDataEntry(x: Double(idx), y: values[idx])
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
    
    @objc func typeBtnAction(_btn : UIButton) {
        if _btn == answerBtn{
            answerBtn.isSelected = true
            typeBtn.isSelected = false
            line.snp.remakeConstraints { (make) in
                make.centerX.equalTo(answerBtn.snp.centerX)
                make.top.equalTo(answerBtn.snp.bottom).offset(2)
                make.width.equalTo(15)
                make.height.equalTo(2)

            }
        }
        else{
            answerBtn.isSelected = false
            typeBtn.isSelected = true
            line.snp.remakeConstraints { (make) in
                make.centerX.equalTo(typeBtn.snp.centerX)
                make.top.equalTo(answerBtn.snp.bottom).offset(2)
                make.width.equalTo(15)
                make.height.equalTo(2)
            }
        }
    }
    
    func addSubviews() {
        self.contentView.addSubview(title)
        self.contentView.addSubview(question)
        self.contentView.addSubview(chartBgView)
        self.chartBgView.addSubview(answerBtn)
        self.chartBgView.addSubview(typeBtn)
        self.chartBgView.addSubview(line)
        self.chartBgView.addSubview(barChartView)

//        addSubviews([title,question,chartBgView,barChartView])
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        question.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(title.snp.bottom).offset(16)
        }
        chartBgView.snp.makeConstraints { (make) in
            make.top.equalTo(question.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(256)
            make.right.equalToSuperview()
        }
        answerBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        typeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(answerBtn.snp.centerY)
            make.left.equalTo(answerBtn.snp.right).offset(26)
            make.height.equalTo(20)
        }
        line.snp.makeConstraints { (make) in
            make.centerX.equalTo(answerBtn.snp.centerX)
            make.top.equalTo(answerBtn.snp.bottom).offset(2)
            make.width.equalTo(15)
            make.height.equalTo(2)

        }

        barChartView.snp.makeConstraints { (make) in
            make.top.equalTo(chartBgView.snp.top).offset(60)
            make.left.equalTo(chartBgView.snp.left).offset(30)
            make.right.equalTo(chartBgView.snp.right).offset(-30)
            make.bottom.equalTo(chartBgView.snp.bottom).offset(-15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FormReportCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xStr[Int(value) % xStr.count]
    }
}
