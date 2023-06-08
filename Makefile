TABS=$(wildcard */*.tab)
all: $(patsubst %.tab,%.res,$(TABS))\
     $(patsubst %.tab,%.png,$(TABS))\
     $(patsubst %.tab,%.res2,$(TABS))

%.res: %.tab
	./proc1 $<

%.res2 %.png: %.res
	./proc2 $<

