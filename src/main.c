#include "config.h"
#include "common.h"

char* prompt(bool isMultiLine) {
    if (isMultiLine) {
        return linenoise("");
    }

    return linenoise(config->promptString->text);
}

/**
 * All commands will be handled here...
 */
void handleCommand(String* command) {
    printf("%s\n", command->text);
}

int main(void) {
    linenoiseSetMultiLine(1);

    config = config_loadConfiguration("config.json");    
    if (config->debug) {
        logLog("Configuration loaded.");
        logLog("\tpromptString: %s", config->promptString->text);
        logLog("\tdebug: %d", config->debug);
    }

    String* exitToken = NULL;
    String* multiLineToken = NULL;
    String* newLineToken = NULL;

    exitToken = cstring_create(exitToken, "exit");
    multiLineToken = cstring_create(multiLineToken, "```");
    newLineToken = cstring_charToString(newLineToken, '\n');

    String* input = NULL;
    input = cstring_create(input, "");

    char* line = NULL;

    bool isMultiLine = false;

    String* invoke = NULL;
    invoke = cstring_create(invoke, "");

    String* invokeTrimmed = NULL;
    invokeTrimmed = cstring_create(invokeTrimmed, "");

    while ((line = prompt(isMultiLine)) != NULL) {
        input = cstring_create(input, line);

        if (config->debug) {
            logLog("input: [%s], length: [%d]", input->text, input->length);
        }

        if (!isMultiLine && cstring_equals(input, exitToken)) {
            break;
        }

        if (cstring_equals(input, multiLineToken)) {
            isMultiLine = !isMultiLine;
            if (config->debug) {
                logLog("multiLineToken read. new state: %d", isMultiLine);
            }

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

        if (invokeTrimmed != NULL) {
            cstring_free(invokeTrimmed);
            invokeTrimmed = NULL;
        }

        if (invoke != NULL) {
            cstring_free(invoke);
            invoke = NULL;
        }

        invoke = cstring_create(invoke, "");

reinitialize_prompt:
        if (input != NULL) {
            cstring_free(input);
            input = NULL;
        }

        linenoiseFree(line);
    }


    cstring_free(exitToken);
    cstring_free(multiLineToken);
    cstring_free(newLineToken);

    return 0;
}