def convert_minutes(minutes):
    hrs = minutes // 60
    mins = minutes % 60
    
    if hrs > 0:
        return f"{hrs} hr{'s' if hrs > 1 else ''} {mins} minutes"
    else:
        return f"{mins} minutes"

print(convert_minutes(130))  # 2 hrs 10 minutes
print(convert_minutes(110))  # 1 hr 50 minutes
