#Cleaner makefile

CC=gcc
CFLAGS=
LDFLAGS=-lobjc -framework Foundation
EXEC=cleaner
SOURCES=main.m cleaner.m

cleaner:
$(CC) $(SOURCES) $(LDFLAGS) $(CFLAGS) -o $(EXEC)

clean:
rm -rf $(EXEC)