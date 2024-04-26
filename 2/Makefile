NAME= my_prog

$(NAME).out:   $(NAME).o
	ld $^ -o $@

$(NAME).o: $(NAME).asm OddEvenSort.asm 
	nasm -f elf64 -g $< -o $@

clean:
	rm -f *.o
	rm -f *.out
