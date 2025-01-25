#include "memory.h"

void* safe_malloc(size_t size) {
    void* ptr = malloc(size);
    
    if (ptr == NULL) {
        fprintf(stderr, "Could not allocate memory.\n");
        exit(1);
    }

    return ptr;
}

void safe_free(void *ptr) {
    free(ptr);
}