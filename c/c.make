# Include this file at the end of project specific Makefile

# Use make V=1 to see verbose output
quiet-command = $(if $(V),$1,$(if $2,@echo $2 && $1, @$1))

# Pass additional options as the first argument.
# We can use also use target/pattern specific Variables to redefine LDFLAGS,
# but that's not clear and flexible as this approach.
cc-link = $(call quiet-command, $(CC) $^ $(LDFLAGS) -o $@ $1, "  LINK  $@")
cxx-link = $(call quiet-command, $(CXX) $^ $(CXXLDFLAGS) -o $@ $1, "  LINK  $@")

%.o: %.c
	$(call quiet-command, $(CC) $(CFLAGS) -c -o $@ $<, "  CC    $@")
%.o: %.cpp
	$(call quiet-command, $(CXX) $(CXXFLAGS) -c -o $@ $<, "  CXX   $@")

# gcc command line options meaning
#   -MM ignores system headers
#   -MT to specify the target
# Generate rules like "foo.d foo.o: foo.c foo.h", so foo.d will get updated
# each time foo.c/h is changed.
.%.d: %.c
	$(call quiet-command, $(CC) -MM -MF $@ -MT $@ -MT $(subst .c,.o, $<) $<, "  DEP   $@")
.%.dpp: %.cpp
	$(call quiet-command, $(CXX) -MM -MF $@ -MT $@ -MT $(subst .cpp,.o, $<) $<, "  DEP   $@")

dependencies = $(patsubst %.c, .%.d, $(wildcard *.c))
dependencies += $(patsubst %.cpp, .%.dpp, $(wildcard *.cpp))
# It's possible to use foreach to include files in several directories
# dependencies = $(patsubst %.c, $(DEPDIR)/%.d, $(foreach dir, ., $(wildcard $(dir)/*.c)))))

ifeq ($(MAKECMDGOALS), clean)
else
ifeq ($(MAKECMDGOALS), distclean)
else
-include $(dependencies)
endif
endif

# Make these file as final target
%.c:
%.cpp:
%.h:
%.hpp:
%.o:

# vim: ft=make
