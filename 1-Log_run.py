import sys
import pandas as pd

# Open file

run_dat = pd.read_csv("data/run_log.csv")

SHOE_MILES = 160  # From 2018 shoe miles

# Get arguments
date = sys.argv[1]
miles = sys.argv[2]
time = sys.argv[3]

# date = "asdf"
# miles = 1
# time = 2

# Build data to merge
mdat = pd.DataFrame({"date": [date], "miles": [miles], "time": [time]})

run_dat = pd.concat([run_dat, mdat])

run_dat.to_csv("data/run_log.csv", index=False)

print("Saved data/run_log.csv")
