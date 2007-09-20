#
# Tools
#

RM                 = rm -f
RAGEL_PRECOMP      = ragel
RAGEL_CODEGEN      = rlgen-cd
RAGEL_DOT          = rlgen-dot
DOT                = dot

#
# Files
#

RAGEL_PRECOMP_SRCS = diff.rl
RAGEL_PRECOMP_OBJS = diff.xml
RAGEL_CODEGEN_OBJS = diff.m
RAGEL_DOT_OBJS     = diff.dot
RAGEL_GRAPHS       = diff.png
OBJECTS            = diff.o
CLEANOBJS = *.o

#
# Rules
#

all: ragel

ragel: $(RAGEL_CODEGEN_OBJS)
	$(CC) -std=gnu99 -framework Foundation $(RAGEL_CODEGEN_OBJS)

$(RAGEL_PRECOMP_OBJS) : $(RAGEL_PRECOMP_SRCS)
$(RAGEL_CODEGEN_OBJS) : $(RAGEL_PRECOMP_OBJS)

dot: $(RAGEL_DOT_OBJS)
graph: $(RAGEL_GRAPHS)

clean:
	$(RM) $(RAGEL_PRECOMP_OBJS) $(RAGEL_CODEGEN_OBJS) $(RAGEL_DOT_OBJS) $(RAGEL_GRAPHS) $(CLEANOBJS)
check: test
test:
	@echo "not implemented yet"

.SUFFIXES: .m .dot .png .rl .xml
.dot.png:
	$(DOT) -Tpng $< -o $@
.rl.xml:
	$(RAGEL_PRECOMP) -s -o $@ $<
.xml.m:
	$(RAGEL_CODEGEN) -o $@ $<
.xml.dot:
	$(RAGEL_DOT) -p -o $@ $<

