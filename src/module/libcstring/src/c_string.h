#ifndef LIB_C_STRING_H
#define LIB_C_STRING_H

#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>

extern struct String {
	char* text;
	uint32_t length;
};

extern struct StringList {
	struct String** strings;
	uint32_t length;
};

typedef struct String String;
typedef struct StringList StringList;

String* cstring_create(String* result, const char* s);
String* cstring_concat(String* result, uint32_t count, ...);
String* cstring_ltrim(String* result, String* s);
String* cstring_rtrim(String* result, String* s);
String* cstring_trim(String* result, String* s);
StringList* cstring_split(StringList* result, String* s, const char separator);
void cstring_free(String* s);
bool cstring_equals(String* s, String* t);
bool cstring_startsWith(String* s, String* t);
bool cstring_endsWith(String* s, String* t);
bool cstring_isSubstring(String* s, String* t);
String* cstring_charToString(String* result, const char c);
int32_t cstring_indexOf(String* s, String* t);

#endif
