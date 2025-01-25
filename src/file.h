#ifndef TINYSH_FILE_H
#define TINYSH_FILE_H

#include "common.h"

struct File {
    uint64_t size;
    char* data;
};

struct File* file_readAllText(struct File* result, const char* path);
void file_freeFile(struct File* f);

#endif
