def remove_duplicates(s):
    seen = []
    result = ""

    for char in s:
        if char not in seen:
            seen.append(char)
            result += char

    return result

# Test Cases
test_cases = [
    "programming",
    "hello world",
    "aabbccdd",
    "data analyst",
    "PlatinumRx",
    "mississippi",
    "",
    "a",
    "aaaa"
]

for s in test_cases:
    print(f"Input : '{s}'")
    print(f"Output: '{remove_duplicates(s)}'")
    print()

