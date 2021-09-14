import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    let shapeLayer = CAShapeLayer()
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    var labelHour:Int = 0
    var labelMin:Int = 0
    var labelSec:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        resetButton.setTitleColor(UIColor.gray, for: .normal)
        // let's start by drawing a circle somehow
        
        let center = view.center
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        //
        trackLayer.path = circularPath.cgPath //경로 선언
        
        trackLayer.strokeColor = UIColor.red.cgColor
        trackLayer.lineWidth = 15
    
        
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap))) //탭을 했을 때 작동이 되는 거 같음.
    }
    
//    @objc private func handleTap() { //탭을 했을 때
//        print("Attempting to animate stroke")
//
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") //keypath = 0
//
//        basicAnimation.toValue = 1 //수신기가 보간법을 끝내는 데 사용하는 값을 정의
//
//        basicAnimation.duration = CFTimeInterval(count) //애니메이션의 기본 지속 시간(초)을 지정
//
//        basicAnimation.fillMode = kCAFillModeForwards
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
//    }
    @IBAction func startStopTapped(_ sender: UIButton) {
        if timerCounting {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.green, for: .normal)
            labelHour = 0
            labelMin = 0
            labelSec = 0
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") //keypath = 0
            
            basicAnimation.toValue = 1 //수신기가 보간법을 끝내는 데 사용하는 값을 정의
            
            basicAnimation.duration = CFTimeInterval(count + 2) //애니메이션의 기본 지속 시간(초)을 지정
            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            
            shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            
        } else {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") //keypath = 0
            
            basicAnimation.toValue = 1 //수신기가 보간법을 끝내는 데 사용하는 값을 정의
            
            basicAnimation.duration = CFTimeInterval(count + 2) //애니메이션의 기본 지속 시간(초)을 지정
            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            
            shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        }
    }
    @IBAction func resetTapped(_ sender: UIButton) {
       
            resetButton.setTitle("RESET", for: .normal)
            resetButton.setTitleColor(UIColor.gray, for: .normal)
            self.count = 0
            self.timer.invalidate()
            self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.startStopButton.setTitle("START", for: .normal)
            self.startStopButton.setTitleColor(UIColor.green, for: .normal)
        labelHour = 0
        labelMin = 0
        labelSec = 0
        
    }
    @objc func timerCounter() -> Void
        {
        if count > 0 {
            count = count - 1 //이 함수가 호출될 때마다 count + 1
            let time = secondsToHoursMinutesSeconds(seconds: count) //증가하는 count 값을 secondsToHoursMinutesSeconds함수에 넣고 출력값을 time에 저장
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2) //makeTimeString함수에 time의 첫번째 값을 hours, 두번째 값을 minutes, 세번째 값을 seconds에 넣는다.
            TimerLabel.text = timeString //위에서 선언한 TimerLabel의 text 값에 timerString을 넣어준다.
        } else {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.green, for: .normal)
            labelHour = 0
            labelMin = 0
            labelSec = 0
        }
            
        }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) //초에서 시간 : 분 : 초로 바꾸어주는 함수
        {
            return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60)) //다음과 같은 연산으로 초를 이용해서 시간, 분, 초를 출력
        }
        
        func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String //위에서 만든 시간, 분, 초를 문자열 형태의 디티절 시간으로 출력
        {
            var timeString = ""
            timeString += String(format: "%02d", hours)
            timeString += " : "
            timeString += String(format: "%02d", minutes)
            timeString += " : "
            timeString += String(format: "%02d", seconds)
            return timeString //timeString의 형태 ->hours : minutes : seconds
        }
    @IBAction func plusHour(_ sender: UIButton) {
        count += 3600
        labelHour += 1
        self.TimerLabel.text = self.makeTimeString(hours: labelHour, minutes: labelMin, seconds: labelSec)
    }
    
    @IBAction func plusMin(_ sender: UIButton) {
        count += 60
        labelMin += 1
        self.TimerLabel.text = self.makeTimeString(hours: labelHour, minutes: labelMin, seconds: labelSec)
    }
    @IBAction func plusSec(_ sender: UIButton) {
        count += 1
        labelSec += 1
        self.TimerLabel.text = self.makeTimeString(hours: labelHour, minutes: labelMin, seconds: labelSec)
    }
    @IBAction func minusHour(_ sender: UIButton) {
        
        if count > 3599 {
        count -= 3600
        labelHour -= 1
        self.TimerLabel.text = self.makeTimeString(hours: labelHour, minutes: labelMin, seconds: labelSec)
        }
    }
    @IBAction func minusMin(_ sender: UIButton) {
        if count > 59 {
        count -= 60
        labelMin -= 1
        self.TimerLabel.text = self.makeTimeString(hours: labelHour, minutes: labelMin, seconds: labelSec)
        }
    }
    @IBAction func minusSec(_ sender: UIButton) {
        if count > 0 {
        count -= 1
        labelSec -= 1
        self.TimerLabel.text = self.makeTimeString(hours: labelHour, minutes: labelMin, seconds: labelSec)
        }
    }
}

