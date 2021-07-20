NAME = t

all:	$(NAME).mls $(NAME).card upload

$(NAME).mls: $(NAME).mixal
	../tools/asm.py $(NAME).mixal
$(NAME).card: $(NAME).mls
	../tools/mls2card.py $(NAME).mls
upload: $(NAME).card
	stty -F /dev/ttyUSB0 115200 -icrnl -echo
	../tools/cardreader.py $(NAME).card
clean:
	rm -f *.mls *.card *.out

.PHONY: all clean upload
