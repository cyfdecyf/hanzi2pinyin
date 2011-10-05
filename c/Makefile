CC = llvm-gcc
LDFLAGS = -lsqlite3

test : test.o hanzi-sqlite.o unicode.o
	$(CC) $^ -o $@ $(LDFLAGS)

clean :
	-rm -f *.o
