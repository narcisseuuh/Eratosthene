from pwn import *


def main():
    p = process(['./eratosthene', 1000]) # printing prime numbers up to 1000

    res = p.recvall()

    res = res.split(b'\n')

    values = [int(term) for term in res[:-1]]

    print(values)

    return 0


if __name__ == '__main__':
    main()