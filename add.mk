CFLAGS += -Wall -Wextra

OBJS := add.o terra_add.o

add: $(OBJS)

%.o: %.t
	terra $<

clean:
	$(RM) add $(OBJS)

.PHONY: clean
