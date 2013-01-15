/*
Environmental variables
 - PORT
 - COOKIE_SECRET
*/

require("coffee-script");
app = require("./controllers/host.coffee");
http = require("http");
port = process.env.PORT || 3100;

http.createServer(app).listen(port, function () {
   console.log("Snapture Web listening on " + port);
});