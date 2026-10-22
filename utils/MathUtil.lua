MathUtil = {}

function MathUtil.Clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

function MathUtil.Round(value)
    return math.floor(value + 0.5)
end

function MathUtil.Lerp(a, b, t)
    return a + (b - a) * t
end

function MathUtil.Map(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

return MathUtil
