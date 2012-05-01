CC = llvm-gcc
LDFLAGS = -liconv
CFLAGS = -g -std=gnu99 -I..
VPATH = ..

TEST_RUN = sqlite-test bindata-test

all: $(TEST_RUN)

sqlite-test: test.o hanzi.o hanzi-sqlite.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) -lsqlite3 $^ -o $@

bindata-test: test.o hanzi.o hanzi-bindata.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

clean:
	-rm -f *.o
	-rm -f $(TEST_RUN)
