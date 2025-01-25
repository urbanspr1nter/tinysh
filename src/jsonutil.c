#include "jsonutil.h"

/**
 * Gets the length of a JSON array
 */
uint64_t jsonutil_getJsonArrayLength(cJSON* jsonArray) {
    uint64_t result = 0;

    cJSON* jsonElement;
    cJSON_ArrayForEach(jsonElement, jsonArray) {
        result++;
    }

    return result;
}

/**
 * A helper to get a bool value from a cJSON pointer.
 */
bool jsonutil_getBoolFromJson(cJSON* value) {
    if (cJSON_IsTrue(value)) {
        return true;
    }

    return false;
}
