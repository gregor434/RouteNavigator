//
//  NavigationViewModel.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 06.05.22.
//

import Foundation
import MapKit
import SwiftUI

class NavigationViewModel: ObservableObject {
        
    private let navigationModel = NavigationModel()
    
    // All navigation points
    @Published var navigationPoints: [NavigationPoint]
    
    // Current navigation point
    @Published var mapLocation: NavigationPoint {
        didSet {
            updateMapRegion(navigationPoint: mapLocation)
        }
    }
    
    // Two set points
    @Published var navigationTouple: (startPoint: NavigationPoint, targetPoint: NavigationPoint)?
    private var startPoint: Bool = true
    @Published var targetPoint: Bool = false
    @Published var navigationText: String = "Start point"
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
    // Show list of navigation points
    @Published var showNavigationList: Bool = false
    
    init() {
        let navigationPoints = navigationModel.getNavigationPoints()!
        self.navigationPoints = navigationPoints
        self.mapLocation = navigationPoints.first!
        
        self.updateMapRegion(navigationPoint: navigationPoints.first!)
    }
    
    private func updateMapRegion(navigationPoint: NavigationPoint) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: navigationPoint.coordinate,
                span: mapSpan)
        }
    }
    
    func toggleNavigationList() {
        withAnimation(.easeInOut) {
            showNavigationList.toggle()
        }
    }
    
    func showNextNavigationPoint(navigationPoint: NavigationPoint) {
        withAnimation(.easeInOut) {
            mapLocation = navigationPoint
            showNavigationList = false
        }
    }
    
    func nextButtonPressed() {
        // Get the current index
        guard let currentIndex = navigationPoints.firstIndex(where: { $0 == mapLocation }) else {return}
        
        // Check if nextIndex is valid
        let nextIndex = currentIndex + 1
        guard navigationPoints.indices.contains(nextIndex) else {
            // nextIndex is NOT valid
            // Restart from 0
            guard let firstNavigationPoint = navigationPoints.first else {return}
            showNextNavigationPoint(navigationPoint: firstNavigationPoint)
            return
        }
        // nextIndex is valid
        let nextNavigationPoint = navigationPoints[nextIndex]
        showNextNavigationPoint(navigationPoint: nextNavigationPoint)
    }
    
    func setPointButtonPressed() {
        // Get current navigation point
        let currentPoint = mapLocation
        
        if !startPoint {
            navigationTouple?.targetPoint = currentPoint
            targetPoint = true
            print("Target: \(currentPoint.id)")
        }
        else {
            navigationTouple?.startPoint = currentPoint
            startPoint = false
            navigationText = "Target point"
            print("Start: \(currentPoint.id)")
        }
        
        
    }
    
}