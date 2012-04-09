CC = llvm-gcc
LDFLAGS = -liconv
CFLAGS = -g

TEST_RUN = sqlite-test bindata-test cp2py

all : $(TEST_RUN)

sqlite-test : test.o hanzi-sqlite.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) -lsqlite3 $^ -o $@

bindata-test : test.o hanzi-bindata.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

cp2py: cp2py.o hanzi-bindata.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

clean :
	-rm -f *.o
	-rm -f $(TEST_RUN)
