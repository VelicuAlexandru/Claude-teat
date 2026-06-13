import UIKit
import QuartzCore

class MonkeyView: UIView {

    // MARK: - Animation state
    private var rightArmAngle: CGFloat = 0  // radians, negative = arm raised
    private var leftArmAngle:  CGFloat = 0  // radians, positive = arm raised

    private var rightWaveLink: CADisplayLink?
    private var leftWaveLink:  CADisplayLink?
    private var rightWaveStart: CFTimeInterval = 0
    private var leftWaveStart:  CFTimeInterval = 0
    private let waveDuration:   CFTimeInterval = 1.8

    // MARK: - Colors
    private let brownDark  = UIColor(red: 93/255,  green: 58/255,  blue: 26/255,  alpha: 1)
    private let brownMid   = UIColor(red: 139/255, green: 94/255,  blue: 60/255,  alpha: 1)
    private let skinFace   = UIColor(red: 212/255, green: 149/255, blue: 106/255, alpha: 1)
    private let skinInner  = UIColor(red: 240/255, green: 184/255, blue: 138/255, alpha: 1)
    private let earInner   = UIColor(red: 232/255, green: 149/255, blue: 122/255, alpha: 1)
    private let bgTop      = UIColor(red: 26/255,  green: 58/255,  blue: 47/255,  alpha: 1)
    private let bgBot      = UIColor(red: 13/255,  green: 35/255,  blue: 24/255,  alpha: 1)
    private let leafGreen  = UIColor(red: 46/255,  green: 125/255, blue: 50/255,  alpha: 1)
    private let leafLight  = UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1)
    private let noseColor  = UIColor(red: 160/255, green: 82/255,  blue: 45/255,  alpha: 1)
    private let mouthColor = UIColor(red: 139/255, green: 58/255,  blue: 58/255,  alpha: 1)
    private let eyeBrown   = UIColor(red: 92/255,  green: 64/255,  blue: 51/255,  alpha: 1)
    private let pupilColor = UIColor(red: 26/255,  green: 26/255,  blue: 46/255,  alpha: 1)
    private let vineGreen  = UIColor(red: 27/255,  green: 94/255,  blue: 32/255,  alpha: 1)

    // MARK: - Public API

    func waveRight() {
        rightWaveStart = CACurrentMediaTime()
        rightWaveLink?.invalidate()
        let link = CADisplayLink(target: self, selector: #selector(tickRight))
        link.add(to: .main, forMode: .common)
        rightWaveLink = link
    }

    func waveLeft() {
        leftWaveStart = CACurrentMediaTime()
        leftWaveLink?.invalidate()
        let link = CADisplayLink(target: self, selector: #selector(tickLeft))
        link.add(to: .main, forMode: .common)
        leftWaveLink = link
    }

    @objc private func tickRight() {
        let t = CGFloat(min((CACurrentMediaTime() - rightWaveStart) / waveDuration, 1.0))
        // 3 half-sine bumps: |sin(t·3π)| → arm goes up three times
        rightArmAngle = t < 1 ? -abs(sin(t * .pi * 3)) * (65 * .pi / 180) : 0
        if t >= 1 { rightWaveLink?.invalidate(); rightWaveLink = nil }
        setNeedsDisplay()
    }

    @objc private func tickLeft() {
        let t = CGFloat(min((CACurrentMediaTime() - leftWaveStart) / waveDuration, 1.0))
        leftArmAngle = t < 1 ?  abs(sin(t * .pi * 3)) * (65 * .pi / 180) : 0
        if t >= 1 { leftWaveLink?.invalidate(); leftWaveLink = nil }
        setNeedsDisplay()
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        let cx = rect.midX
        let cy = rect.midY
        let s  = min(rect.width, rect.height) / 400

        drawBackground(rect)
        drawLeaves(cx: cx, cy: cy, s: s)
        drawBody(cx: cx, cy: cy, s: s)
        drawHead(cx: cx, cy: cy, s: s)
        drawEars(cx: cx, cy: cy, s: s)
        drawFace(cx: cx, cy: cy, s: s)
        drawEyes(cx: cx, cy: cy, s: s)
        drawNose(cx: cx, cy: cy, s: s)
        drawMouth(cx: cx, cy: cy, s: s)
        drawFur(cx: cx, cy: cy, s: s)
    }

    private func drawBackground(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let colors = [bgTop.cgColor, bgBot.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: colors, locations: [0, 1])!
        ctx.drawLinearGradient(gradient,
                               start: CGPoint(x: rect.midX, y: rect.minY),
                               end:   CGPoint(x: rect.midX, y: rect.maxY),
                               options: [])
    }

    private func drawLeaves(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        drawLeaf(at: CGPoint(x: cx - 160*s, y: cy - 150*s), size: 80*s, angleDeg: -30,  color: leafGreen)
        drawLeaf(at: CGPoint(x: cx + 160*s, y: cy - 150*s), size: 80*s, angleDeg: 210,  color: leafGreen)
        drawLeaf(at: CGPoint(x: cx - 170*s, y: cy + 100*s), size: 70*s, angleDeg: 20,   color: leafLight)
        drawLeaf(at: CGPoint(x: cx + 170*s, y: cy + 100*s), size: 70*s, angleDeg: 160,  color: leafLight)
        drawLeaf(at: CGPoint(x: cx,          y: cy - 200*s), size: 60*s, angleDeg: 90,  color: leafGreen)
    }

    private func drawLeaf(at pt: CGPoint, size: CGFloat, angleDeg: CGFloat, color: UIColor) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.saveGState()
        ctx.translateBy(x: pt.x, y: pt.y)
        ctx.rotate(by: angleDeg * .pi / 180)

        let leaf = UIBezierPath()
        leaf.move(to: .zero)
        leaf.addCurve(to: CGPoint(x: 0, y: -size),
                      controlPoint1: CGPoint(x: -size*0.4, y: -size*0.3),
                      controlPoint2: CGPoint(x: -size*0.6, y: -size*0.8))
        leaf.addCurve(to: .zero,
                      controlPoint1: CGPoint(x:  size*0.6, y: -size*0.8),
                      controlPoint2: CGPoint(x:  size*0.4, y: -size*0.3))
        color.setFill(); leaf.fill()

        let vein = UIBezierPath()
        vein.move(to: .zero)
        vein.addLine(to: CGPoint(x: 0, y: -size*0.85))
        vineGreen.setStroke(); vein.lineWidth = 1.5; vein.stroke()

        ctx.restoreGState()
    }

    private func drawBody(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        brownDark.setFill()
        UIBezierPath(roundedRect: CGRect(x: cx-55*s, y: cy+60*s, width: 110*s, height: 130*s),
                     cornerRadius: 35*s).fill()
        brownMid.setFill()
        UIBezierPath(roundedRect: CGRect(x: cx-30*s, y: cy+70*s, width: 60*s, height: 100*s),
                     cornerRadius: 25*s).fill()

        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        // Left arm – rotates clockwise (positive) to raise
        let lsx = cx - 55*s, lsy = cy + 80*s
        ctx.saveGState()
        ctx.translateBy(x: lsx, y: lsy)
        ctx.rotate(by: leftArmAngle)
        ctx.translateBy(x: -lsx, y: -lsy)
        drawArm(x: lsx, y: lsy, s: s, isLeft: true)
        ctx.restoreGState()

        // Right arm – rotates counter-clockwise (negative) to raise
        let rsx = cx + 55*s, rsy = cy + 80*s
        ctx.saveGState()
        ctx.translateBy(x: rsx, y: rsy)
        ctx.rotate(by: rightArmAngle)
        ctx.translateBy(x: -rsx, y: -rsy)
        drawArm(x: rsx, y: rsy, s: s, isLeft: false)
        ctx.restoreGState()
    }

    private func drawArm(x: CGFloat, y: CGFloat, s: CGFloat, isLeft: Bool) {
        let d: CGFloat = isLeft ? -1 : 1

        brownDark.setFill()
        let arm = UIBezierPath()
        arm.move(to: CGPoint(x: x, y: y))
        arm.addCurve(to: CGPoint(x: x + d*55*s, y: y + 110*s),
                     controlPoint1: CGPoint(x: x + d*40*s, y: y + 10*s),
                     controlPoint2: CGPoint(x: x + d*70*s, y: y + 60*s))
        arm.addCurve(to: CGPoint(x: x + d*25*s, y: y + 105*s),
                     controlPoint1: CGPoint(x: x + d*50*s, y: y + 125*s),
                     controlPoint2: CGPoint(x: x + d*30*s, y: y + 120*s))
        arm.addCurve(to: CGPoint(x: x, y: y),
                     controlPoint1: CGPoint(x: x + d*35*s, y: y + 55*s),
                     controlPoint2: CGPoint(x: x + d*10*s, y: y + 10*s))
        arm.close(); arm.fill()

        // Hand
        brownMid.setFill()
        let hcx = x + d*52*s, hcy = y + 115*s
        UIBezierPath(ovalIn: CGRect(x: hcx-14*s, y: hcy-14*s, width: 28*s, height: 28*s)).fill()
        for i in -1...2 {
            let fcx = x + d*(48 + CGFloat(i)*7)*s
            UIBezierPath(ovalIn: CGRect(x: fcx-5*s, y: y+97*s, width: 10*s, height: 10*s)).fill()
        }
    }

    private func drawHead(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        brownMid.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx-100*s, y: cy-130*s, width: 200*s, height: 200*s)).fill()
        brownDark.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx-100*s, y: cy-130*s, width: 200*s, height: 100*s)).fill()
        brownMid.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx-80*s,  y: cy-120*s, width: 160*s, height: 100*s)).fill()
    }

    private func drawEars(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        for side: CGFloat in [-1, 1] {
            let ex = cx + side*95*s, ey = cy - 40*s
            brownMid.setFill()
            UIBezierPath(ovalIn: CGRect(x: ex-28*s, y: ey-28*s, width: 56*s, height: 56*s)).fill()
            earInner.setFill()
            UIBezierPath(ovalIn: CGRect(x: ex-16*s, y: ey-16*s, width: 32*s, height: 32*s)).fill()
        }
    }

    private func drawFace(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        skinFace.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx-70*s, y: cy-60*s, width: 140*s, height: 115*s)).fill()
        skinInner.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx-38*s, y: cy+5*s,  width: 76*s,  height: 50*s)).fill()
    }

    private func drawEyes(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        let eyeY = cy - 25*s
        for side: CGFloat in [-1, 1] {
            let ex = cx + side*30*s
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: ex-16*s, y: eyeY-16*s, width: 32*s, height: 32*s)).fill()
            eyeBrown.setFill()
            UIBezierPath(ovalIn: CGRect(x: ex-12*s, y: eyeY-12*s, width: 24*s, height: 24*s)).fill()
            pupilColor.setFill()
            UIBezierPath(ovalIn: CGRect(x: ex-7*s,  y: eyeY-7*s,  width: 14*s, height: 14*s)).fill()
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: ex+1*s,  y: eyeY-5*s,  width: 6*s,  height: 6*s)).fill()
            UIBezierPath(ovalIn: CGRect(x: ex-4*s,  y: eyeY+3*s,  width: 3*s,  height: 3*s)).fill()

            // Eyebrow arch
            let brow = UIBezierPath()
            brow.move(to: CGPoint(x: ex-13*s, y: eyeY-12*s))
            brow.addQuadCurve(to: CGPoint(x: ex+13*s, y: eyeY-12*s),
                              controlPoint: CGPoint(x: ex, y: eyeY-27*s))
            brownDark.setStroke()
            brow.lineWidth = 4*s; brow.lineCapStyle = .round; brow.stroke()
        }
    }

    private func drawNose(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        noseColor.setFill()
        UIBezierPath(roundedRect: CGRect(x: cx-14*s, y: cy+2*s, width: 28*s, height: 18*s),
                     cornerRadius: 9*s).fill()
        brownDark.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx-13*s, y: cy+9*s, width: 10*s, height: 10*s)).fill()
        UIBezierPath(ovalIn: CGRect(x: cx+3*s,  y: cy+9*s, width: 10*s, height: 10*s)).fill()
    }

    private func drawMouth(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        mouthColor.setStroke()
        // Smile arc
        let smile = UIBezierPath()
        smile.move(to: CGPoint(x: cx-22*s, y: cy+30*s))
        smile.addQuadCurve(to: CGPoint(x: cx+22*s, y: cy+30*s),
                           controlPoint: CGPoint(x: cx, y: cy+52*s))
        smile.lineWidth = 3.5*s; smile.lineCapStyle = .round; smile.stroke()
        // Mouth line
        let ml = UIBezierPath()
        ml.move(to: CGPoint(x: cx-20*s, y: cy+30*s))
        ml.addLine(to: CGPoint(x: cx+20*s, y: cy+30*s))
        ml.lineWidth = 3.5*s; ml.stroke()
        // Teeth
        UIColor.white.setFill()
        UIBezierPath(roundedRect: CGRect(x: cx-18*s, y: cy+30*s, width: 36*s, height: 12*s),
                     cornerRadius: 4*s).fill()
        // Tooth gap
        let gap = UIBezierPath()
        gap.move(to: CGPoint(x: cx, y: cy+30*s))
        gap.addLine(to: CGPoint(x: cx, y: cy+42*s))
        mouthColor.setStroke(); gap.lineWidth = 2*s; gap.stroke()
    }

    private func drawFur(cx: CGFloat, cy: CGFloat, s: CGFloat) {
        let lines: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (-20,-125,-25,-140), (0,-128,0,-145), (20,-125,25,-140),
            (-40,-118,-50,-132), (40,-118,50,-132),
            (-60,-105,-75,-116), (60,-105,75,-116)
        ]
        brownDark.setStroke()
        for (x1,y1,x2,y2) in lines {
            let p = UIBezierPath()
            p.move(to: CGPoint(x: cx+x1*s, y: cy+y1*s))
            p.addLine(to: CGPoint(x: cx+x2*s, y: cy+y2*s))
            p.lineWidth = 1.5*s; p.lineCapStyle = .round; p.stroke()
        }
    }
}
