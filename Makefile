PLUGIN=$(shell basename "$$PWD")

.PHONY: test

all: test

test:	
	cd test && ./test.sh

clean:
	find . -type f \( -name "*.out" -o -name "*.swp" \) -delete

zip:
	@rm -f $(PLUGIN).zip; zip $(PLUGIN).zip plugin/* doc/*
