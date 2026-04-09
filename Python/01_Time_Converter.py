def minutes_to_readable(total_minutes):
    if total_minutes < 0:
        return "Invalid input: minutes cannot be negative"

    hours = total_minutes // 60
    minutes = total_minutes % 60

    if hours == 0:
        return f"{minutes} minutes"
    elif minutes == 0:
        return f"{hours} hr{'s' if hours > 1 else ''}"
    else:
        return f"{hours} hr{'s' if hours > 1 else ''} {minutes} minutes"

# Test Cases
test_cases = [130, 110, 60, 45, 0, 90, 180, 200, 1, 61]

for mins in test_cases:
    print(f"{mins:>4} minutes  ->  {minutes_to_readable(mins)}")
