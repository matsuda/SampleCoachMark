//
//  TabBarController.swift
//  SampleTabbar
//
//  Created by Kosuke Matsuda on 2020/12/20.
//

import UIKit

class TabBarController: UITabBarController {

    let maskView = MaskView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addVCs()
        addMask()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        print("screen >>>", UIScreen.main.bounds)
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) {
            print("window", (scene.delegate as! SceneDelegate).window?.frame as Any)
        }
        print("tabBar >>>", tabBar.frame)
        coach(at: 2)
    }
}

extension TabBarController {
    func addVCs() {
        let vcs: [UIViewController] = (0..<4).map { i in
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            vc.tabBarItem = UITabBarItem(title: "\(i)", image: nil, selectedImage: nil)
            return vc
        }
        setViewControllers(vcs, animated: false)
    }
}

extension TabBarController {
    func addMask() {
        view.addSubview(maskView)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        maskView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: maskView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: maskView.bottomAnchor).isActive = true
    }

    func coach(at index: Int) {
        var count = tabBar.items?.count ?? 0

        for sub in tabBar.subviews.reversed() {
            guard sub is UIControl else { continue }

            let rect = sub.convert(sub.bounds, to: self.maskView)
            let point = CGPoint(x: rect.midX, y: rect.midY)

            count -= 1
            guard count == index else { continue }
            let maskFrame = CGRect(x: point.x - 60 / 2, y: point.y - 60 / 2, width: 60, height: 60)
            maskView.mask(to: maskFrame)
            break
        }
    }
}



class MaskView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func mask(to rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd

        let path = UIBezierPath(rect: frame)
        path.move(to: rect.origin)
        let point = CGPoint(x: rect.midX, y: rect.midY)
        path.addArc(withCenter: point, radius: rect.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
