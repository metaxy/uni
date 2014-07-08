CC=gcc
MAKEDEPEND=makedepend
CFLAGS=-Wall -std=gnu99 -O0 -g
LDFLAGS=-g

all: GoBackNSender GoBackNReceiver

depend:
	$(MAKEDEPEND) -- $(CFLAGS) -- *.c

clean:
	rm -f *.o GoBackNSender GoBackNReceiver

GoBackNSender: GoBackNSender.o DataBuffer.o SocketConnection.o GoBackNMessageStruct.o

GoBackNReceiver: GoBackNReceiver.o SocketConnection.o GoBackNMessageStruct.o

# DO NOT DELETE

# clock_getres.o: /usr/include/stdlib.h /usr/include/features.h
# clock_getres.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
# #clock_getres.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stddef.h
# clock_getres.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stddef.h
# clock_getres.o: /usr/include/stdio.h /usr/include/bits/types.h
# clock_getres.o: /usr/include/bits/wordsize.h /usr/include/bits/typesizes.h
# clock_getres.o: /usr/include/libio.h /usr/include/_G_config.h
# clock_getres.o: /usr/include/wchar.h /usr/include/bits/wchar.h
# clock_getres.o: /usr/include/gconv.h
# #clock_getres.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stdarg.h
# clock_getres.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdarg.h
# clock_getres.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
# clock_getres.o: /usr/include/sys/time.h /usr/include/time.h
# clock_getres.o: /usr/include/bits/time.h /usr/include/sys/select.h
# clock_getres.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
# DataBuffer.o: DataBuffer.h GoBackNMessageStruct.h /usr/include/stdint.h
# DataBuffer.o: /usr/include/features.h /usr/include/sys/cdefs.h
# DataBuffer.o: /usr/include/gnu/stubs.h /usr/include/bits/wchar.h
# DataBuffer.o: /usr/include/bits/wordsize.h /usr/include/stdlib.h
# #DataBuffer.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stddef.h
# DataBuffer.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stddef.h
# DataBuffer.o: /usr/include/string.h
# #DataBuffer.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stdbool.h
# DataBuffer.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdbool.h
# DataBuffer.o: /usr/include/assert.h
# GoBackNReceiver.o: /usr/include/assert.h /usr/include/features.h
# GoBackNReceiver.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
# GoBackNReceiver.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
# GoBackNReceiver.o: /usr/include/bits/types.h /usr/include/bits/wordsize.h
# #GoBackNReceiver.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stddef.h
# GoBackNReceiver.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stddef.h
# GoBackNReceiver.o: /usr/include/bits/typesizes.h /usr/include/bits/confname.h
# GoBackNReceiver.o: /usr/include/stdio.h /usr/include/libio.h
# GoBackNReceiver.o: /usr/include/_G_config.h /usr/include/wchar.h
# GoBackNReceiver.o: /usr/include/bits/wchar.h /usr/include/gconv.h
# #GoBackNReceiver.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stdarg.h
# GoBackNReceiver.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdarg.h
# GoBackNReceiver.o: /usr/include/bits/stdio_lim.h
# GoBackNReceiver.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
# GoBackNReceiver.o: /usr/include/getopt.h
# #GoBackNReceiver.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stdbool.h
# GoBackNReceiver.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdbool.h
# GoBackNReceiver.o: /usr/include/sys/select.h /usr/include/bits/select.h
# GoBackNReceiver.o: /usr/include/bits/sigset.h /usr/include/time.h
# GoBackNReceiver.o: /usr/include/bits/time.h /usr/include/sys/time.h
# GoBackNReceiver.o: /usr/include/sys/types.h /usr/include/sys/socket.h
# GoBackNReceiver.o: /usr/include/sys/uio.h /usr/include/bits/uio.h
# GoBackNReceiver.o: /usr/include/bits/socket.h /usr/include/limits.h
# #GoBackNReceiver.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/limits.h
# GoBackNReceiver.o: /usr/include/linux/limits.h
# GoBackNReceiver.o: /usr/include/bits/sockaddr.h /usr/include/asm/socket.h
# GoBackNReceiver.o: /usr/include/asm/sockios.h /usr/include/netdb.h
# GoBackNReceiver.o: /usr/include/netinet/in.h /usr/include/stdint.h
# GoBackNReceiver.o: /usr/include/bits/in.h /usr/include/endian.h
# GoBackNReceiver.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
# GoBackNReceiver.o: /usr/include/bits/netdb.h /usr/include/netinet/tcp.h
# GoBackNReceiver.o: timeval_macros.h
# GoBackNSender.o: /usr/include/unistd.h /usr/include/features.h
# GoBackNSender.o: /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h
# GoBackNSender.o: /usr/include/bits/posix_opt.h /usr/include/bits/types.h
# GoBackNSender.o: /usr/include/bits/wordsize.h
# #GoBackNSender.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stddef.h
# GoBackNSender.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stddef.h
# GoBackNSender.o: /usr/include/bits/typesizes.h /usr/include/bits/confname.h
# GoBackNSender.o: /usr/include/stdio.h /usr/include/libio.h
# GoBackNSender.o: /usr/include/_G_config.h /usr/include/wchar.h
# GoBackNSender.o: /usr/include/bits/wchar.h /usr/include/gconv.h
# #GoBackNSender.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stdarg.h
# GoBackNSender.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdarg.h
# GoBackNSender.o: /usr/include/bits/stdio_lim.h
# GoBackNSender.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
# GoBackNSender.o: /usr/include/getopt.h
# #GoBackNSender.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/stdbool.h
# GoBackNSender.o: /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stdbool.h
# GoBackNSender.o: /usr/include/sys/select.h /usr/include/bits/select.h
# GoBackNSender.o: /usr/include/bits/sigset.h /usr/include/time.h
# GoBackNSender.o: /usr/include/bits/time.h /usr/include/sys/time.h
# GoBackNSender.o: /usr/include/sys/types.h /usr/include/sys/socket.h
# GoBackNSender.o: /usr/include/sys/uio.h /usr/include/bits/uio.h
# GoBackNSender.o: /usr/include/bits/socket.h /usr/include/limits.h
# #GoBackNSender.o: /usr/lib/gcc-lib/i486-linux/3.3.5/include/limits.h
# GoBackNSender.o: /usr/include/linux/limits.h
# GoBackNSender.o: /usr/include/bits/sockaddr.h /usr/include/asm/socket.h
# GoBackNSender.o: /usr/include/asm/sockios.h /usr/include/netdb.h
# GoBackNSender.o: /usr/include/netinet/in.h /usr/include/stdint.h
# GoBackNSender.o: /usr/include/bits/in.h /usr/include/endian.h
# GoBackNSender.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
# GoBackNSender.o: /usr/include/bits/netdb.h /usr/include/netinet/tcp.h
# GoBackNSender.o: timeval_macros.h DataBuffer.h GoBackNMessageStruct.h
# GoBackNSender.o: /usr/include/string.h
