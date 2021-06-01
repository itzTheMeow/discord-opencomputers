const Discord = require('discord.js');
const app = require('express')();
const config = require('./config.json');
app.use(require('body-parser').json());

app.get('/', (req, res) => {
	res.json({ success: true });
});
app.post('/login', (req, res) => {
	let bot = new Discord.Client();
	bot.on('ready', () => {
		res.json({ success: true, client: bot.toJSON() });
	});
	bot.login(req.body.token).catch((err) => {
		res.json({ success: false, error: err });
	});
});

app.listen(config.port, () => {
	console.log('App online!');
});
