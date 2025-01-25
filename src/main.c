#include "config.h"
#include "common.h"

int main(void) {
    struct Configuration* config;
    config = config_loadConfiguration(config, "config.json");    
    printf("%s \n", config->promptString);
    return 0;
}