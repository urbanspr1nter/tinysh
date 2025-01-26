const std = @import("std");
const cModule = @cImport({
    @cInclude("message.h");
    @cInclude("c_string.h");
});

pub fn toZigStr(input: [*c]u8) []u8 {
    return std.mem.span(input);
}

test "creates a message" {
    var role: [*c]cModule.String = undefined;
    role = cModule.cstring_create(role, "user");

    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, "how are you?");

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, cModule.USER, content);

    try std.testing.expectEqualStrings("how are you?", toZigStr(message.*.content.*.text));
}

test "copies a message" {
    var role: [*c]cModule.String = undefined;
    role = cModule.cstring_create(role, "user");

    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, "how are you?");

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, cModule.ASSISTANT, content);

    var copiedMessage: [*c]cModule.Message = undefined;
    copiedMessage = cModule.message_copy(copiedMessage, message);

    try std.testing.expect(cModule.cstring_equals(message.*.content, copiedMessage.*.content));
    try std.testing.expect(cModule.cstring_equals(message.*.role, copiedMessage.*.role));
}

test "creates an assistant message" {
    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, "I am an AI assistant");

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, cModule.ASSISTANT, content);

    try std.testing.expectEqualStrings("assistant", toZigStr(message.*.role.*.text));
    try std.testing.expectEqualStrings("I am an AI assistant", toZigStr(message.*.content.*.text));
}

test "free message properly deallocates memory" {
    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, "test message");

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, cModule.USER, content);

    // Should not crash when freeing
    cModule.message_free(message);
}

test "copy message with empty content" {
    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, "");

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, cModule.USER, content);

    var copiedMessage: [*c]cModule.Message = undefined;
    copiedMessage = cModule.message_copy(copiedMessage, message);

    try std.testing.expect(cModule.cstring_equals(message.*.content, copiedMessage.*.content));
    try std.testing.expectEqualStrings("", toZigStr(copiedMessage.*.content.*.text));
}

test "creates message with long content" {
    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, 
        "This is a very long message that tests the capability of handling larger strings. " ** 10);

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, cModule.USER, content);

    try std.testing.expect(cModule.cstring_equals(content, message.*.content));
}