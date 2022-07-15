//
//  CoachMarkService.swift
//  Desiplex
//
//  Created by Bhavesh Chaudhari on 09/07/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit
import Instructions


class CoachMarkService: NSObject, CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
                    withArrow: true,withNextText: false,
                    arrowOrientation: coachMark.arrowOrientation
                )
                coachViews.bodyView.hintLabel.text = "Complete your profile and get free coins"
//                coachViews.bodyView.nextLabel.text =

                return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    

    let coachMarksController = CoachMarksController()
    var coachMarkTextArray: [CoachMarkText]
    var coachMarkViewArray: [UIView]
    weak var fromController: UIViewController?

    init(coachMarkTextArray: [CoachMarkText], coachMarkViewArray: [UIView], fromController: UIViewController, skipButtonTitle: String = "") {

        self.coachMarkTextArray = coachMarkTextArray
        self.coachMarkViewArray = coachMarkViewArray
        self.fromController = fromController
        super.init()

        filterVisitedCoachMark()

//        configureSkip(title: skipButtonTitle)
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        coachMarksController.overlay.allowTouchInsideCutoutPath = true

    }

    private func filterVisitedCoachMark() {
        for coachMark in self.coachMarkTextArray {
            if let isVisited = UserDefaults.standard.value(forKey: coachMark.rawValue) as? Bool, isVisited {
                if let index = self.coachMarkTextArray.firstIndex(of: coachMark) {
                    let isTextIndexValid = coachMarkTextArray.indices.contains(index)
                    if isTextIndexValid {
                        self.coachMarkTextArray.remove(at: index)
                    }
                    let isCoachMarkIndexValid = coachMarkViewArray.indices.contains(index)
                    if isCoachMarkIndexValid {
                        self.coachMarkViewArray.remove(at: index)
                    }
                }
            }
        }
    }

    private func configureSkip(title: String) {
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle(title, for: .normal)
        self.coachMarksController.skipView = skipView
    }

    func startInstruction() {
        guard let fromController = self.fromController else { return }
        self.coachMarksController.start(in: .window(over: fromController))
    }

}

extension CoachMarkService: CoachMarksControllerDelegate  {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return coachMarkTextArray.count
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: coachMarkViewArray[index])
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,withNextText: false,
            arrowOrientation: coachMark.arrowOrientation
        )
        coachViews.bodyView.hintLabel.text = coachMarkTextArray[index].text
//        coachViews.bodyView.nextLabel.text = nil

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    // MARK: Protocol Conformance - CoachMarkControllerDelegate
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willLoadCoachMarkAt index: Int) -> Bool {
        return true
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {
        UserDefaults.standard.set(true, forKey: self.coachMarkTextArray[index].rawValue)
    }
}
