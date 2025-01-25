#include "file.h"

static uint64_t fileSize(char* path) {
    FILE* fp = fopen(path, "r");
    if (fp == NULL) {
        return 0;
    }

    // Seek to the end of the file to find the number of bytes
    fseek(fp, 0, SEEK_END);
    uint64_t filesize = ftell(fp);

    fclose(fp);

    return filesize;
}

struct File* file_readAllText(struct File* result, char* path) {
    size_t filesize = fileSize(path);

    if (!filesize) {
        result = malloc(sizeof(struct File));
        result->data = NULL;
        result->size = filesize;

        return result;
    }

    FILE* fp = fopen(path, "r");

    // Could not read the file successfully, quit early
    if (fp == NULL) {
        return NULL;
    }

    size_t contentLength = sizeof(char) * filesize + 1;
    char* content = malloc(contentLength);
    fread(content, sizeof(char), filesize, fp);
    *(content + contentLength - 1) = 0;

    fclose(fp);

    result = malloc(sizeof(struct File));
    result->data = content;
    result->size = filesize;

    return result;
}

void file_freeFile(struct File* f) {
    if (f->data != NULL) {
        safe_free(f->data);
    }

    safe_free(f);
}