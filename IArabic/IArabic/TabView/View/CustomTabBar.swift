//
//  CustomTabBar.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI

struct CustomTabs: View {
    @Binding var selectedIndex: Int
    let tabs: [Tab]

    var body: some View {
        GeometryReader { proxy in
//            let width = proxy.size.width
            HStack {
                ForEach(tabs, id: \.index) { item in
                    Button(action: {
                      
                            self.selectedIndex = item.index
                      
                    }) {
                        TabItemView(item: item, isSelected: self.selectedIndex == item.index)
                    }
                    
                    if item.index != tabs.count - 1 {
                        Spacer(minLength: 0)
                    }
                }
            }
  
//            .background(alignment: .leading) {
//                Circle()
//                    .fill(Color.custom.yellow)
//                    .frame(width: 56, height: 56)
//                    .offset(x: 32.5)
//                    .offset(x: indicatorOffset(with: width))
//            }
        }
        .frame(height: 50)
        .padding(.bottom, 5)
        .padding([.horizontal, .top])
    }
//    
//    func indicatorOffset(with: CGFloat) -> CGFloat {
//        let index = CGFloat(getIndex())
//        if index == 0 {return 0}
//        
//        let buttonWith = with / CGFloat(Tab.allCases.count)
//        
//        return index * buttonWith
//    }
    
//    func getIndex() -> Int {
//        switch tab {
//        case .library:
//            return 0
//        case .wordCards:
//            return 1
//        case .dictionary:
//            return 2
//        }
//    }

}

struct TabItemView<T: TabItemProtocol>: View {
    let item: T
    let isSelected: Bool
    
    var body: some View {
        item.image.renderingMode(.template)
            .font(.system(size: 25))
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? Color.custom.customOrange : Color.custom.lightGray)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
