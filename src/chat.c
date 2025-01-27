#include "chat.h"



CURL* chat_configureChatApiSender(struct Configuration*, struct curl_slist** headers) {
    CURL* curl = curl_easy_init();
    if (!curl) {
        logFatal("Failed to initialize curl");
        exit(1);
    }

    curl_easy_setopt(curl, CURLOPT_URL, config->apiEndpoint->text);

}