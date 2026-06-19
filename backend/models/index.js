import { sequelize } from "../config/database.js";
import User from "./User.js";
import Board from "./Board.js";
import BoardMember from "./BoardMember.js";
import List from "./List.js";
import Card from "./Card.js";

User.hasMany(Board, { foreignKey: "ownerId", as: "ownedBoards" });
Board.belongsTo(User, { foreignKey: "ownerId", as: "owner" });

Board.belongsToMany(User, {
  through: BoardMember,
  foreignKey: "boardId",
  otherKey: "userId",
  as: "members",
});
User.belongsToMany(Board, {
  through: BoardMember,
  foreignKey: "userId",
  otherKey: "boardId",
  as: "memberBoards",
});

Board.hasMany(BoardMember, { foreignKey: "boardId", as: "memberships" });
BoardMember.belongsTo(Board, { foreignKey: "boardId" });
BoardMember.belongsTo(User, { foreignKey: "userId", as: "user" });

Board.hasMany(List, { foreignKey: "boardId", as: "lists", onDelete: "CASCADE" });
List.belongsTo(Board, { foreignKey: "boardId" });

List.hasMany(Card, { foreignKey: "listId", as: "cards", onDelete: "CASCADE" });
Card.belongsTo(List, { foreignKey: "listId" });

Board.hasMany(Card, { foreignKey: "boardId", as: "cards" });
Card.belongsTo(Board, { foreignKey: "boardId" });

Card.belongsTo(User, { foreignKey: "assigneeId", as: "assignee" });
User.hasMany(Card, { foreignKey: "assigneeId", as: "assignedCards" });

export { sequelize, User, Board, BoardMember, List, Card };
