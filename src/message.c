#include "message.h"

static struct Message* allocateMessage(struct Message* result) {
    result = safe_malloc(sizeof(struct Message));
    result->role = NULL;
    result->content = NULL;

    return result;
}

struct Message* message_create(struct Message* result, enum MessageRole role, String* content) {
    result = allocateMessage(result);

    String* roleStr = NULL;
    switch (role) {
        case USER:
            roleStr = cstring_create(roleStr, "user");
            break;
        case ASSISTANT:
            roleStr = cstring_create(roleStr, "assistant");
            break;
        default:
            roleStr = cstring_create(roleStr, "system");
            break; 
            
    } 
    result->role = roleStr;
    result->content = content;
    
    return result;
}

struct Message* message_copy(struct Message* result, struct Message* message) {
    result = allocateMessage(result);

    result->role = cstring_create(result->role, message->role->text);
    result->content = cstring_create(result->content, message->content->text);

    return result;
}

void message_free(struct Message* message) {
    if (message == NULL) {
        return;
    }

    if (message->role) {
        cstring_free(message->role);
    }

    if (message->content) {
        cstring_free(message->content);
    }

    free(message);
}