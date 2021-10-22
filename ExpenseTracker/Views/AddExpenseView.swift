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

struct AddExpenseView: View {
  @Environment(\.presentationMode) var presentation
  var saveClosure: (String, Double, Date, String) -> Void

  @State var title: String = ""
  @State var time = Date()
  @State var comment: String = ""
  @State var price: String = ""
  @State var saveDisabled = true
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Text("Title:")
        TextField("Entry Title", text: $title)
          .onChange(of: title) { _ in
            validateNonEmptyFields()
          }
          .padding(.bottom)
        Text("Amount:")
        TextField("Expense Amount", text: $price)
          .keyboardType(.numberPad)
          .onChange(of: price) { _ in
            validateNonEmptyFields()
          }
          .padding(.bottom)
        DatePicker(
          "Time:",
          selection: $time,
          displayedComponents: [.hourAndMinute])
          .padding(.bottom)
        Text("Comment:")
        TextEditor(text: $comment)
      }
      .padding(.all)
      .navigationBarTitle("Add Expense", displayMode: .inline)
      .navigationBarItems(
        leading: Button(action: cancelEntry) {
          Text("Cancel")
        },
        trailing: Button(action: saveEntry) {
          Text("Save")
        }.disabled(saveDisabled))
    }
  }

  func saveEntry() {
    guard let numericPrice = Double(price), numericPrice > 0 else {
      return
    }

    saveClosure(title, numericPrice, time, comment)
    cancelEntry()
  }

  func cancelEntry() {
    presentation.wrappedValue.dismiss()
  }

  func validateNonEmptyFields() {
    guard Double(price) != nil else {
      saveDisabled = true
      return
    }
    saveDisabled = title.isEmpty
  }
}

struct AddExpenseView_Previews: PreviewProvider {
  static var previews: some View {
    AddExpenseView { _, _, _, _ in
    }
  }
}
