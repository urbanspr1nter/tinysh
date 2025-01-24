const std = @import("std");
const c_string = @cImport({
    @cInclude("c_string.h");
});

pub fn main() !void {}

pub fn toZigStr(input: [*c]u8) []u8 {
    return std.mem.span(input);
}

test "creates a string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.testing.expectEqualStrings("hello world", toZigStr(buffer.*.text));
    try std.testing.expectEqual(11, buffer.*.length);
}

test "creates an empty string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "");

    try std.testing.expectEqualStrings("", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 0);
}

test "frees a string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.testing.expectEqualStrings("hello world", toZigStr(buffer.*.text));

    c_string.cstring_free(buffer);
}

test "checks if strings are equal" {
    var buffer_1: [*c]c_string.String = undefined;

    buffer_1 = c_string.cstring_create(buffer_1, "test string");

    var buffer_2: [*c]c_string.String = undefined;

    buffer_2 = c_string.cstring_create(buffer_2, buffer_1.*.text);

    try std.testing.expect(c_string.cstring_equals(buffer_1, buffer_2));
}

test "concatenation of a single string" {
    var buffer_1: [*c]c_string.String = undefined;
    buffer_1 = c_string.cstring_create(buffer_1, "hello");

    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_concat(buffer, 1, buffer_1);

    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 5);
}

test "concatenation of no strings" {
    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_concat(buffer, 0, @as([*c]c_string.String, null));

    try std.testing.expectEqualStrings("", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 0);
}

test "concatenation of multiple strings" {
    var buffer_1: [*c]c_string.String = undefined;
    buffer_1 = c_string.cstring_create(buffer_1, "hello");

    var buffer_2: [*c]c_string.String = undefined;
    buffer_2 = c_string.cstring_create(buffer_2, "world");

    var buffer_3: [*c]c_string.String = undefined;
    buffer_3 = c_string.cstring_create(buffer_3, "bye");

    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_concat(buffer, 3, buffer_1, buffer_2, buffer_3);

    try std.testing.expectEqualStrings("helloworldbye", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 13);
}

test "splits a string by spaces" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello world how are you");
    buffer = c_string.cstring_split(buffer, str, ' ');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits a string by commas" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello,world,how,are,you");
    buffer = c_string.cstring_split(buffer, str, ',');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits a string by tabs" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello\tworld\thow\tare\tyou");
    buffer = c_string.cstring_split(buffer, str, '\t');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits only 1 word" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello");
    buffer = c_string.cstring_split(buffer, str, ' ');

    try std.testing.expect(buffer.*.length == 1);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
}

test "left trims a string" {
    var buffer: [*c]c_string.String = undefined;

    var sample: [*c]c_string.String = undefined;
    sample = c_string.cstring_create(sample, "                       hello ");

    buffer = c_string.cstring_ltrim(buffer, sample);

    try std.testing.expectEqualStrings("hello ", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 6);
}

test "right trims a string" {
    var buffer: [*c]c_string.String = undefined;

    var sample: [*c]c_string.String = undefined;
    sample = c_string.cstring_create(sample, "hello                                   ");

    buffer = c_string.cstring_rtrim(buffer, sample);

    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 5);
}

test "trims a string" {
    var buffer: [*c]c_string.String = undefined;

    var sample: [*c]c_string.String = undefined;
    sample = c_string.cstring_create(sample, "                          hello               ");

    buffer = c_string.cstring_trim(buffer, sample);

    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 5);
}

test "string starts with positive case" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello, hello there!");
    sample = c_string.cstring_create(sample, "hello");

    try std.testing.expect(c_string.cstring_startsWith(buffer, sample));
}

test "string starts with negative case" {
    var buffer: [*c]c_string.String = undefined;

    var sample: [*c]c_string.String = undefined;
    sample = c_string.cstring_create(sample, "orld");

    buffer = c_string.cstring_create(buffer, "hello world");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string ends with positive case" {
    var buffer: [*c]c_string.String = undefined;

    var sample: [*c]c_string.String = undefined;
    sample = c_string.cstring_create(sample, "orld");

    buffer = c_string.cstring_create(buffer, "hello world");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result);
}

test "string ends with negative case" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");
    sample = c_string.cstring_create(sample, "worldz");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string starts with empty buffer" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "");
    sample = c_string.cstring_create(sample, "hello");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string starts with empty sample" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello");
    sample = c_string.cstring_create(sample, "");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == true);
}

test "string starts with identical strings" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello");
    sample = c_string.cstring_create(sample, "hello");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == true);
}

test "string starts with prefix longer than buffer" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello");
    sample = c_string.cstring_create(sample, "hello there");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string starts with case sensitivity" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "Hello");
    sample = c_string.cstring_create(sample, "hello");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string starts with whitespace prefix" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, " hello");
    sample = c_string.cstring_create(sample, "hello");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string starts with special characters" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "!@#hello");
    sample = c_string.cstring_create(sample, "!@#");

    const result = c_string.cstring_startsWith(buffer, sample);

    try std.testing.expect(result == true);
}

test "string ends with empty buffer" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "");
    sample = c_string.cstring_create(sample, "world");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string ends with empty sample" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");
    sample = c_string.cstring_create(sample, "");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == true);
}

test "string ends with identical strings" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");
    sample = c_string.cstring_create(sample, "hello world");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == true);
}

test "string ends with suffix longer than buffer" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "world");
    sample = c_string.cstring_create(sample, "hello world");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string ends with case sensitivity" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");
    sample = c_string.cstring_create(sample, "WORLD");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string ends with whitespace suffix" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world ");
    sample = c_string.cstring_create(sample, "world");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == false);
}

test "string ends with special characters" {
    var buffer: [*c]c_string.String = undefined;
    var sample: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world!@#");
    sample = c_string.cstring_create(sample, "!@#");

    const result = c_string.cstring_endsWith(buffer, sample);

    try std.testing.expect(result == true);
}
test "splits a string with consecutive delimiters" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello,,world,,how,,are,,you");
    buffer = c_string.cstring_split(buffer, str, ',');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits a string with leading and trailing delimiters" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, ",hello,world,");
    buffer = c_string.cstring_split(buffer, str, ',');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
}

test "splits a string with no delimiters" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "helloworld");
    buffer = c_string.cstring_split(buffer, str, ' ');

    try std.testing.expect(buffer.*.length == 1);
    try std.testing.expectEqualStrings("helloworld", toZigStr(buffer.*.strings[0].*.text));
}

test "splits an empty string" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "");
    buffer = c_string.cstring_split(buffer, str, ' ');

    try std.testing.expect(buffer.*.length == 0);
}

test "splits a string with multiple delimiters" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello,world;how:are you");
    buffer = c_string.cstring_split(buffer, str, ',');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));

    buffer = c_string.cstring_split(buffer, str, ';');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello,world", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("how:are you", toZigStr(buffer.*.strings[1].*.text));

    buffer = c_string.cstring_split(buffer, str, ':');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello,world;how", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("are you", toZigStr(buffer.*.strings[1].*.text));
}

test "splits a string with special characters" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello!@#world$%^how&*are~you");
    buffer = c_string.cstring_split(buffer, str, '!');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("@#world$%^how&*are~you", toZigStr(buffer.*.strings[1].*.text));

    buffer = c_string.cstring_split(buffer, str, '$');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello!@#world", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("%^how&*are~you", toZigStr(buffer.*.strings[1].*.text));

    buffer = c_string.cstring_split(buffer, str, '~');

    try std.testing.expect(buffer.*.length == 2);
    try std.testing.expectEqualStrings("hello!@#world$%^how&*are", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[1].*.text));
}

test "converts a character to a string" {
    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_charToString(buffer, 'a');
    try std.testing.expectEqualStrings("a", toZigStr(buffer.*.text));
}

test "finds the index of occurrence of string given a substring" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello, there");
    substr = c_string.cstring_create(substr, "er");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == 9);
}

test "is substring of another" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello world - how are you?");
    substr = c_string.cstring_create(substr, "ow ar");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(result);
}

test "is substring of another - full match" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello world - how are you?");
    substr = c_string.cstring_create(substr, "hello world - how are you?");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(result);
}

test "is substring of another - not a substring" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello world - how are you?");
    substr = c_string.cstring_create(substr, "goodbye");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(!result);
}

test "is substring of another - empty substring" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello world - how are you?");
    substr = c_string.cstring_create(substr, "");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(!result);
}

test "is substring of another - empty string" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "");
    substr = c_string.cstring_create(substr, "hello");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(!result);
}

test "is substring of another - both empty" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "");
    substr = c_string.cstring_create(substr, "");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(!result);
}

test "is substring of another - case sensitive" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "Hello World - How Are You?");
    substr = c_string.cstring_create(substr, "hello");
    const result = c_string.cstring_isSubstring(str, substr);

    try std.testing.expect(!result);
}

test "finds the index of occurrence of string given a substring - full match" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello, there");
    substr = c_string.cstring_create(substr, "hello, there");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == 0);
}

test "finds the index of occurrence of string given a substring - not found" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello, there");
    substr = c_string.cstring_create(substr, "goodbye");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == -1);
}

test "finds the index of occurrence of string given a substring - empty substring" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello, there");
    substr = c_string.cstring_create(substr, "");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == 0);
}

test "finds the index of occurrence of string given a substring - empty string" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "");
    substr = c_string.cstring_create(substr, "hello");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == -1);
}

test "finds the index of occurrence of string given a substring - both empty" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "");
    substr = c_string.cstring_create(substr, "");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == 0);
}

test "finds the index of occurrence of string given a substring - multiple occurrences" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "banana");
    substr = c_string.cstring_create(substr, "ana");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == 1);
}

test "finds the index of occurrence of string given a substring - case sensitive" {
    var str: [*c]c_string.String = undefined;
    var substr: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "Hello, There");
    substr = c_string.cstring_create(substr, "hello");

    const index = c_string.cstring_indexOf(str, substr);

    try std.testing.expect(index == -1);
}
