NAME= my_prog
ASCEND=

$(NAME).out:   $(NAME).o
	ld $^ -o $@

$(NAME).o: $(NAME).asm OddEvenSort.asm 
	nasm -f elf64 -g ${ASCEND} $< -o $@

clean:
	rm -f *.o
	rm -f *.out
