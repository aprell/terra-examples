CFLAGS += -Wall -Wextra

OBJS := add.o terra_add.o

check: $(wildcard *.t)
	@for x in $^; do \
	    if terra $$x > /dev/null; then \
	        printf "\e[32m[PASS]\e[0m %s\n" $$x; \
	    else \
	        printf "\e[31m[FAIL]\e[0m %s\n" $$x; \
	    fi \
	done

add: $(OBJS)

%.o: %.t
	terra $<

clean:
	$(RM) add $(OBJS)

.PHONY: check clean
