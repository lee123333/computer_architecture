uint16_t count_trailing_ones(uint32_t x) {
    x = ~x;
    x |= (x << 1);
    x |= (x << 2);
    x |= (x << 4);
    x |= (x << 8);
    x |= (x << 16);
    
    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x3f));
}

uint16_t count_trailing_zeros(uint32_t x) {
    x |= (x << 1);
    x |= (x << 2);
    x |= (x << 4);
    x |= (x << 8);
    x |= (x << 16);
    
    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x3f));
}

int integerReplacement(int n) {
    uint32_t x = *(uint32_t *)&n;
    int count = 0;
    while (x != 1) {
        if (x & 1) {
            int count_trailing_one = count_trailing_ones(x);
            if (count_trailing_one > 1 && x > 3) {
                x++;
                x >>= count_trailing_one;
                count = count + count_trailing_one + 1;
            } else if (count_trailing_one == 32) {
                return 33;
            } else {
                x--;
                x >>= 1;
                count = count + 2;
            }
        } else {
            int count_trailing_zero = count_trailing_zeros(x);
            x >>= count_trailing_zero;
            count = count + count_trailing_zero;
        }
    }
    return count;
}

int main() {
    int n = 16773120;  
    int n1 = 2;  
    int n2 = 2130708480;  

    int result = integerReplacement(n);
    int result1 = integerReplacement(n1);
    int result2 = integerReplacement(n2);
    printf("The number of steps to reduce %d to 1 is: %d\n", n, result);
    printf("The number of steps to reduce %d to 1 is: %d\n", n, result1);
    printf("The number of steps to reduce %d to 1 is: %d\n", n, result2);
    return 0;
}

