const bcrypt = require("bcryptjs");

module.exports = {
  up: async (queryInterface) => {
    const now = new Date();
    const passwordHash = await bcrypt.hash("Password123", 10);

    await queryInterface.bulkInsert("users", [
      {
        id: 1,
        name: "Demo Owner",
        email: "owner@focusflow.dev",
        password: passwordHash,
        role: "user",
        created_at: now,
        updated_at: now,
      },
      {
        id: 2,
        name: "Demo Collaborator",
        email: "collaborator@focusflow.dev",
        password: passwordHash,
        role: "user",
        created_at: now,
        updated_at: now,
      },
    ]);

    await queryInterface.bulkInsert("boards", [
      {
        id: 1,
        name: "Launch Plan",
        description: "Demo board seeded for verification",
        visibility: "public",
        owner_id: 1,
        created_at: now,
        updated_at: now,
      },
    ]);

    await queryInterface.bulkInsert("board_members", [
      { board_id: 1, user_id: 1, role: "owner", created_at: now, updated_at: now },
      { board_id: 1, user_id: 2, role: "member", created_at: now, updated_at: now },
    ]);

    await queryInterface.bulkInsert("lists", [
      { id: 1, board_id: 1, name: "To Do", position: 0, created_at: now, updated_at: now },
      { id: 2, board_id: 1, name: "Doing", position: 1, created_at: now, updated_at: now },
      { id: 3, board_id: 1, name: "Done", position: 2, created_at: now, updated_at: now },
    ]);

    await queryInterface.bulkInsert("cards", [
      {
        list_id: 1,
        board_id: 1,
        title: "Design the schema",
        priority: "high",
        position: 0,
        assignee_id: 1,
        created_at: now,
        updated_at: now,
      },
      {
        list_id: 1,
        board_id: 1,
        title: "Write seed data",
        priority: "medium",
        position: 1,
        created_at: now,
        updated_at: now,
      },
    ]);
  },
  down: async (queryInterface) => {
    await queryInterface.bulkDelete("cards", null, {});
    await queryInterface.bulkDelete("lists", null, {});
    await queryInterface.bulkDelete("board_members", null, {});
    await queryInterface.bulkDelete("boards", null, {});
    await queryInterface.bulkDelete("users", null, {});
  },
};
