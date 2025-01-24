#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c_string.h"

static bool isWhitespace(const char c) {
	if (c == ' ' || c == '\n' || c == '\t') {
		return true;
	}
	else {
		return false;
	}
}

String* cstring_create(String* result, const char* s) {
	uint32_t len = strlen(s);

	result = malloc(sizeof(String));	
	if (result == NULL) {
		fprintf(stderr, "Error allocating memory\n");
		exit(1);
	}

	result->text = strdup(s);
	result->length = len;

	return result;	
}

String* cstring_concat(String* result, uint32_t count, ...) {
	uint32_t currLength = 0;

	result = malloc(sizeof(String));
	if (result == NULL) {
		fprintf(stderr, "Error allocating memory\n");
		exit(1);
	}

	result->text = malloc(sizeof(char) * 1);
	if (result->text == NULL) { 
		fprintf(stderr, "Error allocating memory\n");
		exit(1);
	}

	*(result->text) = '\0';

	va_list args;
	va_start(args, count);

	for (uint32_t i = 0; i < count; i++) {
		String* curr = va_arg(args, String*);

		// Add an extra character to realloc an additional character 
		// if it is the last string just enough for the null terminating byte.
		currLength += (curr->length + (i == count - 1 ? 1 : 0));

		result->text = realloc(result->text, sizeof(char) * currLength);		
		if (result->text == NULL) {
			fprintf(stderr, "Error allocating memory\n");
			exit(1);
		}

		result->text = strncat(result->text, curr->text, curr->length);
	}

	va_end(args);

	result->length = strlen(result->text);	

	return result;
}


String* cstring_ltrim(String* result, String* s) {
	result = malloc(sizeof(String));
	if (result == NULL) { 
		fprintf(stderr, "Error allocating memory\n");
		exit(1); 
	}

	char* startPtr;
	for (uint32_t i = 0; i < s->length; i++) {
		if (!isWhitespace(s->text[i])) {
			startPtr = s->text + i;
			break;
		}
	}

	result->text = strdup(startPtr);
	result->length = strlen(result->text);
	
	return result;
}

String* cstring_rtrim(String* result, String* s) {
	result = malloc(sizeof(String));
	if (result == NULL) {
		fprintf(stderr, "Error allocating memory\n");
		exit(1);
	}

	char* workingStr = strdup(s->text);
	for (uint32_t i = s->length - 1; i > 0; i--) {
		if (!isWhitespace(workingStr[i])) {
			*(workingStr + i + 1) = '\0';
			break;
		}
	}

	result->text = workingStr;
	result->length = strlen(result->text);

	return result;
}

String* cstring_trim(String* result, String* s) {
	String* ltrimmed;
	ltrimmed = cstring_ltrim(ltrimmed, s);

	String* rtrimmed;
	rtrimmed = cstring_rtrim(rtrimmed, ltrimmed);

	result = rtrimmed;

	free(ltrimmed);

	return result;
}

StringList* cstring_split(StringList* result, String* s, const char separator) {
	if (s == NULL) {
		fprintf(stderr, "Must provide a string to split.\n");
		exit(1);
	}

	char* copiedString = strdup(s->text);
	
	char* separatorString = malloc(sizeof(char) * 2);
	if (separatorString == NULL) {
		fprintf(stderr, "Couldn't allocate memory for the separator string.\n");	
		exit(1);
	}
	separatorString[0] = separator;
	separatorString[1] = '\0';

	char* savedPtr;
	char* token = strtok_r(copiedString, separatorString, &savedPtr);

	uint32_t elementCount = 0;
	result = malloc(sizeof(StringList));
	if (result == NULL) {
		fprintf(stderr, "Couldn't allocate memory for the result pointer.\n");
		exit(1);
	}

	while (token != NULL) {
		elementCount++;
		result->strings = realloc(result->strings, sizeof(String*) * elementCount);
		if (result->strings == NULL) {
			fprintf(stderr, "Couldn't allocate memory for result strings.\n");
			exit(1);
		}

		uint32_t index = elementCount - 1;
		*(result->strings + index) = cstring_create(result->strings + index, token);

		token = strtok_r(NULL, separatorString, &savedPtr);
	}

	result->length = elementCount;

	free(separatorString);
	free(copiedString);

	return result;	
}

void cstring_free(String* s) {
	if (s->text != NULL) {
		free(s->text);
		s->text = NULL;
	}

	s->length = 0;

	free(s);
}

bool cstring_equals(String* s, String* t) {
	if (s->length != t->length) {
		return false;
	}

	return strcmp(s->text, t->text) == 0;
}

bool cstring_startsWith(String* s, String* t) {
	if (strstr(s->text, t->text) == s->text) {
		return true;
	}

	return false;
}

bool cstring_endsWith(String* s, String* t) {
	if (strstr(s->text, t->text) == NULL) {
		return false;
	}

	if (strlen(t->text) == 0 || strlen(s->text) == 0) {
		return true;
	}

	if (strcmp(strstr(s->text, t->text), t->text) == 0) {
		return true;
	}

	return false;
}

bool cstring_isSubstring(String* s, String* t) {
	if (t->length == 0 || t->text == NULL) {
		return false;
	}

	if (s->length == 0 || s->text == NULL) {
		return false;
	}

	if (strstr(s->text, t->text) != NULL) {
		return true;
	}

	return false;
}

String* cstring_charToString(String* result, const char c) {
	result = malloc(sizeof(String));
	if (result == NULL) {
		fprintf(stderr, "Could not allocate memory.\n");
		exit(1);
	}
	
	char* text = malloc(sizeof(char) * 2);
	if (text == NULL) {
		fprintf(stderr, "Could not allocate memory\n");
		exit(1);
	}

	text[0] = c;
	text[1] = '\0';

	result->text = text;
	result->length = 1;

	return result;
}

int32_t cstring_indexOf(String* s, String* t) {
	if (s->text == NULL || t->text == NULL) {
		return -1;
	}

	if (s->length == 0 && t->length == 0) {
		return 0;
	}
	
	if (s->length == 0) {
		return -1;
	}

	if (t->length == 0) {
		return 0;
	}

	char* ptr = strstr(s->text, t->text);
	if (ptr == NULL) {
		return -1;
	}

	return (int32_t) (ptr - s->text);
}