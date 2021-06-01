const Discord = require('discord.js');
const app = require('express')();
const config = require('./config.json');
//app.use(require('body-parser').json());

app.get('/', (req, res) => {
	res.json({ success: true });
});
app.post('/login', (req, res) => {
	console.log('Request: ', JSON.stringify(req));
	let bot = new Discord.Client();
	bot.on('ready', () => {
		res.json({
			success: true,
			client: {
				channels: bot.channels.cache.map((c) => c.toJSON()),
				guilds: bot.guilds.cache.map((g) => g.toJSON()),
				user: bot.user.toJSON(),
			},
		});
	});
	bot.login(req.body.token).catch((err) => {
		res.json({ success: false, error: err });
	});
});

app.listen(config.port, () => {
	console.log('App is online!');
});
