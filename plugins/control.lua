local control = {}

local bot = require('bot')
local bindings = require('bindings')
local utilities = require('utilities')

function control:init()
	control.triggers = utilities.triggers(self.info.username):t('reload'):t('halt').table
end

function control:action(msg)

	if msg.from.id ~= self.config.admin then
		return
	end

	if msg.date < os.time() - 1 then return end

	if msg.text:match('^'..utilities.INVOCATION_PATTERN..'reload') then
		for pac, _ in pairs(package.loaded) do
			if pac:match('^plugins%.') then
				package.loaded[pac] = nil
			end
			package.loaded['bindings'] = nil
			package.loaded['utilities'] = nil
			package.loaded['config'] = nil
		end
		bot.init(self)
		bindings.sendReply(self, msg, 'Bot reloaded!')
	elseif msg.text:match('^'..utilities.INVOCATION_PATTERN..'halt') then
		self.is_started = false
		bindings.sendReply(self, msg, 'Stopping bot!')
	end

end

return control

