NAME = c

all:	$(NAME).mls $(NAME).card $(NAME).out

$(NAME).mls: $(NAME).mixal
	../tools/asm.py $(NAME).mixal
$(NAME).card: $(NAME).mls
	../tools/mls2card.py $(NAME).mls
rand.card:
	../tools/randcard.py 100
$(NAME).out: $(NAME).card rand.card
	stty -F /dev/ttyUSB0 115200 -icrnl -echo
	cat /dev/ttyUSB0 > $(NAME).out &
	../tools/cardreader.py $(NAME).card
	../tools/cardreader.py rand.card
	sleep 1
	killall cat
	cat $(NAME).out
clean:
	rm -f *.mls *.card *.out 

.PHONY: all clean
