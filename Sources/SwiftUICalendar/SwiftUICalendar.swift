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
    
    var body: some View {
        VStack {
            if isShowingCalendar{
                CalendarMonthDisplay(date: $date, tint: primaryColor, monthFont: monthLabelFont, monthDisplayColor: .black, onNextClick: nextTap, onPreClick: preTap, onMonthTap: {isShowingCalendar = false}).padding(.bottom,25)
                
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
            }else{
                MonthYearDisplay(date: $date, onConfirmation: {}, confirmBtnFont: .custom(brownRegularFont, size: 20), monthFont: .custom(brownRegularFont, size: 24), yearFont: .custom(brownRegularFont, size: 24),backgroundColor:backgroundColor, tint: primaryColor)
            }
        }
        .onAppear{
            updateDays()
        }
        .onChange(of: date,{ updateDays() })
        .onChange(of: displayMode,{ updateDays() })
    }
    
     private func nextTap(){
         if(date < getMaxDate()){
             date = date.nextMonth
             updateDays()
         }
    }
    
    private func getMaxDate()->Date{
        var components = DateComponents()
            components.year = maxYear
        components.month = Calendar.current.component(.month, from: date)
        components.day = Calendar.current.component(.day, from: date)
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private func getMinDate()->Date{
        var components = DateComponents()
            components.year = minYear
        components.month = Calendar.current.component(.month, from: date)
        components.day = Calendar.current.component(.day, from: date)
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
                Image(systemName: chevronLeft).resizable().scaledToFit().frame(width:20,height:20).foregroundColor(tint)
            }
            Spacer()
            Text(date.monthName+","+String(date.yearName)).font(monthFont).padding(.leading,10).foregroundColor(monthDisplayColor).onTapGesture{
                onMonthTap()
            }
            Spacer()
            Button(action:onNextClick){
                Image(systemName: chevronRight).resizable().scaledToFit().frame(width:20,height:20).foregroundColor(tint)
            }
        }
        .background(Color.clear)
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    CalendarMonthDisplay(date: Binding.constant(Date.now), tint:primaryColor,monthFont: .custom(brownRegularFont, size: 20),monthDisplayColor: .black, onNextClick: {}, onPreClick: {},onMonthTap: {})
}


private struct MonthYearDisplay: View {
    @Binding var date:Date
    @State var selectedMonth:Int = 1
    @State var selectedYear:Int = 2000
    let onConfirmation:() -> Void
    let confirmBtnFont:Font
    let monthFont:Font
    let yearFont:Font
    var backgroundColor:Color = .clear
    var tint:Color = .black
    var minYear:Int = 1900
    var maxYear:Int = Calendar.current.component(.year, from: Date())
    private let months = Calendar.current.monthSymbols
    var body: some View {
        VStack{
            HStack {
                // Month picker
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { index in
                        Text(months[index - 1]).tag(index).foregroundColor(tint)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                
                let years = Array(minYear...maxYear)
                // Year picker
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year).foregroundStyle(tint)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 200)
            .onAppear{
                selectedMonth = Calendar.current.component(.month, from: date)
                selectedYear = Calendar.current.component(.year, from: date)
            }
            Button(action: {
                var components = DateComponents()
                    components.year = selectedYear
                    components.month = selectedMonth
                components.day = Calendar.current.component(.day, from: date)
                date = Calendar.current.date(from: components) ?? Date.now
                onConfirmation()
                
            }){
                HStack(spacing:0){
                    Spacer()
                    Text("Confirm").font(confirmBtnFont).foregroundColor(.white).padding(.leading,10)
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(tint, lineWidth: 1)
            )
            .background(tint)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

