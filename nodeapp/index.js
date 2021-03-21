const express = require("express")
const logger = require("fluent-logger")
const app = express()

logger.configure("fluentd.test", {
  host: "localhost",
  port: 24224,
  timeout: 3.0,
  reconnectInterval: 60
})


app.get("/", async (req, res) => {
  logger.emit("healthcheck", { ip: req.ip, path: req.path, host: req.hostname, method: req.method, protocol: req.protocol})
  res.send("success")
})



app.listen(3000)