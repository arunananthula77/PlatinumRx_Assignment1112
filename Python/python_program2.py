def minutes_to_readable(total_minutes):
    hours = total_minutes // 60
    minutes = total_minutes % 60
    if hours == 0:
        return f"{minutes} minutes"
    elif minutes == 0:
        return f"{hours} hrs"
    else:
        return f"{hours} hr{'s' if hours > 1 else ''} {minutes} minutes"

# Test cases
print(minutes_to_readable(130))  # 2 hrs 10 minutes
print(minutes_to_readable(110))  # 1 hr 50 minutes
print(minutes_to_readable(60))   # 1 hr
print(minutes_to_readable(45))   # 45 minutes
