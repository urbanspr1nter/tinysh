#ifndef TINYSH_CHAT_H
#define TINYSH_CHAT_H

#include "common.h"
#include "message.h"
#include "config.h"
#include <curl/curl.h>

struct ChatCompletionChoice {
    String* finish_reason;
    uint64_t index;
    struct Message* message;
};

struct ChatCompletionUsage {
    uint64_t completion_tokens;
    uint64_t prompt_tokens;
    uint32_t total_tokens;
};

struct ChatCompletionResponse {
    struct ChatCompletionChoice** choices;
    uint64_t choicesLength;
    uint64_t created;
    String* model;
    String* object;
    String* systemFingerprint;
    struct ChatCompletionUsage* usage;
    String* id;
};

struct ChatCompletionRequest {
    String* model;
    bool stream;
    float temperature;
    struct Message** messages;
    uint64_t messagesLength;
};

// TODO: these are just ideas. fill them in better.
cJSON* chat_toChatCOmpletionResponseJSON(String* json);
struct ChatCompletionResponse* chat_toChatCompletionResponse(cJSON* jsonResponse);
cJSON* chat_toChatCompletionRequestJSON(struct ChatCompletionRequest* request);
CURL* chat_configureChatApiSender(struct Configuration* config, struct curl_slist** headers);
struct ChatCompletionResponse* chat_sendChatCompletionRequest(CURL* curl, struct ChatCompletionRequest* request);
struct ChatCompletionRequest* chat_buildChatCompletionRequest(struct Configuration* config);

void chat_freeChatCompletionRequest(struct ChatCompletionRequest* request);
void chat_freeChatCompletionResponse(struct ChatCompletionResponse* response);

#endif 