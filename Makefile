.PHONY: all clean

all:
	@echo "Usage()"

clean: clean_exp01 clean_exp02 clean_exp03 clean_exp04 clean_exp05

Exp01:
	./EXP01/Exp01.sh

Exp02:
	./EXP02/Exp02.sh

clean_exp01:
	./EXP01/clean.sh

clean_exp02:
	./EXP02/clean.sh

clean_exp03:
	./EXP03/clean.sh

clean_exp04:
	./EXP04/clean.sh

clean_exp05:
	./EXP05/clean.sh
