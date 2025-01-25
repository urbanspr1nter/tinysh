#ifndef TINYSH_JSONUTIL_H
#define TINYSH_JSONUTIL_H

#include "common.h"

/**
 * Gets the length of a JSON array
 */
uint64_t jsonutil_getJsonArrayLength(cJSON* jsonArray);

/**
 * A helper to get a bool value from a cJSON pointer.
 */
bool jsonutil_getBoolFromJson(cJSON* value);

#endif