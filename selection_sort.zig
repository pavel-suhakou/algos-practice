const std = @import("std");

const RndGen = std.Random.DefaultPrng;
const stdout = std.debug;
const Time = std.time;

// zig test _.zig
const expect = std.testing.expect;
// test "Sort numbers test" {
//     try expect();
// }

pub fn main() !void {
    var rnd = RndGen.init(@intCast(Time.milliTimestamp()));
    stdout.print("Input array:\n", .{});

    const n = 50;
    var numbers = [_]u8{0} ** n;

    rnd.fill(&numbers);
    try print_array(&numbers);

    var i: usize = 0;
    while (i < n - 1) : (i += 1) {
        var min = i;
        var j = i + 1;

        while (j < n) : (j += 1) {
            if (numbers[j] < numbers[min]) min = j;
        }

        if (min != i) {
            swap_numbers(&numbers[i], &numbers[min]);
        }
    }

    try print_array(&numbers);

    i = 0;
    while (i < n - 1) : (i += 1) {
        try expect(numbers[i] <= numbers[i + 1]);
    }
}

fn print_array(a: []u8) !void {
    for (a) |v| {
        stdout.print("{d} ", .{v});
    }
    stdout.print("\n", .{});
}

inline fn swap_numbers(l: *u8, r: *u8) void {
    const temp = l.*;
    l.* = r.*;
    r.* = temp;
}
