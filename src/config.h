#ifndef TINYSH_CONFIG_H
#define TINYSH_CONFIG_H

#include "common.h"

struct Configuration {
    char* promptString;
};

struct Configuration* config_loadConfiguration(struct Configuration* config, char* filepath);
void config_freeConfiguration(struct Configuration* config);

#endif