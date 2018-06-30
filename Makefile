##
## Makefile for bsd make 
##
## Use bmake on linux
##

include nodes.mk



STARTS    = $(NODES:=_start)
STOPS     = $(NODES:=_stop)
ATTACHES  = $(NODES:=_attach)
RESTARTS  = $(NODES:=_restart)
INITS	  = $(NODES:=_init)

CMD		  = ./tarantoolctl.lua

$(STARTS):
	@$(CMD) start $(@:_start=)
$(STOPS):
	@$(CMD) stop $(@:_stop=)
$(ATTACHES):
	@echo ./attach.sh $(@:_attach=)
	@./attach.sh $(@:_attach=)
$(RESTARTS):
	@$(CMD) restart $(@:_restart=)
$(INITS):
	@$(CMD) init $(@:_init=)


l:
	@echo $(NODES:R:[-1..1])

fstart:
	-@for i in $(NODES); do \
      $(CMD) start $$i; \
    done

fstop:
	-@for i in $(NODES); do \
      $(CMD) stop $$i; \
    done

frestart:
	-@for i in $(NODES); do \
      $(CMD) restart $$i; \
    done

finit:
	-@for i in $(NODES); do \
      $(CMD) init $$i; \
    done

