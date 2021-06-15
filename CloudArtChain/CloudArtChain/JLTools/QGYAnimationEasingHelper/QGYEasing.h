//
//  QGYEasing.h
//
//  Created by fyzq on 2020/12/8.
//

#ifndef QGY_EASING_H
#define QGY_EASING_H

#if defined(__LP64__) && !defined(QGY_EASING_USE_DBL_PRECIS)
#define QGY_EASING_USE_DBL_PRECIS
#endif

#ifdef QGY_EASING_USE_DBL_PRECIS
#define QGY_FLOAT_TYPE double
#else
#define QGY_FLOAT_TYPE float
#endif
typedef QGY_FLOAT_TYPE QGYFloat;

#if defined __cplusplus
extern "C" {
#endif

typedef QGYFloat (*QGYEasingFunction)(QGYFloat);

// Linear interpolation (no easing)
QGYFloat QGYLinearInterpolation(QGYFloat p);

// Quadratic easing; p^2
QGYFloat QGYQuadraticEaseIn(QGYFloat p);
QGYFloat QGYQuadraticEaseOut(QGYFloat p);
QGYFloat QGYQuadraticEaseInOut(QGYFloat p);

// Cubic easing; p^3
QGYFloat QGYCubicEaseIn(QGYFloat p);
QGYFloat QGYCubicEaseOut(QGYFloat p);
QGYFloat QGYCubicEaseInOut(QGYFloat p);

// Quartic easing; p^4
QGYFloat QGYQuarticEaseIn(QGYFloat p);
QGYFloat QGYQuarticEaseOut(QGYFloat p);
QGYFloat QQGYuarticEaseInOut(QGYFloat p);

// Quintic easing; p^5
QGYFloat QGYQuinticEaseIn(QGYFloat p);
QGYFloat QGYQuinticEaseOut(QGYFloat p);
QGYFloat QGYQuinticEaseInOut(QGYFloat p);

// Sine wave easing; sin(p * PI/2)
QGYFloat QGYSineEaseIn(QGYFloat p);
QGYFloat QGYSineEaseOut(QGYFloat p);
QGYFloat QGYSineEaseInOut(QGYFloat p);

// Circular easing; sqrt(1 - p^2)
QGYFloat QGYCircularEaseIn(QGYFloat p);
QGYFloat QGYCircularEaseOut(QGYFloat p);
QGYFloat QGYCircularEaseInOut(QGYFloat p);

// Exponential easing, base 2
QGYFloat QGYExponentialEaseIn(QGYFloat p);
QGYFloat QGYExponentialEaseOut(QGYFloat p);
QGYFloat QGYExponentialEaseInOut(QGYFloat p);

// Exponentially-damped sine wave easing
QGYFloat QGYElasticEaseIn(QGYFloat p);
QGYFloat QGYElasticEaseOut(QGYFloat p);
QGYFloat QGYElasticEaseInOut(QGYFloat p);

// Overshooting cubic easing; 
QGYFloat QGYBackEaseIn(QGYFloat p);
QGYFloat QGYBackEaseOut(QGYFloat p);
QGYFloat QGYBackEaseInOut(QGYFloat p);

// Exponentially-decaying bounce easing
QGYFloat QGYBounceEaseIn(QGYFloat p);
QGYFloat QGYBounceEaseOut(QGYFloat p);
QGYFloat QGYBounceEaseInOut(QGYFloat p);

#ifdef __cplusplus
}
#endif

#endif
