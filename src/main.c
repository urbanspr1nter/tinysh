#include "config.h"
#include "common.h"
#include "driver/replc.h"

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
    String* replc;
    replc = cstring_create(replc, "replc");
    if (cstring_equals(config->driver, replc)) {
        if (config->debug) {
            logLog("handling command with replc: [%s]", command->text);
        }
        replc_handleCommand(command);
    } else {
        printf("Generic handling: [%s]\n", command->text);
    }
}

int main(void) {
    linenoiseSetMultiLine(1);

    config = config_loadConfiguration("/home/rngo/code/tinysh/zig-out/bin/config.json");    
    if (config->debug) {
        logLog("Configuration loaded.");
        logLog("\tpromptString: %s", config->promptString->text);
        logLog("\tdriver: %s", config->driver->text);
        logLog("\ttempFolder: %s", config->tempFolder->text);
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

    while ((line = prompt(isMultiLine)) != NULL) {
        input = cstring_create(input, line);

        if (config->debug) {
            logLog("input: [%s], length: [%d]", input->text, input->length);
        }

        if (!isMultiLine && input->length == 0) {
            continue;
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
            if (config->debug) {
                logLog("invoke length: %d\n", invoke->length);
            }

            // We need to make sure the invocation string is not empty, because
            // because we don't want to inadvertently concat to an invalid string (invoke).
            if (invoke->length != 0) {
                invoke = cstring_concat(invoke, 3, invoke, input, newLineToken);
            } else {
                invoke = cstring_concat(invoke, 2, input, newLineToken);
            }
        }

        if (isMultiLine) {
            goto reinitialize_prompt;
        }

        if (cstring_equals(invoke, newLineToken)) {
            printf("No command entered.\n");
            goto reinitialize_prompt;
        }

        String* invokeTrimmed = NULL; 
        invokeTrimmed = cstring_trim(invokeTrimmed, invoke);
        linenoiseHistoryAdd(invokeTrimmed->text);

        if (config->debug) {
            logLog("trimmed command: [%s]", invokeTrimmed->text);
        }

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