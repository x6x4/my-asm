NAME= str_handle

$(NAME).out:   $(NAME).o
	ld $^ -o $@

$(NAME).o: $(NAME).asm
	nasm -f elf64 -g ${ASCEND} $< -o $@

clean:
	rm -f *.o
	rm -f *.out
