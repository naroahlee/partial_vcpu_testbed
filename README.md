Deferrable Server Experiment

Used along with synthetic_ds project.

Supported Feature:

Exp01: Single Run and show the equivalence between full and partial VCPU.
	Plot Schedule (FIFO FP)
	Compare CDF for two different settings (FIFO FP)

EXP02: Single Run for Redis: Check the CDF
	Compare CDF

EXP03: 20 Runs for the same synthetic configureation 
	Find the expectation job execution time, (One vector)
	Find the system error. (1st norm / len ==> 20 samples)
	Find the Partial run error correspondent to the full system.

EXP04: for 5 set different utilization [0.1:0.2:0.9]
		random generate 20 testcases;
		run each testcase for 20 times; with two settings (Full, Partial)
		for each run, run for 10s + sleep(5) (15s)
	In total, run for 5x20x40x15 = 60000s
	For each day, we have 24x3600 = 86400s

EXP05: The sporadic version for Exp01
