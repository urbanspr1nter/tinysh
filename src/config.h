#ifndef TINYSH_CONFIG_H
#define TINYSH_CONFIG_H

#include "common.h"

struct Configuration {
    String* promptString;
    String* driver;
    String* apiEndpoint;
    String* tempFolder;
    bool debug;
};

extern struct Configuration* config;

struct Configuration* config_loadConfiguration(char* filepath);
void config_freeConfiguration();

#endif