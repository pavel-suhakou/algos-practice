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

    var temp = [_]u8{0} ** n;
    try merge_sort(&numbers, &temp, 0, n - 1);

    try print_array(&numbers);
    try assert_sorted(&numbers, 0, n);
}

fn merge_sort(a: []u8, tmp: []u8, l: u8, r: u8) !void {
    if (l >= r) return;
    if (l + 1 == r) {
        if (a[l] > a[r]) swap_numbers(&a[l], &a[r]);
        return;
    }

    const m = (l + r) / 2;

    try merge_sort(a, tmp, l, m);
    try merge_sort(a, tmp, m + 1, r);

    var i: usize = l;
    var j: usize = m + 1;
    var t: usize = l;
    while (t <= r) {
        if ((j > r) or (a[i] < a[j] and i <= m)) {
            tmp[t] = a[i];
            i += 1;
        } else {
            tmp[t] = a[j];
            j += 1;
        }
        t += 1;
    }

    for (l..r + 1) |k| {
        a[k] = tmp[k];
    }
    try assert_sorted(a, l, r + 1);
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
    while (i < r - 1) : (i += 1) {
        try expect(a[i] <= a[i + 1]);
    }
}
