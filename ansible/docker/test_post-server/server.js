'use strict';
const express = require('express');
const app = express();

app.use(express.json());

app.post('/', (req, res) => {
  console.log("=========================================");
  console.log(JSON.stringify(req.body));
  console.log("+++++++++++++++++++++++++++");
  // console.log(JSON.stringify(res));
  console.log("=========================================");
});

app.get('/', (req, res) => res.send("send me dat post request"));

const port = 3000;
app.listen(port, () => {
    console.log(`Running on http://localhost:${port}`);
});
