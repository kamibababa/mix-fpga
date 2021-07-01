NAME = go

all:	$(NAME).mls $(NAME).bin

$(NAME).mls: $(NAME).mixal
	../../mixal/tools/asm.py $(NAME).mixal
$(NAME).bin: $(NAME).mls
	../../mixal/tools/mls2bin.py $(NAME).mls
clean:
	rm -f *.mls *.bin

.PHONY: all clean
