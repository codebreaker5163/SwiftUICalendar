//
//  CalendarView.swift
//  ELEXIR_SwiftUI
//
//  Created by Himanshu Sharma on 28/02/24.
//

import SwiftUI

public enum CalendarDisplayMode {
    case month
    case week
}

public struct SwiftUICalendar: View {
    @Binding var date:Date
    @Binding var selectedDate:Date?
    @Binding var displayMode: CalendarDisplayMode
    @State private var days:[Date] = []
    @State private var isYearSelection:Bool = false
    
    var minYear:Int = 1900
    var maxYear:Int = Calendar.current.component(.year, from: Date())
    let weekDaysColor:Color
    let dateSelectionColor:Color
    let weekDaysFont:Font
    let dateFont:Font
    let dateTxtColor:Color
    var backgroundColor:Color = .clear
    let previousMonthDateColor:Color
    private let columns = Array(repeating:GridItem(.flexible()),count:7)
    private let yearColumns = Array(repeating:GridItem(.flexible()),count:3)
    private let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let monthLabelFont:Font
    
    @State private var isShowingCalendar = true
    
    public init(
        date: Binding<Date>,
        selectedDate: Binding<Date?>,
        displayMode: Binding<CalendarDisplayMode>,
        minYear: Int = 1900,
        maxYear: Int = Calendar.current.component(.year, from: Date()),
        weekDaysColor: Color,
        dateSelectionColor: Color,
        weekDaysFont: Font,
        dateFont: Font,
        dateTxtColor: Color,
        backgroundColor: Color = .clear,
        previousMonthDateColor: Color,
        monthLabelFont: Font
    ) {
        _date = date
        _selectedDate = selectedDate
        _displayMode = displayMode
        self.minYear = minYear
        self.maxYear = maxYear
        self.weekDaysColor = weekDaysColor
        self.dateSelectionColor = dateSelectionColor
        self.weekDaysFont = weekDaysFont
        self.dateFont = dateFont
        self.dateTxtColor = dateTxtColor
        self.backgroundColor = backgroundColor
        self.previousMonthDateColor = previousMonthDateColor
        self.monthLabelFont = monthLabelFont
    }
    public var body: some View {
        VStack {
            if isShowingCalendar{
                if isYearSelection {
                    Text("Select Year").font(monthLabelFont).padding(.leading,10).foregroundColor(.black)
                    ScrollView(.vertical) {
                        LazyVGrid(columns: yearColumns) {
                            ForEach(Array(stride(from: maxYear, through: minYear, by: -1)), id: \.self) { year in
                                Text("\(year)")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .foregroundStyle(dateTxtColor)
                                    .font(dateFont)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        date = date.updateCurrentDateYear(year: year)
                                        isYearSelection = false
                                    }
                            }
                        }
                    }
                    .frame(height: 300)
                }else{
                    CalendarMonthDisplay(date: $date, tint: weekDaysColor, monthFont: monthLabelFont, monthDisplayColor: .black, onNextClick: nextTap, onPreClick: preTap, onMonthTap: {
                        isYearSelection = true
                    }).padding(.bottom,25)
                    
                    HStack {
                        ForEach(daysOfWeek.indices,id: \.self){ index in
                            Text(daysOfWeek[index])
                                .foregroundColor(weekDaysColor)
                                .font(weekDaysFont)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    LazyVGrid(columns: columns){
                        ForEach(days,id:\.self){day in
                            if day.monthInt != date.monthInt && displayMode != .week {
                                VStack{
                                    Text(day.formatted(.dateTime.day()))
                                        .font(dateFont)
                                        .foregroundColor(previousMonthDateColor)
                                        .frame(maxWidth: .infinity,minHeight: 30)
                                    HStack{}.frame(width: 24,height: 8).background(Capsule().fill(Color.clear))
                                }
                            }else{
                                ZStack{
                                    if selectedDate == day {
                                        Circle().frame(width:30,height: 30).foregroundStyle(dateSelectionColor)
                                        
                                    }
                                    Text(day.formatted(.dateTime.day()))
                                        .font(dateFont)
                                        .foregroundColor(selectedDate == day ? .white : dateTxtColor)
                                        .frame(maxWidth: .infinity,minHeight: 30)
                                }
                                .onTapGesture {
                                    selectedDate = day
                                }
                            }
                        }
                    }
                }
            }else{
                EmptyView()
            }
        }
        .onAppear{
            updateDays()
        }
        .onChange(of: date) { _ in
            updateDays()
        }
        .onChange(of: displayMode) { _ in
            updateDays()
        }
    }
    
     private func nextTap(){
         if(date < getMaxDate()){
             date = date.nextMonth
             updateDays()
         }
    }
    
    private func getMaxDate() -> Date {
        var components = DateComponents()
        components.year = maxYear
        components.month = 12
        components.day = 31
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private func getMinDate()->Date{
        var components = DateComponents()
            components.year = minYear
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private func preTap(){
        if(date > getMinDate()){
            date = date.preMonth
            updateDays()
        }
    }
    
    private func updateDays() {
        switch displayMode {
        case .month:
            days = date.calendarDisplayDays
        case .week:
            days = date.calendarDisplayWeek
        }
    }
}

private struct CalendarMonthDisplay: View {
    @Binding var date:Date
    let tint:Color
    let monthFont:Font
    let monthDisplayColor:Color
    let onNextClick:() -> Void
    let onPreClick: () -> Void
    let onMonthTap: () -> Void
    var body: some View {
        HStack{
            Button(action:onPreClick){
                Image(systemName: "chevron.left").resizable().scaledToFit().frame(width:20,height:20).foregroundColor(tint)
            }
            Spacer()
            Text(date.monthName+","+String(date.yearName)).font(monthFont).padding(.leading,10).foregroundColor(monthDisplayColor).onTapGesture{
                onMonthTap()
            }
            Spacer()
            Button(action:onNextClick){
                Image(systemName: "chevron.right").resizable().scaledToFit().frame(width:20,height:20).foregroundColor(tint)
            }
        }
        .background(Color.clear)
        .frame(maxWidth: .infinity)
    }
}


