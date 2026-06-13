package com.monkeyart.app;

import android.animation.ValueAnimator;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;

public class MonkeyView extends View {

    private Paint paint;
    private Paint detailPaint;
    private RectF rect;

    private float waveAngle     = 0f;  // right arm rotation (negative = up)
    private float waveAngleLeft = 0f;  // left arm rotation  (positive = up)

    private static final int BROWN_DARK   = Color.parseColor("#5D3A1A");
    private static final int BROWN_MID    = Color.parseColor("#8B5E3C");
    private static final int SKIN_FACE    = Color.parseColor("#D4956A");
    private static final int SKIN_INNER   = Color.parseColor("#F0B88A");
    private static final int WHITE        = Color.WHITE;
    private static final int PUPIL        = Color.parseColor("#1A1A2E");
    private static final int NOSE_COLOR   = Color.parseColor("#A0522D");
    private static final int MOUTH_COLOR  = Color.parseColor("#8B3A3A");
    private static final int EAR_INNER    = Color.parseColor("#E8957A");
    private static final int BG_TOP       = Color.parseColor("#1A3A2F");
    private static final int BG_BOT       = Color.parseColor("#0D2318");
    private static final int LEAF_GREEN   = Color.parseColor("#2E7D32");
    private static final int LEAF_LIGHT   = Color.parseColor("#66BB6A");

    public MonkeyView(Context context) {
        super(context);
        init();
    }

    public MonkeyView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        detailPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        detailPaint.setStyle(Paint.Style.STROKE);
        detailPaint.setStrokeCap(Paint.Cap.ROUND);
        rect = new RectF();
    }

    /** Triggers a 3-cycle wave of the right arm. */
    public void waveRight() {
        ValueAnimator animator = ValueAnimator.ofFloat(0f, -65f, 0f, -65f, 0f, -65f, 0f);
        animator.setDuration(1800);
        animator.setInterpolator(new AccelerateDecelerateInterpolator());
        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator a) {
                waveAngle = (float) a.getAnimatedValue();
                invalidate();
            }
        });
        animator.start();
    }

    /** Triggers a 3-cycle wave of the left arm. */
    public void waveLeft() {
        ValueAnimator animator = ValueAnimator.ofFloat(0f, 65f, 0f, 65f, 0f, 65f, 0f);
        animator.setDuration(1800);
        animator.setInterpolator(new AccelerateDecelerateInterpolator());
        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator a) {
                waveAngleLeft = (float) a.getAnimatedValue();
                invalidate();
            }
        });
        animator.start();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        int w = getWidth();
        int h = getHeight();
        float cx = w / 2f;
        float cy = h / 2f;
        float scale = Math.min(w, h) / 400f;

        drawBackground(canvas, w, h);
        drawLeaves(canvas, cx, cy, scale);
        drawBody(canvas, cx, cy, scale);
        drawHead(canvas, cx, cy, scale);
        drawEars(canvas, cx, cy, scale);
        drawFace(canvas, cx, cy, scale);
        drawEyes(canvas, cx, cy, scale);
        drawNose(canvas, cx, cy, scale);
        drawMouth(canvas, cx, cy, scale);
        drawFur(canvas, cx, cy, scale);
    }

    private void drawBackground(Canvas canvas, int w, int h) {
        paint.setStyle(Paint.Style.FILL);
        int steps = 20;
        for (int i = 0; i < steps; i++) {
            float t = (float) i / steps;
            paint.setColor(Color.rgb(
                lerp(Color.red(BG_TOP),   Color.red(BG_BOT),   t),
                lerp(Color.green(BG_TOP), Color.green(BG_BOT), t),
                lerp(Color.blue(BG_TOP),  Color.blue(BG_BOT),  t)
            ));
            canvas.drawRect(0, (float) h * i / steps, w, (float) h * (i + 1) / steps, paint);
        }
    }

    private void drawLeaves(Canvas canvas, float cx, float cy, float scale) {
        paint.setStyle(Paint.Style.FILL);
        drawLeaf(canvas, cx - 160 * scale, cy - 150 * scale, 80 * scale, -30, LEAF_GREEN);
        drawLeaf(canvas, cx + 160 * scale, cy - 150 * scale, 80 * scale, 210, LEAF_GREEN);
        drawLeaf(canvas, cx - 170 * scale, cy + 100 * scale, 70 * scale,  20, LEAF_LIGHT);
        drawLeaf(canvas, cx + 170 * scale, cy + 100 * scale, 70 * scale, 160, LEAF_LIGHT);
        drawLeaf(canvas, cx,               cy - 200 * scale, 60 * scale,  90, LEAF_GREEN);
    }

    private void drawLeaf(Canvas canvas, float x, float y, float size, float angle, int color) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        paint.setColor(color);
        Path leaf = new Path();
        leaf.moveTo(0, 0);
        leaf.cubicTo(-size * 0.4f, -size * 0.3f, -size * 0.6f, -size * 0.8f, 0, -size);
        leaf.cubicTo( size * 0.6f, -size * 0.8f,  size * 0.4f, -size * 0.3f, 0, 0);
        canvas.drawPath(leaf, paint);
        detailPaint.setColor(Color.parseColor("#1B5E20"));
        detailPaint.setStrokeWidth(1.5f);
        canvas.drawLine(0, 0, 0, -size * 0.85f, detailPaint);
        canvas.restore();
    }

    private void drawBody(Canvas canvas, float cx, float cy, float scale) {
        paint.setStyle(Paint.Style.FILL);

        // Torso
        paint.setColor(BROWN_DARK);
        rect.set(cx - 55 * scale, cy + 60 * scale, cx + 55 * scale, cy + 190 * scale);
        canvas.drawRoundRect(rect, 40 * scale, 30 * scale, paint);

        paint.setColor(BROWN_MID);
        rect.set(cx - 30 * scale, cy + 70 * scale, cx + 30 * scale, cy + 170 * scale);
        canvas.drawRoundRect(rect, 30 * scale, 25 * scale, paint);

        // Left arm — rotated by waveAngleLeft around the shoulder
        float leftShoulderX = cx - 55 * scale;
        float leftShoulderY = cy + 80 * scale;
        canvas.save();
        canvas.rotate(waveAngleLeft, leftShoulderX, leftShoulderY);
        drawArm(canvas, leftShoulderX, leftShoulderY, scale, true, waveAngleLeft);
        canvas.restore();

        // Right arm — rotated by waveAngle around the shoulder
        float shoulderX = cx + 55 * scale;
        float shoulderY = cy + 80 * scale;
        canvas.save();
        canvas.rotate(waveAngle, shoulderX, shoulderY);
        drawArm(canvas, shoulderX, shoulderY, scale, false, waveAngle);
        canvas.restore();
    }

    private void drawArm(Canvas canvas, float x, float y, float scale, boolean left, float angle) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(BROWN_DARK);
        float dir = left ? -1 : 1;
        Path arm = new Path();
        arm.moveTo(x, y);
        arm.cubicTo(
            x + dir * 40 * scale, y + 10 * scale,
            x + dir * 70 * scale, y + 60 * scale,
            x + dir * 55 * scale, y + 110 * scale
        );
        arm.cubicTo(
            x + dir * 50 * scale, y + 125 * scale,
            x + dir * 30 * scale, y + 120 * scale,
            x + dir * 25 * scale, y + 105 * scale
        );
        arm.cubicTo(
            x + dir * 35 * scale, y + 55 * scale,
            x + dir * 10 * scale, y + 10 * scale,
            x, y
        );
        canvas.drawPath(arm, paint);

        // Hand
        paint.setColor(BROWN_MID);
        canvas.drawCircle(x + dir * 52 * scale, y + 115 * scale, 14 * scale, paint);
        for (int i = -1; i <= 2; i++) {
            canvas.drawCircle(x + dir * (48 + i * 7) * scale, y + 102 * scale, 5 * scale, paint);
        }
    }

    private void drawHead(Canvas canvas, float cx, float cy, float scale) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(BROWN_MID);
        canvas.drawCircle(cx, cy - 30 * scale, 100 * scale, paint);

        paint.setColor(BROWN_DARK);
        rect.set(cx - 100 * scale, cy - 130 * scale, cx + 100 * scale, cy - 30 * scale);
        canvas.drawOval(rect, paint);

        paint.setColor(BROWN_MID);
        rect.set(cx - 80 * scale, cy - 120 * scale, cx + 80 * scale, cy - 20 * scale);
        canvas.drawOval(rect, paint);
    }

    private void drawEars(Canvas canvas, float cx, float cy, float scale) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(BROWN_MID);
        canvas.drawCircle(cx - 95 * scale, cy - 40 * scale, 28 * scale, paint);
        paint.setColor(EAR_INNER);
        canvas.drawCircle(cx - 95 * scale, cy - 40 * scale, 16 * scale, paint);

        paint.setColor(BROWN_MID);
        canvas.drawCircle(cx + 95 * scale, cy - 40 * scale, 28 * scale, paint);
        paint.setColor(EAR_INNER);
        canvas.drawCircle(cx + 95 * scale, cy - 40 * scale, 16 * scale, paint);
    }

    private void drawFace(Canvas canvas, float cx, float cy, float scale) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(SKIN_FACE);
        rect.set(cx - 70 * scale, cy - 60 * scale, cx + 70 * scale, cy + 55 * scale);
        canvas.drawOval(rect, paint);

        paint.setColor(SKIN_INNER);
        rect.set(cx - 38 * scale, cy + 5 * scale, cx + 38 * scale, cy + 55 * scale);
        canvas.drawOval(rect, paint);
    }

    private void drawEyes(Canvas canvas, float cx, float cy, float scale) {
        float eyeY = cy - 25 * scale;
        float eyeOffX = 30 * scale;

        for (int side = -1; side <= 1; side += 2) {
            float ex = cx + side * eyeOffX;

            paint.setStyle(Paint.Style.FILL);
            paint.setColor(WHITE);
            canvas.drawCircle(ex, eyeY, 16 * scale, paint);

            paint.setColor(Color.parseColor("#5C4033"));
            canvas.drawCircle(ex, eyeY, 12 * scale, paint);

            paint.setColor(PUPIL);
            canvas.drawCircle(ex, eyeY, 7 * scale, paint);

            paint.setColor(WHITE);
            canvas.drawCircle(ex + 3 * scale, eyeY - 3 * scale, 3 * scale, paint);
            canvas.drawCircle(ex - 2 * scale, eyeY + 4 * scale, 1.5f * scale, paint);

            detailPaint.setColor(BROWN_DARK);
            detailPaint.setStrokeWidth(4 * scale);
            detailPaint.setStyle(Paint.Style.STROKE);
            canvas.drawArc(
                ex - 15 * scale, eyeY - 28 * scale,
                ex + 15 * scale, eyeY - 10 * scale,
                200, 140, false, detailPaint
            );
        }
    }

    private void drawNose(Canvas canvas, float cx, float cy, float scale) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(NOSE_COLOR);
        rect.set(cx - 14 * scale, cy + 2 * scale, cx + 14 * scale, cy + 20 * scale);
        canvas.drawRoundRect(rect, 10 * scale, 10 * scale, paint);

        paint.setColor(BROWN_DARK);
        canvas.drawCircle(cx - 8 * scale, cy + 14 * scale, 5 * scale, paint);
        canvas.drawCircle(cx + 8 * scale, cy + 14 * scale, 5 * scale, paint);
    }

    private void drawMouth(Canvas canvas, float cx, float cy, float scale) {
        detailPaint.setStyle(Paint.Style.STROKE);
        detailPaint.setColor(MOUTH_COLOR);
        detailPaint.setStrokeWidth(3.5f * scale);
        rect.set(cx - 25 * scale, cy + 22 * scale, cx + 25 * scale, cy + 50 * scale);
        canvas.drawArc(rect, 10, 160, false, detailPaint);
        canvas.drawLine(cx - 20 * scale, cy + 30 * scale, cx + 20 * scale, cy + 30 * scale, detailPaint);

        paint.setStyle(Paint.Style.FILL);
        paint.setColor(WHITE);
        rect.set(cx - 18 * scale, cy + 30 * scale, cx + 18 * scale, cy + 42 * scale);
        canvas.drawRoundRect(rect, 4 * scale, 4 * scale, paint);

        detailPaint.setColor(MOUTH_COLOR);
        detailPaint.setStrokeWidth(2 * scale);
        canvas.drawLine(cx, cy + 30 * scale, cx, cy + 42 * scale, detailPaint);
    }

    private void drawFur(Canvas canvas, float cx, float cy, float scale) {
        detailPaint.setStyle(Paint.Style.STROKE);
        detailPaint.setColor(BROWN_DARK);
        detailPaint.setStrokeWidth(1.5f * scale);
        float[][] furLines = {
            {-20, -125, -25, -140}, {0, -128, 0, -145}, {20, -125, 25, -140},
            {-40, -118, -50, -132}, {40, -118, 50, -132},
            {-60, -105, -75, -116}, {60, -105, 75, -116},
        };
        for (float[] l : furLines) {
            canvas.drawLine(cx + l[0]*scale, cy + l[1]*scale, cx + l[2]*scale, cy + l[3]*scale, detailPaint);
        }
    }

    private int lerp(int a, int b, float t) {
        return (int) (a + (b - a) * t);
    }
}
