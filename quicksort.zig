const std = @import("std");

const RndGen = std.Random.DefaultPrng;
const stdout = std.debug;
const Time = std.time;

const expect = std.testing.expect;

pub fn main() !void {
    var rnd = RndGen.init(@intCast(Time.milliTimestamp()));
    stdout.print("Input array:\n", .{});

    const n = 30;
    var numbers = [_]u8{0} ** n;

    rnd.fill(&numbers);
    try print_array(&numbers);

    partition(&numbers, 0, n - 1);

    try print_array(&numbers);

    var i: usize = 0;
    while (i < n - 1) : (i += 1) {
        try expect(numbers[i] <= numbers[i + 1]);
    }
}

fn partition(a: []u8, l: usize, r: usize) void {
    if (l >= r) return;
    var i = l + 1;
    var j = r;
    const lwall = l;

    stdout.print("l = {d}, r = {d}\n", .{ l, r });
    try print_array(a[l .. r + 1]);

    while (i <= j) {
        while ((i <= j) and (i < a.len) and (a[i] <= a[lwall])) {
            i += 1;
        }
        while ((j >= i) and (j > 0) and (a[j] >= a[lwall])) {
            j -= 1;
        }
        if (i < j) {
            swap_numbers(&a[i], &a[j]);
        }
    }

    swap_numbers(&a[lwall], &a[j]);
    if (j > 0) partition(a, lwall, j - 1);
    partition(a, j + 1, r);
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