.PHONY: all clean

all:
	@echo "Usage()"

clean: clean_exp01 clean_exp02

Exp01:
	./EXP01/Exp01.sh

Exp02:
	./EXP02/Exp02.sh

clean_exp01:
	./EXP01/clean.sh

clean_exp02:
	./EXP02/clean.sh

