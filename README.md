


# 📆 SwiftUICalendar

**SwiftUICalendar** is a beautiful and customizable SwiftUI calendar component.  
It supports **month view**, **week view**, and a **month/year picker**, making it easy to integrate a rich date selection experience in your app.

---

## ✨ Features

- Month and week display modes
- Simple date selection with bindings
- Customizable colors and fonts
- Month/Year picker with wheel-style selection
- Lightweight and purely SwiftUI-based

---

## 📦 Installation

**Swift Package Manager**

1. In **Xcode**, open your project.
2. Go to **File > Add Packages...**
3. Enter the URL of this repository: [https://github.com/codebreaker5163/SwiftUICalendar.git](https://github.com/yourusername/SwiftUICalendar.git)
4. Choose **Up to Next Major Version** and click **Add Package**.

---

## 🎯 Usage

### 1️⃣ Import the library

```swift
import SwiftUICalendar
```
### 2️⃣ Example
Here’s a complete example showing how to use the calendar in a SwiftUI view:
```
import SwiftUI
import SwiftUICalendar

struct ContentView: View {
    @State private var currentDate: Date = .now
    @State private var selectedDate: Date? = nil
    @State private var displayMode: CalendarDisplayMode = .month

    var body: some View {
        CalendarView(
            date: $currentDate,
            selectedDate: $selectedDate,
            displayMode: $displayMode,
            weekDaysColor: .gray,
            weekDaysFont: .system(size: 14, weight: .semibold),
            dateFont: .system(size: 16),
            dateTxtColor: .black,
            backgroundColor: Color(.systemGroupedBackground),
            previousMonthDateColor: .gray.opacity(0.5),
            monthLabelFont: .system(size: 18, weight: .bold)
        )
        .padding()
    }
}
```

### 4️⃣ Selected Date
The **selectedDate** binding tracks which date the user taps.

### 3️⃣ CalendarDisplayMode
You can set:
**.month** – for a month grid
**.week** – for a single week
Switch dynamically if needed.

## 🎨 Customization
You can adjust:
**1. Colors (weekDaysColor, dateTxtColor, previousMonthDateColor, etc.)**
**2. Fonts (weekDaysFont, dateFont, monthLabelFont)**
**3. Background color**
**4. Tint color**
**5. Min/max years for the month/year picker**

## 🛠 Preview Example
```
#Preview {
    CalendarView(
        date: .constant(.now),
        selectedDate: .constant(nil),
        displayMode: .constant(.month),
        weekDaysColor: .blue,
        weekDaysFont: .system(size: 14, weight: .medium),
        dateFont: .system(size: 16),
        dateTxtColor: .primary,
        backgroundColor: .white,
        previousMonthDateColor: .gray.opacity(0.4),
        monthLabelFont: .system(size: 18, weight: .bold)
    )
}
```

## ✅ Requirements

iOS 14+
Swift 5.7+
Xcode 14+

## ✨ Contributing
**Contributions are welcome!**
Feel free to open issues or submit pull requests.

## 🙏 Support
If you need help, open an issue on GitHub.
