const std = @import("std");

fn updateRoomAllocations(
    rooms: *std.AutoHashMap(u64, bool),
    allocate_rooms: *const std.AutoHashMap(u64, bool),
) !void {
    const stdout = std.io.getStdOut().writer();
    var rooms_iter = rooms.iterator();

    while (rooms_iter.next()) |room_entry| {
        const room_key = room_entry.key_ptr.*;
        if (allocate_rooms.get(room_key)) |alloc_value| {
            if (room_entry.value_ptr.*) {
                try stdout.print("Can't allocate room {} is already allocated!\n", .{room_key});
            } else {
                room_entry.value_ptr.* = alloc_value;
                try stdout.print("Room {} status was updated to {}\n", .{ room_key, alloc_value });
            }
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var rooms = std.AutoHashMap(u64, bool).init(allocator);
    defer rooms.deinit();

    for (0..10) |i| {
        try rooms.put(i, if (i % 2 == 0) true else false);
    }

    var allocate_rooms = std.AutoHashMap(u64, bool).init(allocator);
    defer allocate_rooms.deinit();

    try allocate_rooms.put(0, true);
    try allocate_rooms.put(1, false);
    try allocate_rooms.put(2, true);
    try allocate_rooms.put(3, true);
    try allocate_rooms.put(4, true);

    try updateRoomAllocations(&rooms, &allocate_rooms);
}
