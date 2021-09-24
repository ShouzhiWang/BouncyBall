import Foundation

//size of ball
let ball = OvalShape(width: 40, height: 40)

//shape of funnel
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

var barriers: [Shape] = []

var targets: [Shape] = []


/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

func setup() {
    setupBall()
    
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30,
       height: 15, angle: -0.2)
    addBarrier(at: Point(x: 300, y: 150), width: 100,
               height: 25, angle: 0.3)
    
    setupFunnel()
    
    addTarget(at: Point(x: 150, y: 400))
    addTarget(at: Point(x: 150, y: 380))
    //addTarget(at: Point(x: 333, y: 428))
    addTarget(at: Point(x: 126, y: 327))
    addTarget(at: Point(x: 165, y: 100))
    addTarget(at: Point(x: 133, y: 614))
    addTarget(at: Point(x: 111, y: 474))
    addTarget(at: Point(x: 256, y: 280))
    addTarget(at: Point(x: 151, y: 242))


    
    resetGam()
    
    scene.onShapeMoved = printPosition(of:)
}



fileprivate func setupBall() {
    //add a ball
    ball.position = Point(x: 250, y: 400)
    ball.hasPhysics = true
    ball.fillColor = .blue
    scene.add(ball)
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    
    ball.onTapped = resetGam
    
    ball.bounciness = 0.6
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    //add a barrier
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)
    
    // Existing code from setupBarrier() below.
    barrier.position = position
    barrier.hasPhysics = true
    
    barrier.isImmobile = true
    scene.add(barrier)
    
    barrier.angle = angle
    
}

fileprivate func setupFunnel() {
    //add a funnel
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropball
    funnel.isDraggable = false
}

func addTarget(at position: Point) {
    //add targets
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    
    targets.append(target)
    
    //Existing code from setupTarget() below
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    
    scene.add(target)
    
    target.name = "target"
    target.isDraggable = false
}

//press the funnel to drop ball
func dropball() {
    ball.position = funnel.position
    ball.stopAllMotion()
    for barrier in barriers {
        barrier.isDraggable = false
        for target in targets {
            target.fillColor = .yellow
        }
    }
}

// Resets the game by moving the ball below the scene
// Which will unlock the barriers.
func resetGam() {
    ball.position = Point(x: 0, y: -80)
    print("reseted")
}

// Handles collisions between the ball and the targets
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    
    otherShape.fillColor = .green
}

// Allows user to drag the barrier while the ball exited
func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "You Won!", completion: alertDismissed)
    }
}

func printPosition(of shape: Shape) {
    print("a: \(shape.position)")
}

//Empty function declared for hitTargets()
func alertDismissed() {
    
}
