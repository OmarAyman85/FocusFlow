import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import boardRoutes from "./routes/boardRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import { errorHandler } from "./middleware/errorMiddleware.js";
import { sequelize } from "./models/index.js";

dotenv.config();
const app = express();
app.use(express.json());

app.use(
  cors({
    origin: process.env.CORS_ORIGIN || "http://localhost:4200",
  })
);

sequelize
  .authenticate()
  .then(() => console.log("MySQL connected"))
  .catch((err) => console.log(err));

app.use("/api/boards", boardRoutes);
app.use("/api/auth", authRoutes);

app.get("/", (req, res) => {
  res.send("Hello, Express!");
});

app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
