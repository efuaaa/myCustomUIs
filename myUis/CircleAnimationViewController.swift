//
//  CircleAnimationViewController.swift
//

import UIKit

class CircleAnimationViewController: UIViewController, URLSessionDownloadDelegate {

    
    var shapeLayer: CAShapeLayer!
    var shapeLayer2: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    let percentageLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    let countingLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
   
    
    @objc private func handleEnterForeground(){
        animatePulsatingLayer()
    }
    
    private func setupNotificationObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor:UIColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.lineWidth = 20
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = view.center
        return layer
    }
    
    private func createCircleShapeLayer2(strokeColor: UIColor, fillColor:UIColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero , radius: 100, startAngle: 3/4*CGFloat.pi, endAngle:  1/4*CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.lineWidth = 20
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position =  CGPoint(x:190, y:150)
       
        return layer
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setupCircleLayers()
        setupPercentageLabel()
        setupNotificationObservers()
        view.backgroundColor = UIColor.backgroundColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        view.addSubview(countingLabel)
        countingLabel.frame = CGRect(origin: CGPoint(x:130, y:135), size:CGSize(width: 120, height: 30))
        // create my CADisplayLink here
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.default)
       
    }
    
    private func setupPercentageLabel()
    {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x:0, y:0, width: 100, height: 100)
        percentageLabel.center = view.center
        
    }
    
    private func setupCircleLayers()
    {
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        let trackLayer2 = createCircleShapeLayer2(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer2)
        shapeLayer2 =  createCircleShapeLayer2(strokeColor: .outlineStrokeColor, fillColor: .clear)
         shapeLayer2.strokeEnd = 0
         view.layer.addSublayer(shapeLayer2)
    }
    
    var displayLink: CADisplayLink?
    
    var startValue: Double = 0
    let endValue: Double = 22500
    let animationDuration: Double = 3.5
    
    let animationStartDate = Date()
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            self.countingLabel.text = "\(endValue)"
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.countingLabel.text = "\(value)"
            self.shapeLayer2.strokeEnd = CGFloat(percentage)
        }
    }
    private func animatePulsatingLayer()
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    let urlString = "https://www.pexels.com/photo/1527009/download/?search_query=&tracking_id=jfyk0sm1gxc"
//     let urlString = "https://archive.org/download/bliptv-20131031-134713-Bradfordmediagroup-BestChickenRecipe777/bliptv-20131031-134713-Bradfordmediagroup-BestChickenRecipe777.mp4"
    
    
    
    private func beginDownloadingFile(){
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished downloading file")
    }
    
    
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic2")
    }
    
    @objc private func handleTap()
    {
        beginDownloadingFile()
    }
    

   

}
