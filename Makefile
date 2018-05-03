
.PHONY: test

all: test

test:	
	cd test && ./test.sh

clean:
	find . -type f -name "*.out" -delete
