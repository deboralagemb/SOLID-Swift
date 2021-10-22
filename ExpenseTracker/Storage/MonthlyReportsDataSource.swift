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

import CoreData
import Combine

class MonthlyReportsDataSource: ObservableObject {
  var viewContext: NSManagedObjectContext

  @Published private(set) var currentEntries: [ExpenseModel] = []

  init(viewContext: NSManagedObjectContext = AppMain.container.viewContext) {
    self.viewContext = viewContext
    prepare()
  }

  func prepare() {
    currentEntries = getEntries()
  }

  private func getEntries() -> [ExpenseModel] {
    let fetchRequest: NSFetchRequest<ExpenseModel> = ExpenseModel.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseModel.date, ascending: false)]
    fetchRequest.predicate = NSPredicate(
      format: "%@ <= date AND date <= %@",
      Date().startOfMonth as CVarArg,
      Date().endOfMonth as CVarArg)
    do {
      let results = try viewContext.fetch(fetchRequest)
      return results
    } catch let error {
      print(error)
      return []
    }
  }

  func saveEntry(title: String, price: Double, date: Date, comment: String) {
    let newItem = ExpenseModel(context: viewContext)
    newItem.title = title
    newItem.date = date
    newItem.comment = comment
    newItem.price = price
    newItem.id = UUID()

    if let index = currentEntries.firstIndex(where: { $0.date ?? Date() < date }) {
      currentEntries.insert(newItem, at: index)
    } else {
      currentEntries.append(newItem)
    }

    try? viewContext.save()
  }

  func delete(entry: ExpenseModel) {
    viewContext.delete(entry)
    try? viewContext.save()
  }
}
