.PHONY: all clean

all:
	@echo "Usage()"

clean: clean_exp01

Exp01:
	./EXP01/Exp01.sh

clean_exp01:
	./EXP01/clean.sh


