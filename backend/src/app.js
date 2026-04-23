require("dotenv").config();
const express = require("express");
const db = require("./db");

const app = express();
app.use(express.json());

app.get("/live", (_req, res) => {
  res.status(200).json({
    status: "ok",
    service: "backend"
  });
});

app.get("/health", async (_req, res) => {
  try {
    await db.query("SELECT 1");
    res.status(200).json({
      status: "ok",
      service: "backend",
      db: "up"
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      service: "backend",
      db: "down",
      error: error.message
    });
  }
});

app.get("/api/message", (_req, res) => {
  res.json({
    message: process.env.API_MESSAGE || "Hello from backend"
  });
});

module.exports = app;
