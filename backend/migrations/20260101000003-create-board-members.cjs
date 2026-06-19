module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("board_members", {
      id: {
        type: Sequelize.BIGINT.UNSIGNED,
        autoIncrement: true,
        primaryKey: true,
      },
      board_id: {
        type: Sequelize.BIGINT.UNSIGNED,
        allowNull: false,
        references: { model: "boards", key: "id" },
        onDelete: "CASCADE",
      },
      user_id: {
        type: Sequelize.BIGINT.UNSIGNED,
        allowNull: false,
        references: { model: "users", key: "id" },
        onDelete: "CASCADE",
      },
      role: {
        type: Sequelize.ENUM("owner", "admin", "member", "viewer"),
        allowNull: false,
        defaultValue: "member",
      },
      created_at: { type: Sequelize.DATE, allowNull: false },
      updated_at: { type: Sequelize.DATE, allowNull: false },
    });
    await queryInterface.addIndex("board_members", ["board_id", "user_id"], {
      unique: true,
      name: "uq_board_members_board_user",
    });
    await queryInterface.addIndex("board_members", ["user_id"]);
  },
  down: async (queryInterface) => {
    await queryInterface.dropTable("board_members");
  },
};
