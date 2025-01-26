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
    message = cModule.message_create(message, 0, content);

    try std.testing.expectEqualStrings("how are you?", toZigStr(message.*.content.*.text));
}

test "copies a message" {
    var role: [*c]cModule.String = undefined;
    role = cModule.cstring_create(role, "user");

    var content: [*c]cModule.String = undefined;
    content = cModule.cstring_create(content, "how are you?");

    var message: [*c]cModule.Message = undefined;
    message = cModule.message_create(message, 0, content);

    var copiedMessage: [*c]cModule.Message = undefined;
    copiedMessage = cModule.message_copy(copiedMessage, message);

    try std.testing.expect(cModule.cstring_equals(message.*.content, copiedMessage.*.content));
    try std.testing.expect(cModule.cstring_equals(message.*.role, copiedMessage.*.role));
}