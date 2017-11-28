#include "PID.h"
#include <limits>

/*
* TODO: Complete the PID class.
*/

PID::PID() {}

PID::~PID() {}

void PID::Init(double kp_, double ki_, double kd_)
{
    Kp = kp_;
    Ki = ki_;
    Kd = kd_;

    // Proportional error is infinte at the beginning
    p_error = std::numeric_limits<double>::max();

    // Integral error (= total area below the CTE) is zero because no time has passed
    i_error = 0.0;

    // Differential error is 0, since infinity minus infinity is nothing
    d_error = 0.0;
}

void PID::UpdateError(double cte)
{
    if (p_error == std::numeric_limits<double>::max())
        p_error = cte;
    d_error = cte - p_error;
    p_error = cte;
    i_error += cte;
}

double PID::TotalError()
{
    return -Kp * p_error - Kd * d_error - Ki * i_error;
}


