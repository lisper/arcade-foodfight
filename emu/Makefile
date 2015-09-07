
TARGET = emu
OBJS = emu.o video.o
CFLAGS = -O2 -Ifame/include -g
LDFLAGS = -Lfame/x86/linux
CC = gcc
STRIP = strip

$(TARGET) : $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $(TARGET) -lfame -lSDL
#	$(STRIP) $(TARGET)

all: $(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)

