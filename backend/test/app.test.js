const request = require("supertest");

jest.mock("../src/db", () => ({
  query: jest.fn()
}));

const db = require("../src/db");
const app = require("../src/app");

describe("backend endpoints", () => {
  test("GET /health should return 200 when db is available", async () => {
    db.query.mockResolvedValueOnce({ rows: [{ "?column?": 1 }] });

    const response = await request(app).get("/health");

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe("ok");
    expect(response.body.db).toBe("up");
  });

  test("GET /health should return 500 when db is down", async () => {
    db.query.mockRejectedValueOnce(new Error("db unavailable"));

    const response = await request(app).get("/health");

    expect(response.statusCode).toBe(500);
    expect(response.body.status).toBe("error");
    expect(response.body.db).toBe("down");
  });

  test("GET /api/message should return configured message", async () => {
    process.env.API_MESSAGE = "CI/CD is running";

    const response = await request(app).get("/api/message");

    expect(response.statusCode).toBe(200);
    expect(response.body.message).toBe("CI/CD is running");
  });
});
