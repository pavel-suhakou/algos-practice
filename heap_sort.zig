const std = @import("std");

const RndGen = std.Random.DefaultPrng;
const stdout = std.debug;
const time = std.time;
const expect = std.testing.expect;

pub fn main() !void {
    var rnd = RndGen.init(@intCast(time.milliTimestamp()));
    stdout.print("Input array:\n", .{});

    const n = 20;
    var numbers = [_]u8{0} ** n;

    rnd.fill(&numbers);
    try print_array(&numbers);

    try heap_sort(&numbers);

    try print_array(&numbers);
    try assert_sorted(&numbers, 0, n);
}

fn heap_sort(a: []u8) !void {
    for (1..a.len) |i| {
        insert(a, i);
    }

    for (0..a.len - 1) |i| {
        delete(a, a.len - i - 1);
    }
}

fn insert(a: []u8, index: usize) void {
    var i: usize = index;
    while (i > 0 and a[i] > a[(i + 1) / 2 - 1]) {
        swap_numbers(&a[(i + 1) / 2 - 1], &a[i]);
        i = (i + 1) / 2 - 1;
    }
}

fn delete(a: []u8, len: usize) void {
    if (len == 0) return;
    swap_numbers(&a[0], &a[len]);
    var i: usize = 0;
    while (true) {
        const rchild = (i + 1) * 2;
        const lchild = (i + 1) * 2 - 1;
        if (rchild < len and a[i] < a[rchild] and a[rchild] > a[lchild]) {
            swap_numbers(&a[i], &a[rchild]);
            i = rchild;
        } else if (lchild < len and a[i] < a[lchild]) {
            swap_numbers(&a[i], &a[lchild]);
            i = lchild;
        } else break;
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

fn assert_sorted(a: []u8, l: u8, r: u8) !void {
    var i: usize = l;
    while (i < r - 1) {
        try expect(a[i] <= a[i + 1]);
        i += 1;
    }
}
