/*
Environmental variables
 - PORT
 - COOKIE_SECRET
*/

require("coffee-script");
app = require("./controllers/host.coffee");
http = require("http");
port = process.env.PORT || 4000;

http.createServer(app).listen(port, function () {
   console.log("Fannect Greek listening on " + port);
});