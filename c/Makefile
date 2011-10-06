CC = llvm-gcc
LDFLAGS = -lsqlite3
CFLAGS = -g

TEST_RUN = sqlite-test bindata-test

all : $(TEST_RUN)

sqlite-test : test.o hanzi-sqlite.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

bindata-test : test.o hanzi-bindata.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

clean :
	-rm -f *.o
	-rm -f $(TEST_RUN)
