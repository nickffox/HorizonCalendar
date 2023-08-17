// Created by Bryan Keller on 5/31/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import HorizonCalendar
import UIKit

final class SingleDaySelectionDemoViewController: BaseDemoViewController {

  // MARK: Lifecycle

  required init(monthsLayout: MonthsLayout) {
    super.init(monthsLayout: monthsLayout)
    selectedDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 19))!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Single Day Selection"

    addButton()

    calendarView.daySelectionHandler = { [weak self] day in
      guard let self else { return }

      self.selectedDate = self.calendar.date(from: day.components)

      self.calendarView.setContent(self.makeContent())
    }
  }

  override func makeContent() -> CalendarViewContent {
    let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!

    let selectedDate = self.selectedDate

    return CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: monthsLayout)
      .dayAspectRatio(isTall ? 2 : 1.3)
      .interMonthSpacing(24)
      .verticalDayMargin(8)
      .horizontalDayMargin(8)

      .dayItemProvider { [calendar, dayDateFormatter] day in
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

        let date = calendar.date(from: day.components)
        invariantViewProperties.backgroundShapeDrawingConfig.borderWidth = 1
        invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .gray
        if date == selectedDate {
          invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .blue
          invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .blue.withAlphaComponent(0.15)
        }

        return DayView.calendarItemModel(
          invariantViewProperties: invariantViewProperties,
          content: .init(
            dayText: "\(day.day)",
            accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
            accessibilityHint: nil))
      }
  }

  // MARK: Private

  private var selectedDate: Date?
  private var isTall: Bool = false

  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .green
    button.setTitle("Change Height", for: .normal)
    button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    return button
  }()

  @objc
  private func tappedButton() {
    isTall = !isTall

    let content = makeContent()
    calendarView.setContent(content)

    UIView.animate(withDuration: 0.5) { [weak self] in self?.calendarView.layoutIfNeeded() }
  }

  private func addButton() {
    view.addSubview(button)
    NSLayoutConstraint.activate([
      button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }

}
