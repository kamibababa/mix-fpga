NAME = c

all:	$(NAME).mls $(NAME).card $(NAME).out

$(NAME).mls: $(NAME).mixal
	../tools/asm.py $(NAME).mixal
$(NAME).card: $(NAME).mls
	../tools/mls2card.py $(NAME).mls
rand.card:
	../tools/randcard.py 100
c_rand.card: rand.card c.card
	cat c.card rand.card > c_rand.card
$(NAME).out: $(NAME)_rand.card
	stty -F /dev/ttyUSB0 115200 -icrnl -echo
	cat /dev/ttyUSB0 > $(NAME).out &
	cat $(NAME)_rand.card > /dev/ttyUSB0
	sleep 1
	killall cat
	cat $(NAME).out
clean:
	rm -f *.mls *.card *.out

.PHONY: all clean
