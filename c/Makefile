CC = llvm-gcc
LDFLAGS = -liconv
CFLAGS = -g -std=gnu99

all: cp2py

cp2py: cp2py.o hanzi.o hanzi-bindata.o unicode.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

clean:
	-rm -f *.o
	-rm -f $(TEST_RUN)
