import sys
import pandas as pd
import subprocess

# Open file

run_dat = pd.read_csv("data/run_log.csv")

SHOE_MILES = 160  # From 2018 shoe miles

# Get arguments
date = sys.argv[1]
miles = sys.argv[2]
time = sys.argv[3]
notes = sys.argv[4]

# date = "asdf"
# miles = 1
# time = 2

# Build data to merge
mdat = pd.DataFrame({"date": [date], "miles": [miles], "time": [time], "notes": notes})

run_dat = pd.concat([run_dat, mdat], sort=False)

run_dat = run_dat.sort_values("date")

run_dat.to_csv("data/run_log.csv", index=False)

# subprocess.run("git add --all", shell=True)

# Because that doesn't make any sense /s
# subprocess.run("git rm figures/mpw_bar.png", shell=True)
subprocess.run("Rscript 2-figures.R", shell=True)
subprocess.run("git add figures/mpw_bar.png", shell=True)
subprocess.run('git commit -a -m "adding run"', shell=True)
subprocess.run("git push origin master", shell=True)

print("Saved data/run_log.csv")
