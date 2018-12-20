//
//  SecondViewController.swift
//  App
//
//  Created by Zarko Popovski on 11/2/18.
//  Copyright © 2018 App. All rights reserved.
//

import UIKit
import VACalendar

import Alamofire
import PMJSON
import ImageLoader
import SVProgressHUD

class CalendarViewController: UIViewController {
   
    @IBOutlet weak var containerHolder: UIView!
    var calendarView: VACalendarView!
    
    @IBOutlet weak var calendarHover: UIView!
    
    @IBOutlet weak var lblEventType: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    var events:[EventEntity] = [EventEntity]()
    
    var currentEvent:EventEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.title = "Calendar"
        let customFont = UIFont(name: "FreightBigMedium", size: 20.0)
        let customLabel = UILabel()
        customLabel.font = customFont
        customLabel.text = "Calendar"
        
        self.navigationItem.titleView = customLabel
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCalendarDataForEventGesture))
        self.calendarHover.addGestureRecognizer(tapGesture)
        
        self.lblEventType.isHidden = true
        
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        
        calendarView.scrollDirection = .horizontal

        self.containerHolder.addSubview(calendarView)
        
        self.loadEventsData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height * 0.4
            )
            calendarView.setup()
        }
    }
    
    @objc func showCalendarDataForEventGesture() {
        if self.currentEvent != nil {
            self.showCalendarDataForEvent(eventEntity: self.currentEvent!)
        }
    }
    
    func showCalendarDataForEvent(eventEntity:EventEntity) {
        let eventDescriptionVC:EventDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        eventDescriptionVC.eventEntity = eventEntity
        self.navigationController?.pushViewController(eventDescriptionVC, animated: true)
    }
    
    func loadEventsData() {
        SVProgressHUD.show(withStatus: "Loading")
        Alamofire.request(GlobalData.sharedInstance.API_EVENTS).responseString(completionHandler: { (response) in
            SVProgressHUD.dismiss()
            
            let stringResponse = response.result.value!
            
            var jsonData:JSON
            
            do
            {
                let eventsArray = try JSON.decode(stringResponse).getArray()

                if (eventsArray.count) > 0 {
                    for i in 0 ..< (eventsArray.count) {
                        let jsonObj = eventsArray[i]
                        
                        let eventEntity:EventEntity = EventEntity()
                        
                        eventEntity.eventID = try jsonObj.getString("ev_id")
                        eventEntity.eventTitle = try jsonObj.getString("ev_title")
                        eventEntity.eventDescription = try jsonObj.getString("ev_description")
                        eventEntity.eventDate = try jsonObj.getString("ev_date")
                        eventEntity.eventTime = try jsonObj.getString("ev_time")
                        eventEntity.eventLink = try jsonObj.getString("ev_link")
                        eventEntity.eventImage = try jsonObj.getString("ev_image")
                        eventEntity.eventShowMembers = try jsonObj.getString("ev_show_members")
                        eventEntity.eventLocationID = try jsonObj.getString("location_id")
                        eventEntity.eventLocationName = try jsonObj.getString("location_name")
                        eventEntity.eventDivisionID = try jsonObj.getString("division_id")
                        eventEntity.eventDivisionName = try jsonObj.getString("division_name")
                        
                        self.events.append(eventEntity)
                    }
                    
                }
                
                self.setEventsToTheCalendar()
                
            }
            catch
            {
                print("Error:",error)
            }
            
        })
        
    }
    
    func setEventsToTheCalendar() {
        if self.events.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            self.lblEventType.isHidden = false
            
            var eventsTyplesArray:[(Date, [VADaySupplementary])] = [(Date, [VADaySupplementary])]()
            
            for event in self.events {
                let index = event.eventDate.index(of: " ")
                let eventDate = event.eventDate.substring(to: index!)
                
                let date = dateFormatter.date(from: eventDate)
                
                eventsTyplesArray.append((date!, [VADaySupplementary.bottomDots([.red, .red, .red, .red, .red])]))
            }
        
            self.calendarView.setSupplementaries(eventsTyplesArray)
            self.presentTheFirstEvent(evtIndex: 0)
        } else {
            self.lblEventType.isHidden = true
        }
        
        //        calendarView.setSupplementaries([
        //            (Date().addingTimeInterval(-(60 * 60 * 70)), [VADaySupplementary.bottomDots([.red, .magenta])]),
        //            (Date().addingTimeInterval((60 * 60 * 110)), [VADaySupplementary.bottomDots([.red])]),
        //            (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
        //            (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
        //            ])
    }
    
    func presentTheFirstEvent(evtIndex:Int) {
        if self.events.count > 0 {
            let eventEntity:EventEntity = self.events[evtIndex]
            
            self.currentEvent = eventEntity
            
            self.lblEventName.text = eventEntity.eventTitle
            self.lblEventType.text = eventEntity.eventDivisionName
            self.lblEventLocation.text = eventEntity.eventLocationName
            
            let imageURL:String = GlobalData.sharedInstance.API_EVENTS_IMAGES+eventEntity.eventImage
            
            self.imgEvent.load.request(with: URL(string: imageURL)!)
        }
    }
    
    func presentTheEventByEntity(eventEntity: EventEntity) {
        self.lblEventName.text = eventEntity.eventTitle
        self.lblEventType.text = eventEntity.eventDivisionName
        self.lblEventLocation.text = eventEntity.eventLocationName
        
        let imageURL:String = GlobalData.sharedInstance.API_EVENTS_IMAGES+eventEntity.eventImage
        
        self.imgEvent.load.request(with: URL(string: imageURL)!)
    }
    
    func findEventByDate(dateAsString: String) -> EventEntity? {
        var exitElement:EventEntity?
        if self.events.count > 0 {
            for event in self.events {
                let index = event.eventDate.index(of: " ")
                let eventDate = event.eventDate.substring(to: index!)
                
                if dateAsString == eventDate {
                    exitElement = event
                    break
                }
            }
        }
        return exitElement
    }
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage:#imageLiteral(resourceName: "left-arrow"),
                nextButtonImage: #imageLiteral(resourceName: "right-arrow"),
                dateFormatter: dateFormatter
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .short, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
}

extension CalendarViewController: VAMonthHeaderViewDelegate {
    func monthDidChange(_ currentMonth: Date) {
        print(currentMonth)
    }
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension CalendarViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension CalendarViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .square
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension CalendarViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendarView.startDate = dates.last ?? Date()
        print(dates)
        
        if dates.count > 0 {
            let dateToString = dates[0]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newDate: String = dateFormatter.string(from: dateToString)
            print(newDate)
            
            let eventObj = self.findEventByDate(dateAsString: newDate)
            if eventObj != nil {
                self.currentEvent = eventObj
                self.presentTheEventByEntity(eventEntity: eventObj!)
            }
        }
    }
    
}
