local internet = require("internet");

local configuration = {
	weebhook =
	"https://discord.com/api/webhooks/1406120859193708544/Ww_ZBuBI9Fk4Ew6JqCT1HLZs-FuTdxQf8Rx8G2lI3fAne1BrBLgLJ5t4WWmCCr_-NbLb"
}


internet.request(configuration.weebhook, {
	content = "Hello world from OpenComputers!"
});
