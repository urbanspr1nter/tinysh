#include "config.h"
#include "common.h"

static struct Configuration* config;

char* prompt(bool isMultiLine) {
    if (isMultiLine) {
        return linenoise("");
    }

    return linenoise(config->promptString);
}

/**
 * All commands will be handled here...
 */
void handleCommand(String* command) {
    printf("%s\n", command->text);
}

int main(void) {
    linenoiseSetMultiLine(1);

    config = config_loadConfiguration(config, "config.json");    

    String* exitToken = NULL;
    String* multiLineToken = NULL;
    String* newLineToken = NULL;

    exitToken = cstring_create(exitToken, "exit");
    multiLineToken = cstring_create(multiLineToken, "```");
    newLineToken = cstring_charToString(newLineToken, '\n');

    String* input = NULL;
    char* line = NULL;

    bool isMultiLine = false;
    String* invoke = NULL;
    String* invokeTrimmed = NULL;
    invoke = cstring_create(invoke, "");

    while ((line = prompt(isMultiLine)) != NULL) {
        input = cstring_create(input, line);
        logLog("Got raw input: [%s], length: [%d]", input->text, input->length);

        if (!isMultiLine && cstring_equals(input, exitToken)) {
            break;
        }

        if (cstring_equals(input, multiLineToken)) {
            isMultiLine = !isMultiLine;
            if (isMultiLine) {
                goto reinitialize_prompt;
            }
        }

        if (!cstring_equals(input, multiLineToken)) {
            invoke = cstring_concat(invoke, 3, invoke, input, newLineToken);
        }

        if (isMultiLine) {
            goto reinitialize_prompt;
        }

        if (cstring_equals(invoke, newLineToken)) {
            printf("No command entered.\n");
            goto reinitialize_prompt;
        }
        
        invokeTrimmed = cstring_trim(invokeTrimmed, invoke);
        linenoiseHistoryAdd(invokeTrimmed->text);
        handleCommand(invokeTrimmed);

reinitialize_prompt:
        if (input != NULL) {
            cstring_free(input);
            input = NULL;
        }

        if (invokeTrimmed != NULL) {
            cstring_free(invokeTrimmed);
            invokeTrimmed = NULL;
        }

        if (invoke != NULL) {
            cstring_free(invoke);
            invoke = NULL;
        }

        linenoiseFree(line);

        invoke = cstring_create(invoke, "");
    }

    return 0;
}