CFLAGS += -Wall -Wextra

OBJS = add.o terra_add.o

add: $(OBJS)

%.o: %.t
	terra $<

clean:
	rm -f add $(OBJS)

.PHONY: clean
