import { DataTypes, Model } from "sequelize";
import { sequelize } from "../config/database.js";

class List extends Model {}

List.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      autoIncrement: true,
      primaryKey: true,
    },
    boardId: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
      field: "board_id",
    },
    name: { type: DataTypes.STRING(120), allowNull: false },
    position: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0 },
  },
  {
    sequelize,
    modelName: "List",
    tableName: "lists",
    underscored: true,
  }
);

export default List;
