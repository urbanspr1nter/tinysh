#include "config.h"
#include "file.h"
#include "jsonutil.h"

struct Configuration* config = NULL;

struct Configuration* config_loadConfiguration(char* filepath) {
    struct File* f;
    f = file_readAllText(f, filepath);

    if (f == NULL) {
        fprintf(stderr, "Couldn't read the configuration file from disk.\n");
        exit(1);
    }
    
    if (f->data == NULL || f->size == 0) {
        fprintf(stderr, "No data in the configuration file.\n");
        exit(1);
    }

    cJSON* jsonConfig = cJSON_Parse(f->data);

    file_freeFile(f);

    config = malloc(sizeof(struct Configuration));
    
    String* configPromptStringValue;
    configPromptStringValue = cstring_create(
        configPromptStringValue,
        cJSON_GetObjectItemCaseSensitive(jsonConfig, "promptString")->valuestring
    );
    config->promptString = configPromptStringValue;

    String* configDriverValue;
    configDriverValue = cstring_create(
        configDriverValue,
        cJSON_GetObjectItemCaseSensitive(jsonConfig, "driver")->valuestring
    );
    config->driver = configDriverValue;
    
    String* configApiEndpointValue;
    configApiEndpointValue = cstring_create(
        configApiEndpointValue,
        cJSON_GetObjectItemCaseSensitive(jsonConfig, "apiEndpoint")->valuestring
    );
    config->apiEndpoint = configApiEndpointValue;

    String* configTempFolderValue;
    configTempFolderValue = cstring_create(
        configTempFolderValue,
        cJSON_GetObjectItemCaseSensitive(jsonConfig, "tempFolder")->valuestring
    );
    config->tempFolder = configTempFolderValue;

    config->debug = jsonutil_getBoolFromJson(cJSON_GetObjectItemCaseSensitive(jsonConfig, "debug"));

    cJSON_Delete(jsonConfig);

    return config;
}

void config_freeConfiguration() {
    cstring_free(config->promptString);
    cstring_free(config->driver);
    cstring_free(config->apiEndpoint);
    cstring_free(config->tempFolder);
    free(config);
}