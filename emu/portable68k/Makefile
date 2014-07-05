
DEBUG ?= 0
name := portable68k


objects := 68k 68kexception main results tester

INC := . lib/
INC_PARAM = $(foreach d, $(INC), -I$d)

ifeq ($(OS),Windows_NT)
	platform := win
    delete = del $(subst /,\,$1)
else
  uname := $(shell uname -a)
  ifeq ($(uname),)
    platform := win
    delete = del $(subst /,\,$1)
  else ifneq ($(findstring Msys,$(uname)),)
    platform := win
    # Msys blocks win native del function
    delete = rm -f $1
  else ifneq ($(findstring MINGW,$(uname)),)
    platform := win
    delete = del $(subst /,\,$1)
  else ifneq ($(findstring Windows,$(uname)),)
    platform := win
    delete = del $(subst /,\,$1)
  else ifneq ($(findstring CYGWIN,$(uname)),)
    platform := win
    delete = del $(subst /,\,$1)
  else ifneq ($(findstring Darwin,$(uname)),)
    platform := osx
    delete = rm -f $1
  else
    platform := x
    delete = rm -f $1
  endif
endif

ifeq ($(compiler),)
  ifeq ($(platform),win)
    compiler := gcc
  else ifeq ($(platform),osx)
    compiler := gcc-mp-4.7
  else
#    compiler := gcc-4.7
    compiler := gcc
  endif
endif

c := $(compiler) -std=gnu99
cpp := $(subst cc,++,$(compiler)) -std=gnu++0x

flags := $(INC_PARAM)
link := -static -static-libgcc -static-libstdc++

ifeq ($(DEBUG), 0)
  flags += -O3 -fomit-frame-pointer
  link += -s
else
  flags += -O0 -g -Wall
endif

compile = \
  $(strip \
    $(if $(filter %.c,$<), \
      $(c) $(flags) $1 -c $< -o $@, \
	$(if $(filter %.cpp,$<), \
	  $(cpp) $(flags) $1 -c $< -o $@ \
	) \
  ) \
)

%.o: $<; $(call compile)

all: build;

obj/main.o:	main.cpp
obj/results.o:	results.cpp
obj/tester.o:	tester.cpp

obj/68k.o: 68k/68k.cpp
obj/68kexception.o: 68k/exception.cpp


objects := $(patsubst %,obj/%.o,$(objects))

build: $(objects)
	$(cpp) -o out/$(name) $(objects) $(link)


clean:
	-@$(call delete,obj/*.o)

