#ifndef TINYSH_MESSAGE_H
#define TINYSH_MESSAGE_H

#include "common.h"

enum MessageRole {
    USER,
    ASSISTANT
};

struct Message {
    String* role;
    String* content; 
};

struct Message* message_create(struct Message* result, enum MessageRole role, String* content);
struct Message* message_copy(struct Message* result, struct Message* message);
void message_free(struct Message* message);

#endif
