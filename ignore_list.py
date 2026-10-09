# 🌵 autoreadme — resolve ignore-list path with three-tier precedence
# 📦 Part of: https://github.com/wkaefer/autoreadme
# ⚠️  Edit in the autoreadme repo to avoid drift.

import os

# Get the directory of the current script
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

# Define the default local ignore list filename relative to the script directory
LOCAL_IGNORE_LIST_FILE = os.path.join(SCRIPT_DIR, "ignore_list.txt")

# Get the ignore list file path from the environment variable or set default paths
IGNORE_LIST_FILE = os.environ.get(
    "IGNORE_LIST",
    os.path.join(os.path.expanduser("~"), ".config", "autoreadme", "ignore_list.txt")
)

def load_ignore_list():
    if os.path.isfile(IGNORE_LIST_FILE):
        with open(IGNORE_LIST_FILE) as f:
            return set(line.strip() for line in f if line.strip())
    elif os.path.isfile(LOCAL_IGNORE_LIST_FILE):
        with open(LOCAL_IGNORE_LIST_FILE) as f:
            return set(line.strip() for line in f if line.strip())
    else:
        return set()

IGNORE_LIST = load_ignore_list()

def main():
    for item in sorted(IGNORE_LIST):
        print(item)

if __name__ == "__main__":
    main()
