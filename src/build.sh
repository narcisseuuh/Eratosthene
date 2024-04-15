nasm -f elf64 eratosthene.asm -o eratosthene.o
gcc eratosthene.o -o eratosthene

mv eratosthene ../eratosthene