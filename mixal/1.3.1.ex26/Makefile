NAME = l

all:	$(NAME).mls $(NAME).card

$(NAME).mls: $(NAME).mixal
	../tools/asm.py $(NAME).mixal
$(NAME).card: $(NAME).mls
	../tools/mls2char.py $(NAME).mls
clean:
	rm -f *.mls *.card

.PHONY: all clean
