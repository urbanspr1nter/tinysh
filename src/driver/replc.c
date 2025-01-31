#include <unistd.h>
#include <sys/wait.h>
#include "replc.h"

void replc_handleCommand(String* command) {
    String* sourceFile;
    sourceFile = cstring_create(sourceFile, "/main.c");

    String* path;
    path = cstring_concat(path, 2, config->tempFolder, sourceFile);

    if (config->debug) {
        logLog("The path for the file is: [%s]", path->text);
    }

    FILE* output = fopen(path->text, "w");
    if (output == NULL) {
        logFatal("replc - failed to open file for writing.");
        exit(1);
    }
    
    fwrite(command->text, sizeof(char), command->length, output);
    fclose(output);

    String* executableName;
    executableName = cstring_create(executableName, "/a.out");
    
    String* executablePath;
    executablePath = cstring_concat(executablePath, 2, config->tempFolder, executableName);
    
    // Compile the file
    pid_t childGcc = fork();
    if (childGcc == 0) {
        // child
        char* args[] = {"gcc", path->text, "-o", executablePath->text, NULL};
        execvp("gcc", args);    
        
        exit(0);
    }  

    pid_t waitPid;
    int status;

    do {
        waitPid = waitpid(childGcc, &status, WUNTRACED);
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));


    pid_t childProgram = fork();
    if (childProgram == 0) {
        char* args[] = {executablePath->text, NULL};
        execvp(executablePath->text, args); 

        exit(0);
    }

    do {
        waitPid = waitpid(childProgram, &status, WUNTRACED);
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));

    printf("--- Done Execution --\n");
}

