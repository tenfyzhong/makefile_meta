ifndef DIRS
	FILTER_OUT = Makefile makefile MAKEFILE
	DIRS = $(filter-out $(FILTER_OUT), $(wildcard *))
endif

.PHONY: all clean $(DIRS)

all: $(DIRS)

clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

