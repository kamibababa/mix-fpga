NAME = coins

all:	$(NAME).mls $(NAME).card $(NAME).out

$(NAME).mls: $(NAME).mixal
	../tools/asm.py $(NAME).mixal
$(NAME).card: $(NAME).mls
	../tools/mls2card.py $(NAME).mls
$(NAME).out: $(NAME).card
	stty -F /dev/ttyUSB0 115200 -icrnl -echo
	cat /dev/ttyUSB0 > $(NAME).out &
	../tools/cardreader.py $(NAME).card
	sleep 1
	../tools/cardreader.py $(NAME).in -r
	sleep 10
	killall cat
	cat $(NAME).out
clean:
	rm -f *.mls *.card *.out

.PHONY: all clean
