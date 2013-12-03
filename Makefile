all: erl.mk

erl.mk:
	wget 'https://raw.github.com/fenollp/erl-mk/master/erl.mk'

DEPS =


distclean: clean clean-docs
	$(if $(wildcard deps/ ), rm -rf deps/)
	$(if $(wildcard logs/ ), rm -rf logs/)
#	$(if $(wildcard erl.mk), rm erl.mk   )
.PHONY: distclean

include erl.mk

# You need ANTLRv4 in your $CLASSPATH

debug: all
	erl -pa ebin/ -pa deps/*/ebin/

test: all eunit
