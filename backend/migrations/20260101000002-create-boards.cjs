module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("boards", {
      id: {
        type: Sequelize.BIGINT.UNSIGNED,
        autoIncrement: true,
        primaryKey: true,
      },
      name: { type: Sequelize.STRING(120), allowNull: false },
      description: { type: Sequelize.TEXT, allowNull: true },
      visibility: {
        type: Sequelize.ENUM("private", "public"),
        allowNull: false,
        defaultValue: "private",
      },
      owner_id: {
        type: Sequelize.BIGINT.UNSIGNED,
        allowNull: false,
        references: { model: "users", key: "id" },
        onDelete: "CASCADE",
      },
      created_at: { type: Sequelize.DATE, allowNull: false },
      updated_at: { type: Sequelize.DATE, allowNull: false },
    });
    await queryInterface.addIndex("boards", ["owner_id"]);
    await queryInterface.addIndex("boards", ["visibility"]);
  },
  down: async (queryInterface) => {
    await queryInterface.dropTable("boards");
  },
};
