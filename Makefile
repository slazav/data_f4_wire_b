TABS=$(wildcard */*.tab)
all: $(patsubst %.tab,%.res,$(TABS)) $(patsubst %.tab,%.png,$(TABS))

%.res %.png: %.tab
	./proc1 $<

