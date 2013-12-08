all: erl.mk

erl.mk:
	wget -nv -O $@ 'https://raw.github.com/fenollp/erl-mk/master/erl.mk' || rm ./$@

include erl.mk

# Your targets after this line.

distclean: clean clean-docs
	$(if $(wildcard deps/ ), rm -rf deps/)
	$(if $(wildcard logs/ ), rm -rf logs/)
	$(if $(wildcard erl.mk), rm erl.mk   )
.PHONY: distclean

debug: all
	erl -pa ebin/ -pa deps/*/ebin/

test: all eunit
