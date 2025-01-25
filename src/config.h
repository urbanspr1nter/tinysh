#ifndef TINYSH_CONFIG_H
#define TINYSH_CONFIG_H

#include "common.h"

struct Configuration {
    char* promptString;
    char* driver;
    bool debug;
};

extern struct Configuration* config;

struct Configuration* config_loadConfiguration(char* filepath);
void config_freeConfiguration(struct Configuration* config);

#endif