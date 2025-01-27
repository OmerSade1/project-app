const express = require("express");
const { MongoClient } = require("mongodb");

const app = express();
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI || "mongodb://mongo:27017";


app.get("/", async (req, res) => {
  const client = new MongoClient(MONGO_URI);
  try {
    await client.connect();
    const db = client.db("db-fruits");
    const fruits = await db.collection("fruits").find({}).toArray();
    res.send(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Fruits App</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
          }
          .container {
            text-align: center;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            background: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 500px;
          }
          h1 {
            color: #007bff;
            font-size: 2rem;
          }
          ul {
            list-style: none;
            padding: 0;
          }
          li {
            font-size: 1.2rem;
            margin: 5px 0;
            padding: 10px;
            background: #e9ecef;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          }
          li:nth-child(odd) {
            background: #dee2e6;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Hello World! This is my fruits :)</h1>
          <ul>
            ${fruits
              .map(
                (fruit) =>
                  `<li><strong>${fruit.name}</strong> (${fruit.qty})</li>`
              )
              .join("")}
          </ul>
        </div>
      </body>
      </html>
    `);
  } catch (err) {
    res.status(500).send("Error connecting to the database.");
  } finally {
    await client.close();
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
