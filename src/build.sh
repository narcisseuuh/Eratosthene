nasm -f elf64 eratosthene.asm -o eratosthene.o
gcc -no-pie -fPIE eratosthene.o -o eratosthene

mv eratosthene ../eratosthene