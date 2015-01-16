CC := gcc

CFLAGS :=
CPPFLAGS :=

OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
BIN := openvox_ami

ALL: ${BIN}
${BIN}: ${OBJS}
	${CC} $^ -o $@

.PHONY: clean
clean:
	@-rm -rf *.o *.~
	@-rm -rf ${BIN}

