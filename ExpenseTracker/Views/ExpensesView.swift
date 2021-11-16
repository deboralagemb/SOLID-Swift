/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import Combine

struct ExpensesView: View {
  @State private var isAddPresented = false
  @ObservedObject var dataSource: ReportReader

  var body: some View {
    VStack {
      List {
        ForEach(dataSource.currentEntries, id: \.id) { item in
          ExpenseItemView(expenseItem: item)
        }
      }
      TotalView(totalExpense: dataSource.currentEntries.reduce(0) { $0 + $1.price })
    }
    .toolbar {
      Button(action: {
        isAddPresented.toggle()
      }, label: {
        Image(systemName: "plus")
      })
    }
    .fullScreenCover(isPresented: $isAddPresented) { () -> AddExpenseView? in
      guard let saveHandler = dataSource as? SaveEntryProtocol else {
        return nil
      }
      return AddExpenseView(saveEntryHandler: saveHandler)
    }
    .onAppear {
      dataSource.prepare()
    }
  }
}

struct ExpensesView_Previews: PreviewProvider {
  static var previews: some View {
    ExpensesView(dataSource: PreviewReportsDataSource())
  }
  
  struct PreviewExpenseEntry: ExpenseModelProtocol {
    var title: String?
    var price: Double
    var comment: String?
    var date: Date?
    var id: UUID? = UUID()
  }
  
  class PreviewReportsDataSource: ReportReader, SaveEntryProtocol {
    override init() {
      super.init()
      for index in 1..<6 {
        _ = saveEntry(
          title: "Test Title \(index)",
          price: Double(index + 1) * 12.3,
          date: Date(timeIntervalSinceNow: Double(index * -60)),
          comment: "Test Comment \(index)")
      }
    }

    override func prepare() {
    }

    func saveEntry(
      title: String,
      price: Double,
      date: Date,
      comment: String
    ) -> Bool {
      let newEntry = PreviewExpenseEntry(
        title: title,
        price: price,
        comment: comment,
        date: date)
      currentEntries.append(newEntry)
      
      return true
    }
  }
}
