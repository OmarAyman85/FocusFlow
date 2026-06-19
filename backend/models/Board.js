import { DataTypes, Model } from "sequelize";
import { sequelize } from "../config/database.js";

class Board extends Model {}

Board.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      autoIncrement: true,
      primaryKey: true,
    },
    name: { type: DataTypes.STRING(120), allowNull: false },
    description: { type: DataTypes.TEXT, allowNull: true },
    visibility: {
      type: DataTypes.ENUM("private", "public"),
      allowNull: false,
      defaultValue: "private",
    },
    ownerId: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
      field: "owner_id",
    },
  },
  {
    sequelize,
    modelName: "Board",
    tableName: "boards",
    underscored: true,
  }
);

export default Board;
