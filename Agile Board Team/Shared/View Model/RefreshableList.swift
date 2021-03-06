//
//  RefreshableList.swift
//  Agile Board Team
//
//  Created by Huynh Tan Phu on 4/22/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

//import SwiftUI

//public struct RefreshableList<Content>: View where Content: View {
    //@Binding public var showRefreshView: Bool
    //@State var pullStatus: CGFloat = 0.0
    //let content: () -> Content
    //let displayMode: NavigationDisplayMode
   // var threshold: CGFloat = 100.0
    
//    @State var previousScrollOffset: CGFloat = 0
//    @State  var scrollOffset: CGFloat = 0
//    @State  var frozen: Bool = false
    //var action: Action = Action()
//    @State  var onDrag: Bool = false
    
//    public init(showRefreshView: Binding<Bool>, @ViewBuilder content:  @escaping () -> Content) {
//        self._showRefreshView = showRefreshView
//        self.content = content
        //self.displayMode = displayMode
        
        //UITableView.appearance().separatorColor = .clear
//    }
    
//    public var body: some View {
       
        //ZStack(alignment: .top) {
            //List {
//                MovingView()
//                if self.showRefreshView && self.frozen && self.displayMode == .inline {
//                    EmptyRow()
//                }
                //self.content()
//                Color
//                    .clear
//                    .frame(height: 0)
//                    .onAppear {
//                        // only perform the action when scrolling.
//                        if self.scrollOffset < 0 { self.action.onLast?() }
//                }
            //}
            //.background(FixedView())
            //.environment(\.defaultMinListRowHeight, 0)
//            .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
//                self.refreshLogic(values: values)
//            }
//            .gesture(
//                DragGesture()
//                    .onChanged({ (value) in
//                        self.onDrag = true
//                    })
//            )
            
//            PullToRefreshView(showRefreshView: $showRefreshView, pullStatus: $pullStatus)
//                .offset(y: self.displayMode == .large ? -90 : 0)
//                .frame(height: self.scrollOffset > 0 || self.showRefreshView ? 60 : 0)
      // }
    //}
    
//    func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
//        DispatchQueue.main.async {
//            guard self.onDrag else { return }
//
//            // Calculate scroll offset
//            let movingBounds = values.first { $0.vType == .movingView }?.bounds ?? .zero
//            let fixedBounds = values.first { $0.vType == .fixedView }?.bounds ?? .zero
//
//            // 6 is the list top padding
//            self.scrollOffset  = movingBounds.minY - fixedBounds.minY - 6
//            self.pullStatus = self.scrollOffset / 100
//
//            // Crossing the threshold on the way down, we start the refresh process
//            if !self.showRefreshView && (self.scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
//                self.showRefreshView = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    //self.action.onRefresh?()
//                    self.onDrag = false
//                    self.pullStatus = 0.0
//                }
//            }
//
//            if self.showRefreshView {
//                // Crossing the threshold on the way up, we add a space at the top of the scrollview
//                if self.previousScrollOffset > self.threshold && self.scrollOffset <= self.threshold {
//                    self.frozen = true
//                }
//            } else {
//                // remove the first empty row inside the list view.
//                self.frozen = false
//            }
//
//            // Update last scroll offset
//            self.previousScrollOffset = self.scrollOffset
//        }
//    }
//}

//struct Spinner: View {
//    @Binding var percentage: CGFloat
//    var body: some View {
//        GeometryReader { proxy in
//            ZStack {
//                ForEach(1...12, id: \.self) { i in
//                    Rectangle()
//                        .fill(Color.gray)
//                        .cornerRadius(1)
//                        .frame(width: proxy.frame(in: .local).width/12, height: proxy.frame(in: .local).height/4)
//                        .opacity(self.percentage * 12 >= CGFloat(i) ? Double(i)/12 : 0)
//                        .offset(y: -proxy.frame(in: .local).width/3)
//                        .rotationEffect(.degrees(Double(30 * i)), anchor: .center)
//                }
//            }
//        }.frame(width: 40, height: 40)
//    }
//}
//
//struct RefreshView2: View {
//    @Binding var isRefreshing:Bool
//    @Binding var status: CGFloat
//    @State var scale: CGFloat = 1.0
//    var body: some View {
//        ZStack{
//            if (!isRefreshing) {
//                withAnimation(Animation.default.delay(1)) {
//                     Spinner(percentage: $status)
//                }
//            }
//            ActivityIndicator(isAnimating: .constant(true), style: .large)
//                .scaleEffect(self.isRefreshing ? 1 : 0.1)
//                .opacity(self.isRefreshing ? 1 : 0)
//                .animation(self.isRefreshing ? nil : .easeInOut)
//        }
//    }
//}
//
//struct EmptyRow: View {
//    var body: some View {
//        Color.clear
//            .frame(height: 60)
//    }
//}
//
//struct PullToRefreshView: View {
//    @Binding var showRefreshView: Bool
//    @Binding var pullStatus: CGFloat
//
//    var body: some View {
//        RefreshView2(isRefreshing: self.$showRefreshView, status: self.$pullStatus)
//    }
//}
//
//struct FixedView: View {
//    var body: some View {
//        GeometryReader { proxy in
//            Color
//                .clear
//                .preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
//        }
//    }
//}
//
//struct MovingView: View {
//    var body: some View {
//        GeometryReader { proxy in
//            Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
//        }.frame(height: 0)
//    }
//}
//
//struct ActivityIndicator: UIViewRepresentable {
//
//    @Binding var isAnimating: Bool
//    let style: UIActivityIndicatorView.Style
//
//    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
//        return UIActivityIndicatorView(style: style)
//    }
//
//    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
//        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
//    }
//}
//
//struct RefreshableKeyTypes {
//    enum ViewType: Int {
//        case movingView
//        case fixedView
//    }
//
//    struct PrefData: Equatable {
//        let vType: ViewType
//        let bounds: CGRect
//    }
//
//    struct PrefKey: PreferenceKey {
//        static var defaultValue: [PrefData] = []
//
//        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
//            value.append(contentsOf: nextValue())
//        }
//
//        typealias Value = [PrefData]
//    }
//}
//
//public enum NavigationDisplayMode {
//    case inline
//    case large
//}

//extension RefreshableList {
//    /**
//     Performs an action when scrolling to the last row
//     - Parameter action: a closure need to be performed
//     */
//    public func onLastPerform(_ action: @escaping () -> Void) -> RefreshableList {
//        self.action.onLast = action
//        return self
//    }
//    
//    /**
//    Performs an action when refresing the list
//    - Parameter action: a closure need to be performed
//    */
//    public func onRefreshPerform(_ action: @escaping () -> Void) -> RefreshableList {
//        self.action.onRefresh = action
//        return self
//    }
//}

//class Action {
//    var onLast: (()-> Void)?
//    var onRefresh: (()->Void)?
//}
