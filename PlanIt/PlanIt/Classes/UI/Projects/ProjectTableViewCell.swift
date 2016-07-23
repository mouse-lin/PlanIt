//
//  ProjectTableViewCell.swift
//  PlanIt
//
//  Created by Ken on 16/5/4.
//  Copyright © 2016年 Ken. All rights reserved.
//

import UIKit
@IBDesignable
class ProjectTableViewCell: RoundTableviewCell{
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectStatusLabel: UILabel!
    @IBOutlet weak var projectTagLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var projectNameButton: UIButton!
    @IBOutlet weak var addProcessButton: UIButton!
    
    ///当前项目
    var project: Project!{
        didSet{
            updateUI()
        }
    }
    
    ///是否显示状态
    var isShowState = false{
        didSet{
            if !isShowState{
                projectName = project.name
            }else{
                if project.isFinished == .Finished{
                    return
                }
                switch project.type{
                    //不记录进度
                case .NoRecord:
                    if project.isFinished == .OverTime{
                        let days = project.endTimeDate.compareCurrentTime()
                        projectName = "项目已超出 \(days)"
                    }else if project.isFinished == .NotBegined{
                        let days = project.beginTimeDate.compareCurrentTime()
                        projectName = "距项目开始还有 \(days)"
                    }else{
                        let days = project.endTimeDate.compareCurrentTime()
                        projectName = "项目剩余 \(days)"
                    }
                case .Normal:
                    if project.isFinished == .OverTime{
                        let days = project.endTimeDate.compareCurrentTime()
                        projectName = "项目已超出 \(days)"
                    }else if project.isFinished == .NotBegined{
                        let days = project.beginTimeDate.compareCurrentTime()
                        projectName = "距项目开始还有 \(days)"
                    }else{
                        let days = NSDate().daysToEndDate(project.endTimeDate) + 1
                        projectName = "余下每天需完成 \(Int(project.rest / Double(days))) \(project.unit)"
                    }
                case .Punch:
                    if project.isFinished == .OverTime{
                        let days = project.endTimeDate.compareCurrentTime()
                        projectName = "项目已超出 \(days)"
                    }else if project.isFinished == .NotBegined{
                        let days = project.beginTimeDate.compareCurrentTime()
                        projectName = "距项目开始还有 \(days)"
                    }else{
                        let days = NSDate().daysToEndDate(project.endTimeDate) + 1
                        projectName = "剩余 \(days) 天需打卡 \(Int(project.rest)) 次"
                    }
                default:break
                }
            }
        }
    }
    
    ///当前项目名称
    var projectName: String{
        set{
            projectNameLabel?.text = newValue
        }
        get{
            return (projectNameLabel?.text)!
        }
    }
    ///当前项目状态
    var projectStatus: String{
        set{	
            projectStatusLabel?.text = newValue
        }
        get{
            return (projectStatusLabel?.text)!
        }
    }
    ///当前项目tag
    var projectTag: String{
        set{
            projectTagLabel?.text = newValue
        }
        get{
            return (projectTagLabel?.text)!
        }
    }
    ///项目完成百分比
    var projectPercent = 0.0

    ///更新界面
    func updateUI(){
        projectName = ""
        projectStatus = ""
        projectTag = ""
        projectPercent = 0.0

        if let project = self.project{
            //根据不同状态更改项目名称颜色
            switch(project.isFinished){
            case .NotBegined:
                projectNameLabel?.textColor = notBeginFontColor
            case .NotFinished:
                projectNameLabel?.textColor = notFinishedFontColor
            case .Finished:
                projectNameLabel?.textColor = FinishedFontColor
            case .OverTime:
                projectNameLabel?.textColor = overTimeFontColor
            default:break
            }
            
            projectName = project.name
            projectStatus = "\(project.rest)"
            projectTag = project.tagString
            projectPercent = project.percent
        }
        setNeedsDisplay()
        
    }

}