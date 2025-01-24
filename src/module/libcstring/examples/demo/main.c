#include <stdio.h>
#include <stdbool.h>
#include <c_string.h>

int main(void) {
    String* result;
    result = cstring_create(result, "hello world");
    
    String* s;
    s = cstring_create(s, "world");
    
    int occurrence = cstring_indexOf(result, s);
    printf("occurrence of world in hello world: %d, expected: 6\n", occurrence);

    cstring_free(s);
    s = cstring_create(s, "worldzzz");

    occurrence = cstring_indexOf(result, s);
    printf("occurrence of worldzzz in hello world: %d, expected: -1\n", occurrence);
    cstring_free(s);

    printf("text: %s, length: %d\n", result->text, result->length);

    return 0;
}