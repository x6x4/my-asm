NAME= my_prog

#a.out:   $(NAME).o
#	ld $^ -o $@
$(NAME).out: $(NAME).o
	gcc -g -no-pie $^ -o $@

$(NAME).o: $(NAME).asm
	nasm -f elf64 -g $^ -o $@

clean:
	rm -f *.o
	rm -f *.out
