import { DataTypes, Model } from "sequelize";
import { sequelize } from "../config/database.js";

class BoardMember extends Model {}

BoardMember.init(
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
    userId: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
      field: "user_id",
    },
    role: {
      type: DataTypes.ENUM("owner", "admin", "member", "viewer"),
      allowNull: false,
      defaultValue: "member",
    },
  },
  {
    sequelize,
    modelName: "BoardMember",
    tableName: "board_members",
    underscored: true,
  }
);

export default BoardMember;
