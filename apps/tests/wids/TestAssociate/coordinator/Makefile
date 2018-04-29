COMPONENT=TestAssociateAppC
CFLAGS += -DIEEE154_BEACON_SYNC_DISABLED
CFLAGS += -DWIDS_SECURITY
CFLAGS += -DENABLE_TKN
CFLAGS += -I$(shell pwd)/..

CFLAGS += -I$(TOSDIR)/lib/printf #fab

# To use the TKN15.4 MAC instead of a platform's default MAC protocol first
# include the TinyOS "Makerules" file as usual ...
include $(MAKERULES)
# ... and then include the WIDS "Makefile.include" file. That's all.
# Hint: type "make <platform> verbose" to see the aggregate include path.
include $(TOSDIR)/lib/mac/tkn154/Makefile.include 
include $(TOSDIR)/lib/wids/Makefile.include
