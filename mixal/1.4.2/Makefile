NAME = c

all:	$(NAME).mls $(NAME).card $(NAME).out

$(NAME).mls: $(NAME).mixal
	../tools/asm.py $(NAME).mixal
$(NAME).card: $(NAME).mls
	../tools/mls2card.py $(NAME).mls
$(NAME)_in.card: $(NAME).card
	cat $(NAME).card c.in > $(NAME)_in.card
$(NAME).out: $(NAME)_in.card
	stty -F /dev/ttyUSB0 115200 -icrnl -echo
	cat /dev/ttyUSB0 > $(NAME).out &
	cat $(NAME)_in.card > /dev/ttyUSB0
	sleep 1
	killall cat
	cat $(NAME).out
clean:
	rm -f *.mls *.card *.out

.PHONY: all clean
