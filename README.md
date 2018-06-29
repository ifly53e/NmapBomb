# NmapBomb
Combinatorial Test Configurations for Nmap

## What does the NmapBomb do?
Nmapbomb is a bash script that:
-Runs all three way combinations of all ping scans for Host Discovery
-Runs all three way combinations of all port scanning techniques except -sI (Zombie) and -b (FPT bounce scan).
-Runs three way combinations of TCP flags for custom port scanning techniques.
-Saves all scans as xml in a unique folder.
-Opens the folder of scan files with Zenmap for analysis.

## How was the NmapBomb created?
Nmap configurations were generated using a software testing technique called Combinatorial Testing (CT).
CT is used to discover software bugs by generating all combinations of input parameters to produce configurations that will crash the program.
Instead of trying to crash Nmap, I am trying to produce unique and untested Nmap configurations to discover new hosts, ports, and services.
CT is similar to pairwise testing but instead of changing two input parameters at time, three input parameters are changed.
This allows more testing tuples to be included in every Nmap configuration, thus reducing the total number of Nmap runs.

## How many different scans are included in the NmapBomb?
24 host discovery scans and 88 port scans for a total of 112.

## How fast does the NmapBomb take to complete all of the scans?
All of the timing options for Nmap are available but T3 takes more than a day due to lengthy UDP scans.

## Where can I download it, test it, and provide constructive feedback?
https://github.com/ifly53e/NmapBomb
