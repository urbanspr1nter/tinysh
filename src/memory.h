#ifndef TINYSH_MEMORY_H
#define TINYSH_MEMORY_H

#include "common.h"

void* safe_malloc(size_t size);
void safe_free(void *ptr);

#endif