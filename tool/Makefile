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

SOURCES            = gdiff.m WOChange.m WODiff.m WOFile.m
RAGEL_PRECOMP_SRCS = WODiffMachine.rl
RAGEL_PRECOMP_OBJS = WODiffMachine.xml
RAGEL_CODEGEN_OBJS = WODiffMachine.m
RAGEL_DOT_OBJS     = WODiffMachine.dot
RAGEL_GRAPHS       = WODiffMachine.png
OBJECTS            = WODiffMachine.o
CLEANOBJS          = *.o gdiff

#
# Rules
#

all: gdiff

gdiff: $(RAGEL_CODEGEN_OBJS) $(SOURCES)
	$(CC) -std=gnu99 -framework Foundation -o $@ $(RAGEL_CODEGEN_OBJS) $(SOURCES)

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

