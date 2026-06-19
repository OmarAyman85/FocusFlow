module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("lists", {
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
      name: { type: Sequelize.STRING(120), allowNull: false },
      position: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
      created_at: { type: Sequelize.DATE, allowNull: false },
      updated_at: { type: Sequelize.DATE, allowNull: false },
    });
    await queryInterface.addIndex("lists", ["board_id", "position"]);
  },
  down: async (queryInterface) => {
    await queryInterface.dropTable("lists");
  },
};
