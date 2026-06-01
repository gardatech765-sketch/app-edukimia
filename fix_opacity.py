import os
import re

directory = "lib/"
pattern = re.compile(r"\.withOpacity\(([^)]+)\)")

count = 0
for root, _, files in os.walk(directory):
    for file in files:
        if file.endswith(".dart"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            new_content = pattern.sub(r".withValues(alpha: \1)", content)
            if new_content != content:
                with open(path, "w") as f:
                    f.write(new_content)
                print(f"Updated {path}")
                count += 1

print(f"Successfully fixed deprecations in {count} files.")
