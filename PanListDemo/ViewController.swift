//
//  ViewController.swift
//  PanListDemo
//
//  Created by Quang Minh Trinh on 8/31/16.
//  Copyright © 2016 Quang Minh Trinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var centerXPositionOfInnerView: CGFloat!
    var dataList: [Data] = [Data(id:"0", name: "data 1"), Data(id:"1", name: "data 2"), Data(id:"2", name: "data 3"), Data(id:"3", name: "data 4"), Data(id:"4", name: "data 5"), Data(id:"5", name: "data 6"),Data(id:"6", name: "data 7"),Data(id:"7", name: "data 8"),Data(id:"8", name: "data 9"),Data(id:"9", name: "data 10") ]
    var waitingDataList: [Data] = []
    var listLabel: [ContainDataLabel] = []
    var listWaitingLabel: [ContainDataLabel] = []
    var listTopSpaceConstraints: [NSLayoutConstraint] = []
    var waitingListLeadingSpaceConstraints: [NSLayoutConstraint] = []
    var numberLabelShow: Int = 5
    var numberReadyUpLabel: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var numberLabelCanShow: Int = 0
        if numberLabelShow >= dataList.count {
            numberLabelCanShow = dataList.count
            numberReadyUpLabel = 0
        }
        else {
            numberLabelCanShow = numberLabelShow
            numberReadyUpLabel = dataList.count - numberLabelShow
        }
        for i in 0..<numberLabelCanShow {
            showLabelOfData(index: i)
        }
        for i in numberLabelCanShow..<(numberLabelCanShow + numberReadyUpLabel) {
            let label = ContainDataLabel()
            label.frame = CGRectMake(12,self.view.frame.height - 12 - 40, 100, 40)
            label.text = dataList[i].name
            label.data = dataList[i]
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.backgroundColor = UIColor.orangeColor()
            label.userInteractionEnabled = true
            view.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            let constraints:[NSLayoutConstraint] = [NSLayoutConstraint.init(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100),
                                                    NSLayoutConstraint.init(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
                                                    NSLayoutConstraint.init(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -12)]
            view.addConstraints(constraints)
            let leadingSpaceConstraint = NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 112 * CGFloat(i-numberLabelCanShow) + 12)
            waitingListLeadingSpaceConstraints.append(leadingSpaceConstraint)
            listWaitingLabel.append(label)
            view.addConstraint(leadingSpaceConstraint)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if listLabel.count > 0 {
            centerXPositionOfInnerView = listLabel[0].frame.origin.x + listLabel[0].frame.width/2
        }
    }

    func showLabelOfData(index index: Int) {
        let label = ContainDataLabel()
        label.frame = CGRectMake(12,self.view.frame.height - 12 - 40, 100, 40)
        label.text = dataList[index].name
        label.data = dataList[index]
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.backgroundColor = UIColor.orangeColor()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints:[NSLayoutConstraint] = [NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 12),
                                                NSLayoutConstraint.init(item: label, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: -12),
                                                NSLayoutConstraint.init(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)]
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panView(_:)))
        label.userInteractionEnabled = true
        label.addGestureRecognizer(panGesture)
        view.addConstraints(constraints)
        let topSpaceConstraint = NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 52 * CGFloat(index) + 12)
        listTopSpaceConstraints.append(topSpaceConstraint)
        listLabel.append(label)
        view.addConstraint(topSpaceConstraint)
    }
    @IBAction func panView(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(self.view)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y)
        
        sender.setTranslation(CGPointZero, inView: self.view)
        
        if sender.state == .Ended {
            if abs(sender.view!.frame.origin.x + sender.view!.frame.width/2 - centerXPositionOfInnerView) > sender.view!.frame.width/3 {
                if let label = sender.view as? ContainDataLabel{
                    let index = dataList.indexOf({data in
                        return data.id == label.data.id
                    })
                    UIView.animateWithDuration(0.4, animations: {
                        if sender.view!.frame.origin.x + sender.view!.frame.width/2 < self.centerXPositionOfInnerView {
                            sender.view!.frame.origin.x = -sender.view!.frame.width
                        }
                        else {
                            sender.view!.frame.origin.x = self.view.frame.width
                        }
                        sender.view!.alpha = 0
                        }, completion: { _ in
                            // remove shown element of list
                            sender.view!.removeFromSuperview()
                            self.listLabel.removeAtIndex(index!)
                            self.listTopSpaceConstraints.removeAtIndex(index!)
                            self.dataList.removeAtIndex(index!)
                            if self.listTopSpaceConstraints.count >= index {
                                for i in index!..<self.listTopSpaceConstraints.count {
                                    self.listTopSpaceConstraints[i].constant -= 52
                                }
                                self.view.setNeedsLayout()
                            }
                            if self.dataList.count >= self.numberLabelShow {
                                self.showLabelOfData(index: self.numberLabelShow - 1)
                            }
                            // remove waiting element of list
                            if self.listWaitingLabel.count > 0 {
                                self.listWaitingLabel[0].removeFromSuperview()
                                self.listWaitingLabel.removeAtIndex(0)
                                self.waitingListLeadingSpaceConstraints.removeAtIndex(0)
                                if self.waitingListLeadingSpaceConstraints.count >= 0 {
                                    for i in 0..<self.waitingListLeadingSpaceConstraints.count {
                                        self.waitingListLeadingSpaceConstraints[i].constant -= 112
                                    }
                                    self.view.setNeedsLayout()
                                }
                            }
                           
                            UIView.animateWithDuration(0.2, animations: {
                                self.view.layoutIfNeeded()
                                }, completion: nil)
                    })
                }
                
            }
            else {
                UIView.animateWithDuration(0.3, animations: {
                    sender.view!.frame.origin.x = self.centerXPositionOfInnerView - sender.view!.frame.width/2
                    }, completion: { _ in
                })

            }
        }
    }
}

