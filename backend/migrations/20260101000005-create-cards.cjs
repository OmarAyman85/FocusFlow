module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("cards", {
      id: {
        type: Sequelize.BIGINT.UNSIGNED,
        autoIncrement: true,
        primaryKey: true,
      },
      list_id: {
        type: Sequelize.BIGINT.UNSIGNED,
        allowNull: false,
        references: { model: "lists", key: "id" },
        onDelete: "CASCADE",
      },
      board_id: {
        type: Sequelize.BIGINT.UNSIGNED,
        allowNull: false,
        references: { model: "boards", key: "id" },
        onDelete: "CASCADE",
      },
      title: { type: Sequelize.STRING(255), allowNull: false },
      description: { type: Sequelize.TEXT, allowNull: true },
      priority: {
        type: Sequelize.ENUM("low", "medium", "high"),
        allowNull: false,
        defaultValue: "medium",
      },
      due_date: { type: Sequelize.DATE, allowNull: true },
      assignee_id: {
        type: Sequelize.BIGINT.UNSIGNED,
        allowNull: true,
        references: { model: "users", key: "id" },
        onDelete: "SET NULL",
      },
      position: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
      created_at: { type: Sequelize.DATE, allowNull: false },
      updated_at: { type: Sequelize.DATE, allowNull: false },
    });
    await queryInterface.addIndex("cards", ["list_id", "position"]);
    await queryInterface.addIndex("cards", ["board_id"]);
    await queryInterface.addIndex("cards", ["assignee_id"]);
  },
  down: async (queryInterface) => {
    await queryInterface.dropTable("cards");
  },
};
