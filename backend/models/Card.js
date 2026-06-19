import { DataTypes, Model } from "sequelize";
import { sequelize } from "../config/database.js";

class Card extends Model {}

Card.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      autoIncrement: true,
      primaryKey: true,
    },
    listId: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
      field: "list_id",
    },
    boardId: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
      field: "board_id",
    },
    title: { type: DataTypes.STRING(255), allowNull: false },
    description: { type: DataTypes.TEXT, allowNull: true },
    priority: {
      type: DataTypes.ENUM("low", "medium", "high"),
      allowNull: false,
      defaultValue: "medium",
    },
    dueDate: { type: DataTypes.DATE, allowNull: true, field: "due_date" },
    assigneeId: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: true,
      field: "assignee_id",
    },
    position: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0 },
  },
  {
    sequelize,
    modelName: "Card",
    tableName: "cards",
    underscored: true,
  }
);

export default Card;
