
local env = type(getgenv) == "function" and getgenv() or _G
local cfg = type(env.cfg) == "table" and env.cfg or {}
cfg.AntiAFK = cfg.AntiAFK == nil or cfg.AntiAFK == true
cfg.FPSBoost = cfg.FPSBoost == nil or cfg.FPSBoost == true
cfg.AutoRedeemCodes = cfg.AutoRedeemCodes == nil or cfg.AutoRedeemCodes == true
cfg.Webhook = type(cfg.Webhook) == "table" and cfg.Webhook or {}
cfg.Webhook.Enabled = cfg.Webhook.Enabled == true
cfg.Webhook.URL = type(cfg.Webhook.URL) == "string" and cfg.Webhook.URL or ""
cfg.Webhook.UserID = tostring(cfg.Webhook.UserID or "")
cfg["Path Position"] = cfg["Path Position"] or 5
cfg["Path Target"] = cfg["Path Target"] or "Path 1"
cfg["Position Mode"] = cfg["Position Mode"] or "Path"
cfg["Placement Mode"] = cfg["Placement Mode"] or "Circle"
cfg["Auto Position Sky Island"] = cfg["Auto Position Sky Island"] == nil or cfg["Auto Position Sky Island"] == true
cfg.AutoPlacePositions = type(cfg.AutoPlacePositions) == "table" and cfg.AutoPlacePositions or {}
cfg["Target Level"] = tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40
env.cfg = cfg
local previous = env.BocchiKaitun
if type(previous) == "table" then
	previous.Enabled = false
	if type(previous.Stop) == "function" then
		pcall(previous.Stop)
	end
end
if type(env.__BocchiReworkedCleanup) == "function" then
	pcall(env.__BocchiReworkedCleanup)
end

local k = { Enabled = true, State = "Starting", Activity = "Starting", Build = "rewards-10" }
k.Stop = function()
	k.Enabled = false
end
env.BocchiKaitun = k
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local Http = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local progress = env.BocchiKaitunProgress
if type(progress) ~= "table" then
	progress = {}
end
progress.Losses = type(progress.Losses) == "table" and progress.Losses or {}
progress.FarmLeft = math.clamp(math.floor(tonumber(progress.FarmLeft) or 0), 0, 3)
env.BocchiKaitunProgress = progress
local inv, units, order, settings, banners, levels, rem
local LevelServiceCore, LevelUtilCore, UnitServiceCore
local story, known = {}, {}
local room, equipping
local file, sessionReady, idle
local spots, points = {}, {}
local currentMatchData = nil

local function parseCFrame(str)
	local n = {}
	for num in string.gmatch(str, "[%-%d%.]+") do
		table.insert(n, tonumber(num))
	end
	if #n >= 12 then
		return CFrame.new(unpack(n, 1, 12))
	elseif #n >= 3 then
		return CFrame.new(n[1], n[2], n[3])
	end
	return nil
end

local INFINITE_NAMEK_STRAT = {
	{ step = 1, money = 350, unit = "ichigo", cf = parseCFrame("-2942.51245, 91.8062057, -688.787903, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 2, money = 350, unit = "ichigo", cf = parseCFrame("-2942.50024, 91.8062057, -690.707397, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 3, money = 350, unit = "ichigo", cf = parseCFrame("-2938.01636, 91.8062057, -688.697144, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 4, money = 350, unit = "ichigo", cf = parseCFrame("-2938.09106, 91.8062057, -690.725708, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 5, money = 250, unit = "naruto", cf = parseCFrame("-2935.69434, 91.8062057, -688.889099, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 6, money = 250, unit = "naruto", cf = parseCFrame("-2935.90527, 91.8062057, -691.212219, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 7, money = 250, unit = "naruto", cf = parseCFrame("-2944.83862, 91.8062057, -689.384521, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 8, money = 250, unit = "naruto", cf = parseCFrame("-2944.77856, 91.8062057, -691.236938, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 9, money = 250, unit = "naruto", cf = parseCFrame("-2935.80713, 91.8062057, -693.558838, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 10, money = 250, unit = "naruto", cf = parseCFrame("-2944.02466, 91.8062057, -693.867737, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 11, money = 350, unit = "ichigo", cf = parseCFrame("-2942.25195, 91.8062057, -692.705017, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
	{ step = 12, money = 350, unit = "ichigo", cf = parseCFrame("-2938.62012, 91.8062057, -692.833374, 1, 0, -0, -0, 1, -0, 0, 0, 1") },
}

local boost = { old = setmetatable({}, { __mode = "k" }), cons = {} }

function boost.write(obj, key, value)
	pcall(function()
		local old = boost.old
		old[obj] = old[obj] or {}
		if not old[obj][key] then
			old[obj][key] = { value = obj[key] }
		end
		obj[key] = value
	end)
end

function boost.apply(obj)
	if obj:IsA("BasePart") then
		boost.write(obj, "CastShadow", false)
		boost.write(obj, "Material", Enum.Material.SmoothPlastic)
		boost.write(obj, "Reflectance", 0)
		if obj:IsA("MeshPart") then
			boost.write(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
		end
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		boost.write(obj, "Transparency", 1)
	elseif
		obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Smoke")
		or obj:IsA("Fire")
		or obj:IsA("Sparkles")
		or obj:IsA("PostEffect")
		or obj:IsA("Clouds")
	then
		boost.write(obj, "Enabled", false)
	elseif obj:IsA("ForceField") then
		boost.write(obj, "Visible", false)
	elseif obj:IsA("Sound") then
		boost.write(obj, "Volume", 0)
	elseif obj:IsA("Sky") then
		boost.write(obj, "Parent", nil)
	elseif obj:IsA("Terrain") then
		boost.write(obj, "WaterWaveSize", 0)
		boost.write(obj, "WaterWaveSpeed", 0)
		boost.write(obj, "WaterReflectance", 0)
	end
end

function boost.set(on)
	if boost.on == on then
		return
	end
	boost.on = on
	for _, con in ipairs(boost.cons) do
		con:Disconnect()
	end
	table.clear(boost.cons)
	if not on then
		for obj, props in pairs(boost.old) do
			for key, row in pairs(props) do
				pcall(function()
					obj[key] = row.value
				end)
			end
		end
		table.clear(boost.old)
		return
	end
	local light = game:GetService("Lighting")
	boost.write(light, "GlobalShadows", false)
	boost.write(light, "Brightness", 0.5)
	boost.write(light, "OutdoorAmbient", Color3.fromRGB(127, 127, 127))
	boost.write(light, "Ambient", Color3.fromRGB(100, 100, 100))
	boost.write(light, "FogEnd", 9e9)
	pcall(function()
		boost.write(
			UserSettings():GetService("UserGameSettings"),
			"SavedQualityLevel",
			Enum.SavedQualitySetting.QualityLevel1
		)
	end)
	for _, root in ipairs({ workspace, light }) do
		table.insert(
			boost.cons,
			root.DescendantAdded:Connect(function(obj)
				if boost.on then
					boost.apply(obj)
				end
			end)
		)
		for _, obj in ipairs(root:GetDescendants()) do
			boost.apply(obj)
		end
	end
end

local function validSession(data)
	assert(type(data) == "table" and data.Version == 1, "Invalid Kaitun session version.")
	assert(data.UserId == LP.UserId, "Kaitun session belongs to another account.")
	assert(type(data.Losses) == "table", "Invalid Kaitun loss history.")
	for id, n in pairs(data.Losses) do
		assert(
			type(id) == "string" and (id:match("_level_%d+$") or id == "namek_infinite" or id == "__DAILY_CHALLENGE"),
			"Invalid session stage."
		)
		assert(
			type(n) == "number" and n >= 0 and n < math.huge and n % 1 == 0,
			"Invalid loss count."
		)
	end
	local n = data.FarmLeft
	assert(type(n) == "number" and n >= 0 and n <= 3 and n % 1 == 0, "Invalid farm count.")
	assert(
		data.FarmInfinite == nil or type(data.FarmInfinite) == "boolean",
		"Invalid FarmInfinite state."
	)
	assert(
		data.FarmLevel == nil or type(data.FarmLevel) == "boolean",
		"Invalid FarmLevel state."
	)
	assert(
		data.MustRetryStory == nil or type(data.MustRetryStory) == "boolean",
		"Invalid MustRetryStory state."
	)
	assert(
		data.DailyChallengeDay == nil or (type(data.DailyChallengeDay) == "number" and data.DailyChallengeDay >= 0),
		"Invalid DailyChallengeDay."
	)
	assert(
		data.DailyChallengeCleared == nil or type(data.DailyChallengeCleared) == "boolean",
		"Invalid DailyChallengeCleared state."
	)
	assert(
		data.DailyChallenge == nil or type(data.DailyChallenge) == "boolean",
		"Invalid DailyChallenge state."
	)
	if data.RedeemedCodes ~= nil then
		assert(type(data.RedeemedCodes) == "table", "Invalid RedeemedCodes table.")
	end
	assert(
		data.SummonPending == nil or type(data.SummonPending) == "boolean",
		"Invalid summon state."
	)
	if data.SummonSeen ~= nil then
		assert(type(data.SummonSeen) == "table", "Invalid summon inventory snapshot.")
		for uuid, present in pairs(data.SummonSeen) do
			assert(type(uuid) == "string" and present == true, "Invalid summon inventory entry.")
		end
	end
	for _, key in ipairs({ "SummonAt", "SummonGems" }) do
		local value = data[key]
		assert(
			value == nil or (type(value) == "number" and value >= 0 and value < math.huge),
			"Invalid summon receipt."
		)
	end
	for _, key in ipairs({ "Stage", "LastStage" }) do
		assert(data[key] == nil or known[data[key]], "Unknown session stage.")
	end
	for _, key in ipairs({ "Phase", "LastResult", "ResultJob", "SummonJob", "Error" }) do
		assert(
			data[key] == nil or (type(data[key]) == "string" and #data[key] <= 2048),
			"Invalid session text."
		)
	end
	return data
end

local function saveSession()
	if not file or not sessionReady then
		return
	end
	progress.Version, progress.UserId = 1, LP.UserId
	progress.UpdatedAt = os.time()
	local text = Http:JSONEncode(validSession(progress))
	if isfile(file) then
		local old = readfile(file)
		local ok = pcall(function()
			validSession(Http:JSONDecode(old))
		end)
		if ok then
			writefile(file .. ".bak", old)
			assert(readfile(file .. ".bak") == old, "Kaitun session backup failed.")
		end
	end
	writefile(file, text)
	assert(readfile(file) == text, "Kaitun session could not be saved.")
end

local function loadSession()
	sessionReady = false
	assert(
		type(isfile) == "function"
			and type(readfile) == "function"
			and type(writefile) == "function"
			and type(isfolder) == "function"
			and type(makefolder) == "function",
		"Executor file APIs unavailable; Kaitun session cannot be saved."
	)
	for _, dir in ipairs({ "bocchi reworked", "bocchi reworked/kaitun" }) do
		if not isfolder(dir) then
			makefolder(dir)
		end
	end
	file = "bocchi reworked/kaitun/" .. tostring(LP.UserId) .. ".json"
	k.File = file
	local found, loaded = false, nil
	for _, path in ipairs({ file, file .. ".bak" }) do
		if isfile(path) then
			found = true
			local ok, data = pcall(function()
				return validSession(Http:JSONDecode(readfile(path)))
			end)
			if ok then
				loaded = data
				break
			end
		end
	end
	assert(not found or loaded, "Kaitun session and backup are invalid; files kept unchanged.")
	if loaded then
		progress = loaded
	elseif progress.UserId and progress.UserId ~= LP.UserId then
		progress = { Losses = {}, FarmLeft = 0 }
	end
	env.BocchiKaitunProgress = progress
	sessionReady = true
	saveSession()
end

local function checkpoint(phase, stage)
	progress.Phase = phase
	if stage then
		progress.Stage = stage
	end
	saveSession()
end

local blackScreenUI = nil

local function alive()
	return k.Enabled and env.BocchiKaitun == k
end

local function setActivity(act)
	if k.Activity ~= act then
		k.Activity = act
		if blackScreenUI then
			pcall(function()
				blackScreenUI:update("Status", act)
			end)
		end
	end
end

local function status(text)
	if k.State ~= text then
		k.State = text
		print("[Bocchi Kaitun] " .. text)
		if blackScreenUI then
			pcall(function()
				blackScreenUI:update("Step", text)
			end)
		end
	end
end

local loot = { defs = {} }

function loot.snapshot()
	local out = { items = {}, stats = {} }
	local stats = LP:FindFirstChild("_stats")
	for name, key in pairs({
		Gems = "gem_amount",
		Gold = "gold_amount",
		XP = "player_xp",
		Candies = "candies_amount",
		["Summer Pearls"] = "_resourceSummerPearls",
	}) do
		local obj = stats and stats:FindFirstChild(key)
		out.stats[name] = obj and tonumber(obj.Value) or 0
	end
	local session = inv and inv.session
	local data = session and session.inventory and session.inventory.inventory_profile_data
	for id, amount in pairs(data and data.normal_items or {}) do
		out.items[id] = tonumber(amount) or 0
	end
	for _, item in pairs(data and data.unique_items or {}) do
		if item.item_id then
			out.items[item.item_id] = (out.items[item.item_id] or 0) + 1
		end
	end
	local collection = session and session.collection and session.collection.collection_profile_data
	for _, unit in pairs(collection and collection.owned_units or {}) do
		if unit.unit_id then
			out.items[unit.unit_id] = (out.items[unit.unit_id] or 0) + 1
		end
	end
	local wave = workspace:FindFirstChild("_wave_num")
	out.wave = wave and wave.Value or 0
	return out
end

function loot.start(data)
	loot.run = {
		data = data,
		started = os.clock(),
		last = loot.snapshot(),
		gains = { items = {}, stats = {} },
	}
end

function loot.sample()
	local run = loot.run
	local current = loot.snapshot()
	for _, kind in ipairs({ "items", "stats" }) do
		for id, amount in pairs(current[kind]) do
			local gain = amount - (run.last[kind][id] or 0)
			if gain > 0 then
				run.gains[kind][id] = (run.gains[kind][id] or 0) + gain
				run.changed = os.clock()
			end
		end
	end
	run.last = current
end

local function webhook(text)
	if not cfg.Webhook.Enabled then
		return
	end
	local match = text == "VICTORY" or text == "DEFEAT"
	local run = match and loot.run
	if run and run.data.id ~= progress.LastStage then
		run = nil
	end
	task.spawn(function()
		local ok, err = pcall(function()
			local url, user = cfg.Webhook.URL, cfg.Webhook.UserID
			assert(
				type(url) == "string"
					and (
						url:match("^https://discord%.com/api/webhooks/%d+/[%w_-]+$")
						or url:match("^https://discordapp%.com/api/webhooks/%d+/[%w_-]+$")
					),
				"Invalid Discord webhook URL."
			)
			assert(
				type(user) == "string" and #user <= 25 and user:match("^%d*$"),
				"Discord User ID must contain at most 25 digits."
			)
			local send = request or http_request or (syn and syn.request) or (http and http.request)
			assert(type(send) == "function", "Executor HTTP request API unavailable.")
			local function block(value)
				return "```\n" .. tostring(value):gsub("`", ""):sub(1, 1000) .. "\n```"
			end
			local function num(value)
				return (
					string
						.format("%.0f", value)
						:reverse()
						:gsub("(%d%d%d)", "%1,")
						:reverse()
						:gsub("^,", "")
				)
			end
			local function line(name, value)
				return string.format("%-13s : %s", name, value)
			end
			local session = inv and inv.session
			local data = session and session.profile_data and session.profile_data.level_data
			local done, count = data and data.completed_story_levels or {}, 0
			for _, id in ipairs(story) do
				if done[id] then
					count += 1
				end
			end
			local current = run and run.last or loot.snapshot()
			local details, totals, rewards = {}, {}, {}
			local map = run and run.data or {}
			table.insert(
				details,
				line("Status", match and (text == "VICTORY" and "Victory" or "Defeat") or text)
			)
			table.insert(details, line("Mode", match and "Story Normal" or "Lobby"))
			if match then
				table.insert(
					details,
					line("Map", map._location_name or map.id or progress.LastStage or "Unknown")
				)
				local stage = levels and levels[map.id or progress.LastStage]
				table.insert(details, line("Stage", stage and stage.name or map.id or "Unknown"))
				table.insert(details, line("Wave", current.wave))
				local seconds = run
						and math.max(0, math.floor((run.ended or os.clock()) - run.started))
					or 0
				table.insert(
					details,
					line(
						"Time",
						string.format("%02dm %02ds", math.floor(seconds / 60), seconds % 60)
					)
				)
			end
			for _, name in ipairs({ "Gems", "Gold", "XP", "Candies", "Summer Pearls" }) do
				table.insert(totals, line(name, num(current.stats[name])))
				local gain = run and run.gains.stats[name] or 0
				if gain > 0 then
					table.insert(rewards, "+" .. num(gain) .. " " .. name)
				end
			end
			for id, gain in pairs(run and run.gains.items or {}) do
				local def = loot.defs[id] or (units and units[id])
				local name = def and def.name or id
				table.insert(rewards, "+" .. num(gain) .. " " .. name:gsub("<[^>]+>", ""))
			end
			table.sort(rewards)
			local fields = {
				{ name = "Run Details", value = block(table.concat(details, "\n")), inline = true },
				{
					name = "Kaitun Progress",
					value = block(
						line("Level", progress.Level or "Unknown")
							.. "\n"
							.. line("Story Normal", count .. " / " .. #story)
							.. "\n"
							.. line("Target Level", tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40)
					),
					inline = true,
				},
			}
			if match then
				table.insert(fields, {
					name = "Rewards",
					value = block(
						#rewards > 0 and table.concat(rewards, "\n") or "No new rewards."
					),
					inline = false,
				})
			end
			table.insert(
				fields,
				{ name = "Player Stats", value = block(table.concat(totals, "\n")), inline = match }
			)
			local response = send({
				Url = url,
				Method = "POST",
				Timeout = 10,
				Headers = { ["Content-Type"] = "application/json" },
				Body = Http:JSONEncode({
					username = "bocchi reworked.",
					content = user ~= "" and ("<@" .. user .. ">") or "",
					allowed_mentions = { parse = {}, users = user ~= "" and { user } or {} },
					embeds = {
						{
							title = "Anime Adventures",
							color = 0x153E75,
							description = "||" .. LP.Name .. "||",
							fields = fields,
							footer = { text = "bocchi reworked." },
						},
					},
				}),
			})
			local code = tonumber(response and response.StatusCode)
			assert(
				code and code >= 200 and code < 300,
				"Webhook failed (HTTP " .. tostring(code or "no response") .. ")."
			)
		end)
		if not ok then
			print("[Bocchi Kaitun] Webhook failed: " .. tostring(err))
		end
	end)
end

function k.Stop()
	k.Enabled = false
	if idle then
		idle:Disconnect()
		idle = nil
	end
	boost.set(false)
	if blackScreenUI then
		pcall(function()
			game:GetService("RunService"):Set3dRenderingEnabled(true)
		end)
		pcall(function()
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
		end)
		pcall(function()
			game:GetService("StarterGui"):SetCore("TopbarEnabled", true)
		end)
		pcall(function()
			blackScreenUI:destroy()
		end)
		blackScreenUI = nil
	end
	local ok, err = pcall(saveSession)
	if not ok then
		k.Error = tostring(err)
		print("[Bocchi Kaitun] Session save failed: " .. k.Error)
	end
	if room and rem then
		local name = room
		room = nil
		task.spawn(function()
			pcall(function()
				rem.request_leave_lobby:InvokeServer(name)
			end)
		end)
	end
end

local function checkAccess()
	if not alive() then
		return false
	end
	local ok, response = pcall(function()
		local send = request or http_request or (syn and syn.request) or (http and http.request)
		assert(type(send) == "function", "Executor HTTP request API unavailable.")
		return send({
			Url = "https://raw.githubusercontent.com/Ngducok/cyndral.dev/refs/heads/main/auth.lua?t="
				.. os.time(),
			Method = "GET",
			Headers = { ["Cache-Control"] = "no-cache" },
			Timeout = 10,
		})
	end)
	if not alive() then
		return false
	end
	if
		ok
		and type(response) == "table"
		and tonumber(response.StatusCode) == 200
		and type(response.Body) == "string"
		and response.Body:match("^%s*true%s*$")
	then
		return true
	end
	status("Stopped, no more testing lol")
	k.Stop()
	return false
end

local function watchAccess()
	while alive() do
		task.wait(30)
		if not checkAccess() then
			return
		end
	end
end

local function waitFor(fn, seconds, name)
	local at = os.clock() + seconds
	local retryAt = os.clock() + 5
	local reason, last = nil, nil
	repeat
		if not alive() then
			error("Kaitun stopped.")
		end
		local result, err = fn()
		if result then
			if name then
				status("Loaded " .. name)
			end
			return result
		end
		reason = err or "data unavailable"
		if name and os.clock() >= retryAt then
			print(
				"[Bocchi Kaitun] Waiting for " .. name .. ": " .. tostring(reason) .. "; retrying"
			)
			last, retryAt = reason, os.clock() + 15
		end
		task.wait(0.2)
	until os.clock() >= at
	if name then
		error("Failed to load " .. name .. ": " .. tostring(reason))
	end
	error("Timed out waiting for game data.")
end

local function val(root, name, fallback)
	local obj = root and root:FindFirstChild(name)
	if obj then
		return obj.Value
	end
	return fallback
end

local function remote(name, ...)
	assert(alive(), "Kaitun stopped.")
	local obj = rem:FindFirstChild(name)
	assert(obj and obj:IsA("RemoteFunction"), "Missing remote: " .. name)
	local result = obj:InvokeServer(...)
	if not alive() and name == "request_join_lobby" then
		pcall(function(id)
			rem.request_leave_lobby:InvokeServer(id)
		end, ...)
	end
	assert(alive(), "Kaitun stopped.")
	assert(result ~= false, "Server rejected: " .. name)
	return result
end

local function lobby()
	local map = workspace:FindFirstChild("_MAP_CONFIG")
	return val(map, "IsLobby")
end

local function owned()
	return inv.session.collection.collection_profile_data.owned_units
end

local function equipped(cap)
	cap = cap or 6
	local profile = inv.session.collection.collection_profile_data
	local out, used = {}, {}
	if type(profile.equipped_units) == "table" then
		for slot, uuid in pairs(profile.equipped_units) do
			local n = tonumber(slot)
			if
				n
				and n >= 1
				and n <= cap
				and n % 1 == 0
				and type(uuid) == "string"
				and uuid ~= ""
			then
				out[uuid] = n
			end
		end
	else
		for _, unit in pairs(owned()) do
			local n = tonumber(unit.equipped_slot)
			if n and n >= 1 and n <= cap and n % 1 == 0 and not used[n] then
				used[n] = true
				out[unit.uuid] = n
			end
		end
	end
	return out
end

local function playerLevel()
	local p = LP or game:GetService("Players").LocalPlayer
	local stats = p and p:FindFirstChild("_stats")
	local pxp = stats and stats:FindFirstChild("player_xp")
	if pxp and tonumber(pxp.Value) then
		if LevelServiceCore and LevelServiceCore.calculate_level then
			local ok, lv = pcall(function()
				return LevelServiceCore:calculate_level(tonumber(pxp.Value))
			end)
			if ok and type(lv) == "number" and lv > 0 then
				progress.Level = lv
				return lv
			end
		end
	end
	local pgui = p and p:FindFirstChild("PlayerGui")
	local obj = pgui
	for _, name in ipairs({ "spawn_units", "Lives", "Main", "Desc", "Level" }) do
		obj = obj and obj:FindFirstChild(name)
	end
	local lv = obj and tonumber(obj.Text:match("%d+"))
	if not lv and pgui then
		local prof = pgui:FindFirstChild("ProfileGUI")
		for _, name in ipairs({ "Main", "ProfileBanner", "XP", "Desc", "Level" }) do
			prof = prof and prof:FindFirstChild(name)
		end
		lv = prof and tonumber(prof.Text:match("%d+"))
	end
	if lv and lv > 0 then
		progress.Level = lv
		return lv
	end
	if progress.Level and progress.Level > 0 then
		return progress.Level
	end
	return 1
end

local function slots(lv)
	local n = 0
	for _, requirement in pairs(settings.UNIT_SLOT_REQUIREMENT) do
		if lv >= requirement then
			n += 1
		end
	end
	return n
end

local function usable(def)
	return def and ((def.damage or 0) > 0 or (def.farm_amount or 0) > 0)
end

local function ready()
	for _, unit in pairs(owned()) do
		local def = units[unit.unit_id]
		if def and (def.damage or 0) > 0 and type(unit.uuid) == "string" then
			return true
		end
	end
	return false
end

local NAMEK_STORY_ACTS = {
	"namek_level_1",
	"namek_level_2",
	"namek_level_3",
	"namek_level_4",
	"namek_level_5",
	"namek_level_6",
}

local function nextNamekAct(done)
	for _, id in ipairs(NAMEK_STORY_ACTS) do
		if not done[id] then
			return id
		end
	end
	return nil
end

local function hasMacroUnits()
	if not inv or not inv.session or not inv.session.collection then
		return false
	end
	local allOwned = inv.session.collection.collection_profile_data
	allOwned = allOwned and allOwned.owned_units
	if type(allOwned) ~= "table" then
		return false
	end
	local hasIchigo, hasNaruto = false, false
	for _, unit in pairs(allOwned) do
		if unit.unit_id == "ichigo" then
			hasIchigo = true
		elseif unit.unit_id == "naruto" then
			hasNaruto = true
		end
		if hasIchigo and hasNaruto then
			return true
		end
	end
	return false
end

local function needsRoll(lv)
	if progress.DailyChallenge then
		return false
	end
	local sessionData = inv and inv.session and inv.session.profile_data and inv.session.profile_data.level_data
	local doneTable = (sessionData and sessionData.completed_story_levels) or {}
	local isStoryDone = not nextNamekAct(doneTable)

	if isStoryDone or progress.FarmLevel or progress.FarmInfinite then
		if not hasMacroUnits() then
			local bCost = 50
			local balance = val(LP:FindFirstChild("_stats"), "gem_amount", 0)
			return type(balance) == "number" and balance >= bCost
		end
		return false
	end

	return progress.LastResult == "DEFEAT" or not ready()
end

local function getUnitLevel(xp)
	if not xp or xp <= 0 then
		return 1
	end
	if UnitServiceCore and UnitServiceCore.calculate_level then
		local ok, lv = pcall(function()
			return UnitServiceCore:calculate_level(xp)
		end)
		if ok and type(lv) == "number" and lv > 0 then
			return lv
		end
	end
	local v = math.log(xp / 1000 + 1) / 0.0769610411361284
	return math.floor(v) + 1
end

local function feedMacroUnits()
	if not inv or not inv.session then
		return
	end
	local collection = inv.session.collection and inv.session.collection.collection_profile_data
	local ownedUnits = collection and collection.owned_units
	if not ownedUnits then
		return
	end

	local normal_items = (inv.session.inventory and inv.session.inventory.inventory_profile_data and inv.session.inventory.inventory_profile_data.normal_items) or {}
	local xpItems = (LevelUtilCore and LevelUtilCore.xp_items) or {
		"senzu_bean", "aot_fluid", "wisteria_flower", "ramen_xp", "xp_devil_fruit",
		"coffee", "soul_candy", "hxh_fish", "fairy_tail_exp", "jjk_talisman",
		"black_clover_stone", "jojo_pendant", "opm_core", "7ds_pie", "quirk_shard",
		"dressrosa_grapes", "sao_xp_item", "berserk_coin_bag", "overlord_potion",
		"fate_pendant", "chakra_rod", "jjk_talisman2"
	}

	for _, unitName in ipairs({ "ichigo", "naruto" }) do
		local bestCopy, bestUuid = nil, nil
		for uuid, u in pairs(ownedUnits) do
			if u.unit_id == unitName then
				if not bestCopy or (u.xp or 0) > (bestCopy.xp or 0) then
					bestCopy = u
					bestUuid = uuid
				end
			end
		end

		if bestCopy and bestUuid then
			local curLv = getUnitLevel(bestCopy.xp or 0)
			if curLv < 60 then
				local toFeed = {}
				local totalItems = 0
				for _, itemId in ipairs(xpItems) do
					local count = normal_items[itemId] or 0
					if count > 0 then
						toFeed[itemId] = count
						totalItems = totalItems + count
					end
				end

				if totalItems > 0 then
					status(string.format("Feeding macro unit %s (Lv %d/60) with %d items...", unitName, curLv, totalItems))
					pcall(remote, "level_up_feed", bestUuid, toFeed)
					task.wait(1)
					local afterXp = (ownedUnits[bestUuid] and ownedUnits[bestUuid].xp) or 0
					local afterLv = getUnitLevel(afterXp)
					status(string.format("Fed %s: Lv %d -> Lv %d", unitName, curLv, afterLv))
				end
			end
		end
	end
end

local function claimLevelMilestones()
	local okM, rewardsData = pcall(function()
		return require(RS.src.Data.PlayerLevelRewards)
	end)
	if not okM or type(rewardsData) ~= "table" then
		return
	end
	local curLv = playerLevel() or 1
	local prof = inv and inv.session and inv.session.profile_data
	local claimed = prof and prof.level_rewards_claimed or {}
	for _, entry in pairs(rewardsData) do
		if type(entry) == "table" and type(entry.level) == "number" then
			local reqLv = entry.level
			if curLv >= reqLv and not claimed[reqLv] and not claimed[tostring(reqLv)] then
				pcall(function()
					remote("claim_player_level_rewards", reqLv)
				end)
				status(string.format("Claimed level milestone reward for Level %d", reqLv))
				task.wait(0.5)
			end
		end
	end
end

local MatchmakingModes = {
	["Daily Challenge"] = "__DAILY_CHALLENGE",
	["__DAILY_CHALLENGE"] = "__DAILY_CHALLENGE",
	["Summer Event"] = "summer2_event",
	["summer2_event"] = "summer2_event",
	["Stain"] = "mha_stain",
	["mha_stain"] = "mha_stain",
	["Feitan"] = "hxh_feitan",
	["hxh_feitan"] = "hxh_feitan",
}

local function RefreshMatchmakingModes()
	local src = RS:FindFirstChild("src")
	local data = src and src:FindFirstChild("Data")
	local levelsMod = data and data:FindFirstChild("Levels")

	if not levelsMod then
		return MatchmakingModes
	end

	local function register(module)
		local ok, rows = pcall(require, module)
		if not ok or type(rows) ~= "table" then
			return
		end

		for id, info in pairs(rows) do
			if type(id) == "string" and type(info) == "table" and info._MATCHMAKING then
				local name = tostring(info.name or id):gsub("<[^>]+>", "")
				MatchmakingModes[name .. " [" .. id .. "]"] = id
				MatchmakingModes[id] = id
			end
		end
	end

	if levelsMod:IsA("ModuleScript") then
		register(levelsMod)
	else
		for _, obj in ipairs(levelsMod:GetDescendants()) do
			if obj:IsA("ModuleScript") then
				register(obj)
			end
		end
	end

	return MatchmakingModes
end

getgenv().Matchmaking = function(mode)
	if type(mode) ~= "string" then
		return false, "Invalid matchmaking mode"
	end

	local modes = RefreshMatchmakingModes()
	local id = modes[mode]

	if not id then
		for name, value in pairs(modes) do
			if name:lower() == mode:lower() or value:lower() == mode:lower() then
				id = value
				break
			end
		end
	end

	if not id then
		warn("[Bocchi] Unsupported mode:", mode)
		return false, "Unsupported mode"
	end

	if game.PlaceId ~= 8304191830 then
		return false, "Must be in the lobby"
	end

	local matchRemote = RS
		:WaitForChild("endpoints")
		:WaitForChild("client_to_server")
		:WaitForChild("request_matchmaking")

	local ok, result = pcall(function()
		return matchRemote:InvokeServer(id)
	end)

	if not ok or result == false then
		warn("[Bocchi] Matchmaking failed:", result)
		return false, result
	end

	print("[Bocchi] Matchmaking requested:", mode, id)
	return true, result
end

getgenv().GetMatchmakingModes = RefreshMatchmakingModes

local function isDailyChallengeCleared()
	local ok, chall = pcall(function()
		local gdc = rem and rem:FindFirstChild("get_daily_challenge")
		if gdc then
			return gdc:InvokeServer()
		end
		return remote("get_daily_challenge")
	end)
	if not ok or type(chall) ~= "table" or not chall.current_uuid then
		return false
	end
	local prof = inv and inv.session and inv.session.profile_data
	local lastCompleted = prof and prof.last_completed_daily_challenge_uuid
	if lastCompleted and lastCompleted == chall.current_uuid then
		return true
	end
	local pGui = LP and LP:FindFirstChild("PlayerGui")
	local sGui = pGui and pGui:FindFirstChild("SurfaceGui")
	local challClr = sGui and sGui:FindFirstChild("ChallengeCleared")
	local clr = challClr and challClr:FindFirstChild("clear")
	if clr and clr.Visible then
		return true
	end
	return false
end

local function plan(done, lv)
	local minGemCost = math.huge
	for _, b in pairs(banners or {}) do
		if b.active == true and type(b.gem_cost) == "number" and b.gem_cost > 0 then
			minGemCost = math.min(minGemCost, b.gem_cost)
		end
	end
	if minGemCost == math.huge then
		minGemCost = 50
	end
	local gems = val(LP:FindFirstChild("_stats"), "gem_amount", 0)
	local outOfGems = type(gems) == "number" and gems < minGemCost

	local targetLevel = tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40
	local dailyReqLevel = 25
	local uncompletedAct = nextNamekAct(done)

	if uncompletedAct then
		progress.FarmInfinite = false
		progress.FarmLevel = false
		progress.DailyChallenge = false
		progress.TargetDifficulty = "Normal"
		return uncompletedAct
	end

	local dailyEnabled = (cfg["Daily Challenge"] == true or cfg.DailyChallenge == true)
	if dailyEnabled and lv >= dailyReqLevel then
		local currentCycleDay = math.floor((os.time() - 3600) / 86400)
		if progress.DailyChallengeDay ~= currentCycleDay then
			progress.DailyChallengeDay = currentCycleDay
			progress.DailyChallengeCleared = false
			saveSession()
		end

		if not progress.DailyChallengeCleared and isDailyChallengeCleared() then
			progress.DailyChallengeCleared = true
			saveSession()
		end

		if not progress.DailyChallengeCleared then
			progress.FarmInfinite = false
			progress.FarmLevel = false
			progress.DailyChallenge = true
			progress.TargetDifficulty = "Normal"
			status(string.format("Level %d >= %d & Daily Challenge pending: Joining Matchmaking...", lv, dailyReqLevel))
			return "__DAILY_CHALLENGE"
		end
	end

	if lv < targetLevel then
		progress.FarmInfinite = false
		progress.FarmLevel = true
		progress.DailyChallenge = false
		progress.TargetDifficulty = "Hard"

		feedMacroUnits()

		if not hasMacroUnits() then
			status(string.format("Level %d/%d: Farm Level needs ichigo & naruto; will roll in Lobby", lv, targetLevel))
		else
			status(string.format("Level %d/%d: Farm Level via namek_level_1 Hard (Macro like Infinite, Lose Wave 6)", lv, targetLevel))
		end

		if progress.MustRetryStory then
			return "namek_level_1"
		end

		return "namek_level_1"
	end

	progress.FarmInfinite = true
	progress.FarmLevel = false
	progress.DailyChallenge = false
	progress.TargetDifficulty = "Hard"

	feedMacroUnits()

	if not hasMacroUnits() then
		status(string.format("Level %d >= %d & Namek Cleared: needs ichigo & naruto; will roll in Lobby", lv, targetLevel))
	else
		status(string.format("Level %d >= %d & Namek Cleared: Farming Gems via namek_infinite!", lv, targetLevel))
	end

	return "namek_infinite"
end

local function GetCodes()
	local CODES = {}
	local ok, output = pcall(request, {
		Url = "https://beebom.com/anime-adventures-codes/",
		Method = "GET",
	})
	if ok and type(output) == "table" and output.Body then
		local p1 = string.find(output.Body, "Working Anime Adventures Codes")
		if p1 then
			local endUl = string.find(output.Body, "</ul>", p1)
			local section = endUl and string.sub(output.Body, p1, endUl) or string.sub(output.Body, p1, p1 + 2000)
			for code in string.gmatch(section, "<li>%s*<strong>([^<]+)</strong>") do
				local clean = string.gsub(code, "%s+$", "")
				clean = string.gsub(clean, "^%s+", "")
				if clean ~= "" then
					table.insert(CODES, clean)
				end
			end
		end
	end
	return CODES
end

local function ensureSocialRequirements(groupId)
	local lp = LP or game:GetService("Players").LocalPlayer
	local inGroup = false
	local okG, resG = pcall(function()
		return lp:IsInGroupAsync(groupId)
	end)
	if okG and resG then
		inGroup = true
	end

	if not inGroup then
		status("Account not in group " .. tostring(groupId) .. ", auto-joining group...")
		local gs = game:GetService("GroupService")
		local cg = game:GetService("CoreGui")
		local vim = game:GetService("VirtualInputManager")
		local guiService = game:GetService("GuiService")

		task.spawn(function()
			pcall(function()
				gs:PromptJoinAsync(groupId)
			end)
		end)

		local start = os.clock()
		while os.clock() - start < 5 do
			task.wait(0.2)
			local wrapper = cg:FindFirstChild("RobloxGui")
				and cg.RobloxGui:FindFirstChild("FocusNavigationCoreScriptsWrapper")
			local actions = wrapper
				and wrapper:FindFirstChild("Main", true)
				and wrapper.Main:FindFirstChild("ActionsContainer", true)
			local joinBtn = actions and (actions:FindFirstChild("1-Join Community") or actions:FindFirstChildWhichIsA("ImageButton"))
			if joinBtn and joinBtn.Visible then
				pcall(function()
					guiService.SelectedCoreObject = joinBtn
				end)
				task.wait(0.05)
				vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.05)
				vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				task.wait(0.05)
				vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
				task.wait(0.5)
				break
			end
		end
	end
end

local function claim()
	claimLevelMilestones()
	for _, name in ipairs({ "claim_daily_reward", "claim_battlepass_rewards" }) do
		pcall(remote, name)
	end
	local handler = inv.session.quest_handler
	local quests = handler and handler.quest_profile_data and handler.quest_profile_data.quests
	for id in pairs(quests or {}) do
		if not alive() then
			return
		end
		pcall(remote, "redeem_quest", tostring(id))
		task.wait(0.15)
	end

	if cfg.AutoRedeemCodes then
		local redeemed = progress.RedeemedCodes
		if type(redeemed) ~= "table" then
			redeemed = {}
			progress.RedeemedCodes = redeemed
		end
		local gameRedeemed = inv.session
			and inv.session.profile_data
			and inv.session.profile_data.redeemed_codes
		local codeList = GetCodes()
		for _, code in ipairs(codeList) do
			if not alive() then
				return
			end
			local key = tostring(code):upper():gsub("%s+", "")
			if key ~= "" and not redeemed[key] and not (gameRedeemed and gameRedeemed[key]) then
				local ok, res, groupId = pcall(remote, "redeem_code", code, true)
				if ok and res == "needs_social" and groupId then
					ensureSocialRequirements(groupId)
					task.wait(1)
					ok, res = pcall(remote, "redeem_code", code, true)
				end

				if ok and res ~= "needs_social" then
					status("Redeemed code: " .. code)
					redeemed[key] = true
					saveSession()
				else
					local errStr = tostring(res):lower()
					if errStr:find("already") or errStr:find("invalid") or errStr:find("expired") then
						redeemed[key] = true
					end
				end
				task.wait(0.5)
			end
		end
	end
end

local team

local function isCEO(def, unitId)
	local id = tostring(unitId or (def and def.id) or ""):lower()
	local name = tostring(def and def.name or ""):lower()
	return id == "speedwagon" or name:find("c%.e%.o") ~= nil
end

local function isFarmUnit(def, unitId)
	return isCEO(def, unitId) or (def and (def.farm_amount or 0) > 0)
end

local function lockProtectedUnits()
	local protectedUnits = { ichigo = true, naruto = true, speedwagon = true }
	local bestCopies = {}
	for _, unit in pairs(owned()) do
		local def = units[unit.unit_id]
		local isCeoUnit = isCEO(def, unit.unit_id)
		if (protectedUnits[unit.unit_id] or isCeoUnit) and type(unit.uuid) == "string" then
			local key = isCeoUnit and "speedwagon" or unit.unit_id
			local current = bestCopies[key]
			if
				not current
				or (unit.xp or 0) > (current.xp or 0)
				or (unit.level or 0) > (current.level or 0)
			then
				bestCopies[key] = unit
			end
		end
	end
	for _, bestUnit in pairs(bestCopies) do
		if not bestUnit.locked and rem and rem:FindFirstChild("lock_unlock_unit") then
			pcall(function()
				rem.lock_unlock_unit:InvokeServer(bestUnit.uuid)
			end)
		end
	end
	for _, unit in pairs(owned()) do
		local def = units[unit.unit_id]
		local isCeoUnit = isCEO(def, unit.unit_id)
		if (protectedUnits[unit.unit_id] or isCeoUnit) and type(unit.uuid) == "string" then
			local key = isCeoUnit and "speedwagon" or unit.unit_id
			local bestUnit = bestCopies[key]
			if bestUnit and unit.uuid ~= bestUnit.uuid and unit.locked then
				if rem and rem:FindFirstChild("lock_unlock_unit") then
					pcall(function()
						rem.lock_unlock_unit:InvokeServer(unit.uuid)
					end)
				end
			end
		end
	end
end

local function roomFor(count, lv)
	lockProtectedUnits()
	local obj = LP:FindFirstChild("PlayerGui")
	for _, name in ipairs({ "collection", "grid", "List", "Top", "Capacity" }) do
		obj = obj and obj:FindFirstChild(name)
	end
	local text = obj and obj.Text:gsub("<[^>]+>", ""):gsub(",", "")
	local cap = text and tonumber(text:match("/%s*(%d+)"))
	if not cap or cap <= 0 then
		status("Unit capacity unavailable; inventory cleanup skipped")
		return true
	end
	local total = 0
	for _ in pairs(owned()) do
		total += 1
	end
	local need = total + count - cap
	if need <= 0 then
		return true
	end
	local keep = equipped()
	if ready() then
		for _, unit in ipairs(team(lv)) do
			keep[unit.uuid] = true
		end
	end
	local protectedUnits = { ichigo = true, naruto = true, speedwagon = true }
	local bestCopies = {}
	for _, unit in pairs(owned()) do
		local def = units[unit.unit_id]
		local isCeoUnit = isCEO(def, unit.unit_id)
		if (protectedUnits[unit.unit_id] or isCeoUnit) and type(unit.uuid) == "string" then
			local key = isCeoUnit and "speedwagon" or unit.unit_id
			local current = bestCopies[key]
			if
				not current
				or (unit.xp or 0) > (current.xp or 0)
				or (unit.level or 0) > (current.level or 0)
			then
				bestCopies[key] = unit
			end
		end
	end
	for _, bestUnit in pairs(bestCopies) do
		keep[bestUnit.uuid] = true
	end
	local pool = {}
	for _, unit in pairs(owned()) do
		local def = units[unit.unit_id]
		local slot = tonumber(unit.equipped_slot)
		if
			def
			and settings.RARITY_TIERS[def.rarity] ~= nil
			and type(unit.uuid) == "string"
			and not keep[unit.uuid]
			and not unit.locked
			and not unit.favorite
			and not def.unsellable
			and not (slot and slot >= 1 and slot <= 6)
		then
			table.insert(pool, unit)
		end
	end
	table.sort(pool, function(a, b)
		local ra = settings.RARITY_TIERS[units[a.unit_id].rarity]
		local rb = settings.RARITY_TIERS[units[b.unit_id].rarity]
		if ra ~= rb then
			return ra < rb
		end
		if (a.xp or 0) ~= (b.xp or 0) then
			return (a.xp or 0) < (b.xp or 0)
		end
		return a.uuid < b.uuid
	end)
	if #pool < need then
		status("Inventory full; not enough unprotected units to sell")
		return false
	end
	status("Inventory full; selling " .. need .. " lowest-rarity units")
	local sold = {}
	for i = 1, need, 50 do
		local batch = {}
		for j = i, math.min(i + 49, need) do
			local uuid = pool[j].uuid
			table.insert(batch, uuid)
			sold[uuid] = true
		end
		remote("sell_units", batch)
	end
	local untilAt = os.clock() + 5
	repeat
		assert(alive(), "Kaitun stopped.")
		local pending = false
		for _, unit in pairs(owned()) do
			if sold[unit.uuid] then
				pending = true
				break
			end
		end
		if not pending then
			return true
		end
		task.wait(0.1)
	until os.clock() >= untilAt
	error("Unit sale not confirmed; summoning blocked.")
end

local function summon(lv)
	if progress.DailyChallenge then
		return ready()
	end
	local sessionData = inv and inv.session and inv.session.profile_data and inv.session.profile_data.level_data
	local doneTable = (sessionData and sessionData.completed_story_levels) or {}
	local isStoryDone = not nextNamekAct(doneTable)
	if (isStoryDone or progress.FarmInfinite or progress.FarmLevel) and hasMacroUnits() then
		return ready()
	end
	lv = lv or assert(playerLevel(), "Player level not ready.")
	local function confirmed()
		if not needsRoll(lv) then
			return true
		end
		local balance = val(LP:FindFirstChild("_stats"), "gem_amount")
		if
			ready()
			and type(balance) == "number"
			and type(progress.SummonGems) == "number"
			and balance < progress.SummonGems
		then
			return true
		end
		if type(progress.SummonSeen) == "table" then
			for key, unit in pairs(owned()) do
				if not progress.SummonSeen[tostring(unit.uuid or key)] then
					return true
				end
			end
		end
		return false
	end
	local function clearPending()
		progress.SummonPending, progress.SummonSeen = nil, nil
		progress.SummonAt, progress.SummonJob, progress.SummonGems = nil, nil, nil
		checkpoint("SummonConfirmed")
	end
	if not needsRoll(lv) then
		if progress.SummonPending then
			clearPending()
		end
		return ready()
	end
	if progress.SummonPending then
		if confirmed() or progress.SummonJob ~= game.JobId or not progress.SummonAt then
			clearPending()
		elseif os.time() - progress.SummonAt < 10 then
			status("Summon response pending")
			return ready()
		else
			local gems = val(LP:FindFirstChild("_stats"), "gem_amount")
			assert(
				gems == progress.SummonGems,
				"Summon spent gems but no new unit appeared; stopping to prevent duplicate spending."
			)
			clearPending()
		end
	end
	setActivity("Summoning")
	local ids = {}
	for id, def in pairs(banners) do
		if def.active == true and type(def.gem_cost) == "number" and def.gem_cost > 0 then
			table.insert(ids, id)
		end
	end
	table.sort(ids, function(a, b)
		return banners[a].gem_cost < banners[b].gem_cost
			or (banners[a].gem_cost == banners[b].gem_cost and a < b)
	end)
	local id = assert(ids[1], "No active gem banner available.")
	local function gems()
		return val(LP:FindFirstChild("_stats"), "gem_amount")
	end
	assert(type(gems()) == "number", "Gem balance not ready.")
	local left = gems()
	local cost = banners[id].gem_cost
	if left < cost then
		status(
			ready() and "Using current team; not enough gems"
				or "Waiting for gems to summon a starter unit"
		)
		return ready()
	end
	if LP.Character then
		LP.Character:PivotTo(CFrame.new(254.36, 197.82, -817.81))
	end
	local rolledAny = false
	while alive() and lobby() and needsRoll(lv) and math.min(left, gems()) >= cost do
		local count = math.min(left, gems()) >= cost * 10 and 10 or 1
		if not roomFor(count, lv) then
			if count == 1 or not roomFor(1, lv) then
				return ready()
			end
			count = 1
		end
		local summonReason = "Summoning a starter unit x"
		if not hasMacroUnits() and (isStoryDone or progress.FarmLevel or progress.FarmInfinite) then
			summonReason = "Summoning for macro units (ichigo & naruto) x"
		elseif progress.LastResult == "DEFEAT" then
			summonReason = "Summoning after defeat x"
		end
		status(summonReason .. count)
		local seen = {}
		for key, unit in pairs(owned()) do
			seen[tostring(unit.uuid or key)] = true
		end
		progress.SummonPending, progress.SummonSeen = true, seen
		progress.SummonAt, progress.SummonJob, progress.SummonGems = os.time(), game.JobId, gems()
		checkpoint("Summon")
		local ok, err = pcall(remote, "buy_from_banner", id, count == 10 and "gems10" or "gems")
		if not ok then
			if tostring(err):find("Server rejected: buy_from_banner", 1, true) then
				clearPending()
			end
			error(err)
		end
		rolledAny = true
		left -= cost * count
		local done, untilAt = false, os.clock() + 3
		repeat
			assert(alive(), "Kaitun stopped.")
			done = confirmed()
			if done then
				break
			end
			task.wait(0.2)
		until os.clock() >= untilAt
		if not done then
			checkpoint("SummonPending")
			status("Summon response pending")
			return ready()
		end
		clearPending()
		lockProtectedUnits()
		task.wait(1)
	end
	if rolledAny then
		if not isStoryDone then
			progress.MustRetryStory = true
		end
		progress.LastResult = nil
		table.clear(progress.Losses)
		checkpoint("RolledInLobby")
	end
	lockProtectedUnits()
	return ready()
end

local function dps(def, n)
	local damage, cd = def.damage or 0, def.attack_cooldown or 1
	for i = 1, n do
		local row = def.upgrade[i]
		damage, cd = row.damage or damage, row.attack_cooldown or cd
	end
	return damage / math.max(cd, 0.1)
end

function team(lv, plannedStage)
	local pool, cap = {}, slots(lv)
	for _, unit in pairs(owned()) do
		local def = units[unit.unit_id]
		if usable(def) and type(unit.uuid) == "string" then
			table.insert(pool, unit)
		end
	end
	local function better(a, b)
		local da, db = units[a.unit_id], units[b.unit_id]
		local ra = settings.RARITY_TIERS[da.rarity] or 0
		local rb = settings.RARITY_TIERS[db.rarity] or 0
		if ra ~= rb then
			return ra > rb
		end
		local sa, sb = dps(da, #(da.upgrade or {})), dps(db, #(db.upgrade or {}))
		if sa ~= sb then
			return sa > sb
		end
		if (a.xp or 0) ~= (b.xp or 0) then
			return (a.xp or 0) > (b.xp or 0)
		end
		return a.uuid < b.uuid
	end
	table.sort(pool, better)
	local out, seen, damage = {}, {}, false

	local bestCeo, bestFallbackFarm
	for _, unit in ipairs(pool) do
		local def = units[unit.unit_id]
		if isCEO(def, unit.unit_id) then
			if not bestCeo or (unit.xp or 0) > (bestCeo.xp or 0) or (unit.level or 0) > (bestCeo.level or 0) then
				bestCeo = unit
			end
		elseif isFarmUnit(def, unit.unit_id) then
			if not bestFallbackFarm or (unit.xp or 0) > (bestFallbackFarm.xp or 0) or (unit.level or 0) > (bestFallbackFarm.level or 0) then
				bestFallbackFarm = unit
			end
		end
	end
	local chosenCeo = bestCeo or bestFallbackFarm
	if chosenCeo and #out < cap then
		seen[chosenCeo.unit_id] = true
		table.insert(out, chosenCeo)
		for _, u in ipairs(pool) do
			local d = units[u.unit_id]
			if isFarmUnit(d, u.unit_id) then
				seen[u.unit_id] = true
			end
		end
	end

	local isMacroMode = progress.FarmInfinite or progress.FarmLevel or plannedStage == "namek_infinite" or (plannedStage == "namek_level_1" and (cfg.FarmLevel == true or cfg["Farm Level"] == true))
	if isMacroMode then
		for _, requiredName in ipairs({ "ichigo", "naruto" }) do
			for _, unit in ipairs(pool) do
				if unit.unit_id == requiredName and not seen[unit.unit_id] and #out < cap then
					seen[unit.unit_id] = true
					table.insert(out, unit)
					damage = damage or (units[unit.unit_id].damage or 0) > 0
					break
				end
			end
		end
	end

	for _, unit in ipairs(pool) do
		if #out < cap and not seen[unit.unit_id] then
			seen[unit.unit_id] = true
			table.insert(out, unit)
			damage = damage or (units[unit.unit_id].damage or 0) > 0
		end
	end
	if not damage and #out > 0 then
		for _, unit in ipairs(pool) do
			if (units[unit.unit_id].damage or 0) > 0 then
				out[#out] = unit
				damage = true
				break
			end
		end
	end
	assert(damage, "No usable damage unit owned. Summon or equip a starter first.")
	return out
end

local function equip(wanted)
	local cap = slots(assert(playerLevel(), "Player level unavailable"))
	for i = #wanted, cap + 1, -1 do
		table.remove(wanted, i)
	end
	assert(#wanted > 0, "No units or unlocked slots available")
	local ids, need = {}, {}
	for _, unit in ipairs(wanted) do
		table.insert(ids, unit.uuid)
		need[unit.uuid] = true
	end
	local function matches()
		local count = 0
		for uuid in pairs(equipped(cap)) do
			if not need[uuid] then
				return false
			end
			count += 1
		end
		return count == #wanted
	end
	local function done()
		equipping = nil
		checkpoint("Equipped")
		status("Equipped story team: " .. #wanted .. "/" .. cap)
		return true
	end
	if matches() then
		return done()
	end
	local key = table.concat(ids, "|")
	if not equipping or equipping.key ~= key then
		status("Preparing story team: " .. #wanted .. " units")
		checkpoint("Equip")
		equipping = { key = key, phase = "clear", at = os.clock() }
		remote("unequip_all")
	end
	if equipping.phase == "clear" then
		local untilAt = math.min(os.clock() + 3, equipping.at + 10)
		while next(equipped()) and os.clock() < untilAt do
			assert(alive(), "Kaitun stopped.")
			task.wait(0.1)
		end
		if next(equipped()) then
			if os.clock() - equipping.at >= 10 then
				status("Unequip timed out; retrying unequip next cycle")
				equipping = nil
				return false
			end
			status("Waiting for unequip confirmation")
			return false
		end
		task.wait(1)
		status("Equipping story team")
		equipping.phase = "equip"
		for _, chosen in ipairs(wanted) do
			remote("equip_unit", chosen.uuid)
			task.wait(1)
		end
		equipping.at = os.clock()
	end
	local untilAt = math.min(os.clock() + 3, equipping.at + 10)
	repeat
		assert(alive(), "Kaitun stopped.")
		if matches() then
			return done()
		end
		task.wait(0.1)
	until os.clock() >= untilAt
	if not matches() then
		if os.clock() - equipping.at >= 10 then
			status("Equip confirmation timed out; retrying equip next cycle")
			equipping = nil
			return false
		end
		status("Waiting for equipped units in unlocked slots")
		return false
	end
	return done()
end

local function join(id)
	if id == "__DAILY_CHALLENGE" then
		status("Joining Daily Challenge via Matchmaking...")
		checkpoint("JoinDailyChallenge", id)
		local ok, res = getgenv().Matchmaking("__DAILY_CHALLENGE")
		if not ok then
			status("Matchmaking failed: " .. tostring(res) .. "; retrying next cycle")
			return
		end
		status("Matchmaking requested for Daily Challenge. Waiting for match teleport...")
		local started = false
		local untilAt = os.clock() + 60
		repeat
			if not alive() then
				return
			end
			if not lobby() then
				started = true
				break
			end
			task.wait(0.5)
		until os.clock() >= untilAt

		if not started then
			status("Daily Challenge matchmaking timed out; cancelling queue")
			pcall(function()
				local lm = rem and rem:FindFirstChild("leave_matchmaking")
				if lm then
					lm:InvokeServer()
				end
			end)
			return
		end
		return
	end

	local root = workspace:FindFirstChild("_LOBBIES")
	local folder = root and root:FindFirstChild("Story")
	local obj
	for _, candidate in ipairs(folder and folder:GetChildren() or {}) do
		local players = candidate:FindFirstChild("Players")
		if players and #players:GetChildren() == 0 and not val(candidate, "Active", false) then
			obj = candidate
			break
		end
	end
	if not obj then
		status("Waiting for an empty story lobby")
		return
	end
	status("Story: " .. (levels[id].name or id))
	checkpoint("Join", id)
	room = obj.Name

	if LP.Character then
		local cf = (obj:IsA("Model") and obj:GetPivot())
			or (obj:IsA("BasePart") and obj.CFrame)
			or (obj:FindFirstChildWhichIsA("BasePart") and obj:FindFirstChildWhichIsA("BasePart").CFrame)
		if cf then
			LP.Character:PivotTo(cf + Vector3.new(0, 3, 0))
			task.wait(0.5)
		end
	end

	local ok, res = pcall(remote, "request_join_lobby", room)
	if not ok or res == false then
		status("Could not join lobby pod; retrying next cycle")
		room = nil
		return
	end

	task.wait(1)
	local matchData = levels[id] and levels[id]._MATCHMAKING
	local difficulty = progress.TargetDifficulty
		or (matchData and matchData.difficulty)
		or (levels[id] and levels[id].difficulty)
		or "Normal"
	pcall(remote, "request_lock_level", room, id, true, difficulty)
	task.wait(1)
	pcall(remote, "request_start_game", room)

	local started = false
	local untilAt = os.clock() + 60
	repeat
		if not alive() then
			return
		end
		if not lobby() then
			started = true
			break
		end
		task.wait(0.5)
	until os.clock() >= untilAt

	if not started then
		status("Story start timed out; leaving pod")
		if rem and rem:FindFirstChild("request_leave_lobby") then
			pcall(function()
				rem.request_leave_lobby:InvokeServer(room)
			end)
		end
		room = nil
		return
	end

	room = nil
end

local function placement(info, key)
	local uSettings = (cfg.byId and cfg.byId[info.uuid]) or (cfg.UnitSettings and cfg.UnitSettings[info.uuid])
	local cleanKey = key:gsub(" ", "")
	local value = uSettings and uSettings[cleanKey]
	if value ~= nil then
		return value
	end
	return cfg[key]
end

local function pathAt(lane, info)
	assert(lane, "Map path not ready.")
	local nodes, length = {}, 0
	for _, part in ipairs(lane:GetChildren()) do
		if part:IsA("BasePart") and tonumber(part.Name) then
			table.insert(nodes, part)
		end
	end
	table.sort(nodes, function(a, b)
		return tonumber(a.Name) < tonumber(b.Name)
	end)
	assert(nodes[1], "Map path has no waypoints.")
	for i = 2, #nodes do
		length += (nodes[i].Position - nodes[i - 1].Position).Magnitude
	end
	local pct = (info and placement(info, "Path Position")) or cfg["Path Position"] or 5
	if not pct or pct > 10 then
		pct = 5
	end
	local distance = length * pct / 100
	for i = 2, #nodes do
		local a, b = nodes[i - 1].Position, nodes[i].Position
		local size = (b - a).Magnitude
		if size > 0 and distance <= size then
			return a:Lerp(b, distance / size)
		end
		distance -= size
	end
	return nodes[#nodes].Position
end

local function pathPoint(info)
	local bases = workspace:FindFirstChild("_BASES")
	local lanes = bases and bases:FindFirstChild("pve")
	lanes = lanes and lanes:FindFirstChild("LANES")
	assert(lanes, "Map path not ready.")
	local a, b = lanes:FindFirstChild("1"), lanes:FindFirstChild("2")
	if placement(info, "Path Target") == "Path 2" then
		return pathAt(b or a, info)
	end
	local point = pathAt(a or b, info)
	return placement(info, "Path Target") == "Between Paths" and a and b and point:Lerp(pathAt(b, info), 0.5)
		or point
end

local function level()
	if currentMatchData then
		local mapName = currentMatchData.map or (currentMatchData.id and currentMatchData.id:match("^[^_]+")) or "unknown"
		return {
			id = currentMatchData.id,
			map = mapName,
			data = currentMatchData,
		}
	end
	return { map = "unknown", id = "unknown" }
end

local function frame(text)
	if typeof(text) == "CFrame" then
		return text
	elseif typeof(text) == "Vector3" then
		return CFrame.new(text)
	elseif type(text) == "string" then
		return parseCFrame(text) or CFrame.new()
	end
	return CFrame.new()
end

local function ray(origin, surface, distance)
	if not surface then
		return nil
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { surface }
	return workspace:Raycast(origin, Vector3.new(0, -(distance or 256), 0), params)
end

local function offset(n)
	if n == 0 then
		return Vector3.new(0, 0, 0)
	end
	local layer = math.ceil((math.sqrt(n + 1) - 1) / 2)
	local at, size = n - (2 * layer - 1) ^ 2, layer * 2
	if at < size then
		return Vector3.new(layer, 0, -layer + at)
	elseif at < size * 2 then
		return Vector3.new(layer - (at - size), 0, layer)
	elseif at < size * 3 then
		return Vector3.new(-layer, 0, layer - (at - size * 2))
	end
	return Vector3.new(-layer + (at - size * 3), 0, -layer)
end

local function circlePlace(index, n, info)
	local data = level()
	local skyPosition = cfg["Auto Position Sky Island"] and data.map == "skypiea"
	local hill = (info.data and info.data.hill_unit)
		or (data.map == "skypiea" and info.data and info.data.hybrid_placement)
	local stored = cfg.AutoPlacePositions and cfg.AutoPlacePositions[data.map]
	local text = type(stored) == "table" and (stored["Unit" .. index] or stored.Center)
	if not skyPosition and placement(info, "Position Mode") == "Shared Position" then
		text = type(stored) == "table" and stored.Center
		assert(text, "Use Set Pos for this map first.")
	end
	local id = data.id and data.id:match("^[^_]+") or data.map
	local point = skyPosition and Vector3.new(-1910.7, 186.3, -310.4)
		or placement(info, "Position Mode") == "Path" and pathPoint(info)
		or text and frame(text).Position
		or points[(hill and "hill_" or "") .. id]
	local terrain = workspace:FindFirstChild("_terrain")
	assert(terrain, "Map terrain not ready.")
	if not point then
		local bases = workspace:FindFirstChild("_BASES")
		local lane = bases and bases:FindFirstChild("pve")
		lane = lane and lane:FindFirstChild("LANES")
		lane = lane and lane:FindFirstChild("1")
		assert(lane, "Map lanes not ready. Use Set Pos first.")
		local first
		for _, part in ipairs(lane:GetChildren()) do
			local num = tonumber(part.Name)
			if num and (not first or num < tonumber(first.Name)) then
				first = part
			end
		end
		assert(first, "No placement point. Use Set Pos first.")
		point = first.Position
	end
	local farm = isFarmUnit(info.data, info.id)
		or tostring(info.id):match("^speedwagon")
		or tostring(info.id):match("^bulma")
	local want = point + offset(farm and n + 9 or n) * (farm and 2 or 1)
	local folder = workspace:FindFirstChild("_UNITS")
	local function clear(pos)
		for _, unit in ipairs(folder and folder:GetChildren() or {}) do
			local shadow = unit:FindFirstChild("_shadow")
			if shadow then
				local delta = shadow.Position - pos
				if delta.X ^ 2 + delta.Z ^ 2 < 1 and math.abs(delta.Y) < 4 then
					return false
				end
			end
		end
		return true
	end
	local surface = terrain:FindFirstChild(hill and "hill" or "ground")
		or terrain:FindFirstChild("ground")
		or terrain:FindFirstChild("hill")
	local hit = ray(want + Vector3.new(0, 128, 0), surface, 256)
	if hit and clear(hit.Position) then
		return CFrame.new(hit.Position)
	end
	if
		not hill
		and not (info.data and info.data.hybrid_placement)
		and placement(info, "Position Mode") ~= "Path"
	then
		return
	end
	surface = terrain:FindFirstChild(
		placement(info, "Position Mode") == "Path" and not hill and "ground" or "hill"
	) or surface
	if not surface then
		return
	end
	if not spots[surface] then
		local parts = {}
		if surface:IsA("BasePart") then
			table.insert(parts, surface)
		end
		for _, part in ipairs(surface:GetDescendants()) do
			if part:IsA("BasePart") then
				table.insert(parts, part)
			end
		end
		spots[surface] = parts
	end
	local candidates = {}
	local function add(grid, dx, dz)
		local key = dx .. ":" .. dz
		if
			grid.seen[key]
			or dx < math.floor((-grid.x - grid.p.X))
			or dx > math.ceil((grid.x - grid.p.X))
			or dz < math.floor((-grid.z - grid.p.Z))
			or dz > math.ceil((grid.z - grid.p.Z))
		then
			return
		end
		grid.seen[key] = true
		local pos = grid.part.CFrame:PointToWorldSpace(
			Vector3.new(
				math.clamp(grid.p.X + dx, -grid.x, grid.x),
				grid.part.Size.Y / 2,
				math.clamp(grid.p.Z + dz, -grid.z, grid.z)
			)
		)
		table.insert(candidates, { grid = grid, x = dx, z = dz, pos = pos, dist = (pos - want).Magnitude })
	end
	for _, part in ipairs(spots[surface]) do
		local p = part.CFrame:PointToObjectSpace(want)
		local x, z = math.max(0, part.Size.X / 2 - 0.25), math.max(0, part.Size.Z / 2 - 0.25)
		add({
			part = part,
			p = Vector3.new(math.clamp(p.X, -x, x), 0, math.clamp(p.Z, -z, z)),
			x = x,
			z = z,
			seen = {},
		}, 0, 0)
	end
	local maxIterations = 60
	local count = 0
	while #candidates > 0 and count < maxIterations do
		count += 1
		table.sort(candidates, function(a, b)
			return a.dist > b.dist
		end)
		local row = table.remove(candidates)
		hit = ray(row.pos + Vector3.new(0, 4, 0), surface, 8)
		if hit and clear(hit.Position) then
			return CFrame.new(hit.Position)
		end
		add(row.grid, row.x + 1, row.z)
		add(row.grid, row.x - 1, row.z)
		add(row.grid, row.x, row.z + 1)
		add(row.grid, row.x, row.z - 1)
	end
end

local function smartPlace(index, n, info)
	local mapData = level()
	if
		(cfg["Auto Position Sky Island"] and mapData.map == "skypiea")
		or (mapData.map == "skypiea" and info.data and info.data.hybrid_placement)
		or placement(info, "Placement Mode") == "Circle"
		or placement(info, "Position Mode") == "Shared Position"
		or placement(info, "Position Mode") == "Path"
	then
		return circlePlace(index, n, info)
	end
	local map = mapData.map
	local stored = cfg.AutoPlacePositions and cfg.AutoPlacePositions[map]
	local cap = math.min((info.data and info.data.spawn_cap) or 5, 4)
	if stored and stored["Unit" .. index] then
		return frame(stored["Unit" .. index]) + offset(n)
	end
	local id = mapData.id and mapData.id:match("^[^_]+") or map
	local point = points[((info.data and info.data.hill_unit) and "hill_" or "") .. id]
	if point then
		return CFrame.new(point + offset(n))
	end
	local terrain = workspace:FindFirstChild("_terrain")
	assert(terrain, "Map terrain not ready.")
	if not spots[index] then
		local bases = workspace:FindFirstChild("_BASES")
		local lane = bases and bases:FindFirstChild("pve") and bases.pve:FindFirstChild("LANES")
		lane = lane and lane:FindFirstChild("1")
		if not lane then
			return circlePlace(index, n, info)
		end
		local lanePoints = {}
		for _, part in ipairs(lane:GetChildren()) do
			if tonumber(part.Name) then
				table.insert(lanePoints, part)
			end
		end
		table.sort(lanePoints, function(a, b)
			return tonumber(a.Name) < tonumber(b.Name)
		end)
		local anchor = lanePoints[math.min(index, #lanePoints)]
		if not anchor then
			return circlePlace(index, n, info)
		end
		local candidates = {}
		if info.data and info.data.hill_unit then
			local hill = terrain:FindFirstChild("hill")
			for _, part in ipairs(hill and hill:GetDescendants() or {}) do
				if part:IsA("BasePart") then
					table.insert(candidates, part.Position + Vector3.new(0, part.Size.Y / 2, 0))
				end
			end
			table.sort(candidates, function(a, b)
				return (a - anchor.Position).Magnitude < (b - anchor.Position).Magnitude
			end)
		else
			for _, part in ipairs(lanePoints) do
				table.insert(candidates, part.Position)
			end
		end
		for _, pt in ipairs(candidates) do
			local validPoint = true
			for other, pos in pairs(spots) do
				if type(other) == "number" and other ~= index and (pos - pt).Magnitude < 5 then
					validPoint = false
					break
				end
			end
			for j = 0, cap - 1 do
				if
					not validPoint
					or not ray(
						pt + offset(j) + Vector3.new(0, 12, 0),
						terrain:FindFirstChild((info.data and info.data.hill_unit) and "hill" or "ground"),
						20
					)
				then
					validPoint = false
					break
				end
			end
			if validPoint then
				spots[index] = pt
				break
			end
		end
	end
	if not spots[index] then
		return circlePlace(index, n, info)
	end
	local hit = ray(
		spots[index] + offset(n) + Vector3.new(0, 12, 0),
		terrain:FindFirstChild((info.data and info.data.hill_unit) and "hill" or "ground"),
		20
	)
	if hit then
		return CFrame.new(hit.Position)
	end
	return circlePlace(index, n, info)
end

local function runToSpot(targetPos)
	local char = LP and LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or hum.Health <= 0 then
		return
	end

	local flatRemaining = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
	if flatRemaining <= 5 then
		return
	end

	local origSpeed = hum.WalkSpeed
	hum.WalkSpeed = 28

	local pfs = game:GetService("PathfindingService")
	local path = pfs:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		WaypointSpacing = 4,
	})

	local ok, _ = pcall(function()
		path:ComputeAsync(hrp.Position, targetPos)
	end)

	if ok and path.Status == Enum.PathStatus.Success then
		local waypoints = path:GetWaypoints()
		local start = os.clock()
		for i = 1, #waypoints do
			local wp = waypoints[i]
			if not alive() or not hum or hum.Health <= 0 or not hrp then
				break
			end
			local dTarget = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
			if dTarget <= 4 then
				break
			end
			if os.clock() - start > 6 then
				break
			end

			if wp.Action == Enum.PathWaypointAction.Jump then
				hum.Jump = true
			end

			hum:MoveTo(wp.Position)

			local reachDist = (i == #waypoints) and 3 or 4
			local wpTimeout = os.clock() + 1.2
			while os.clock() < wpTimeout do
				if not alive() or not hum or not hrp then
					break
				end
				local d = (Vector3.new(wp.Position.X, 0, wp.Position.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
				if d <= reachDist then
					break
				end
				task.wait(0.03)
			end
		end
	else
		hum:MoveTo(targetPos)
		local start = os.clock()
		while os.clock() - start < 3 do
			if not alive() or not hum or not hrp then
				break
			end
			local d = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
			if d <= 4 then
				break
			end
			task.wait(0.03)
		end
	end

	if hum and hum.Parent then
		hum.WalkSpeed = origSpeed
	end
	if hrp and hrp.Parent then
		pcall(function()
			hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
		end)
	end
end

local function combat(point, attempt)
	local folder = workspace:FindFirstChild("_UNITS")
	if not folder then
		return attempt
	end
	local data = workspace:FindFirstChild("_DATA")
	if val(data, "GameFinished", false) then
		return attempt
	end
	local money = val(LP:FindFirstChild("_stats"), "resource", 0)
	local scale = val(data and data:FindFirstChild("LevelModifiers"), "player_cost_scale", 1)
	local counts, total, mine, attackers = {}, {}, {}, 0
	for _, unit in ipairs(folder:GetChildren()) do
		local stats = unit:FindFirstChild("_stats")
		local id, uuid = val(stats, "id"), val(stats, "uuid")
		if id then
			total[id] = (total[id] or 0) + 1
		end
		if uuid and val(stats, "player") == LP then
			counts[uuid] = (counts[uuid] or 0) + 1
			table.insert(mine, unit)
			if units[id] and (units[id].damage or 0) > 0 then
				attackers += 1
			end
		end
	end
	local best
	local function offer(action, cost, score)
		if cost < 0 or cost > money then
			return
		end
		if not best or score > best.score then
			action.score = score
			best = action
		end
	end

	local eq = equipped()
	for _, unit in pairs(owned()) do
		local slotIndex = eq[unit.uuid]
		if not slotIndex then
			continue
		end
		local def = units[unit.unit_id]
		if not def then
			continue
		end
		local farm = isFarmUnit(def, unit.unit_id)
		local count = counts[unit.uuid] or 0
		local cap = def.spawn_cap or 5
		for _, trait in pairs(unit.traits or {}) do
			if trait.trait == "unique" then
				cap = 1
			end
		end
		if farm then
			cap = math.min(cap, 3)
		end
		if
			count < cap
			and (not def.global_spawn_cap or (total[unit.unit_id] or 0) < def.global_spawn_cap)
		then
			local info = {
				id = unit.unit_id,
				uuid = unit.uuid,
				data = def,
			}
			local cf = smartPlace(slotIndex, count + attempt, info)
			if cf then
				local cost = (def.cost or math.huge) * scale
				local rarityTier = (def.rarity and settings.RARITY_TIERS[def.rarity]) or 1
				local maxTierDps = dps(def, #(def.upgrade or {}))
				local powerScore = rarityTier * 10000000 + maxTierDps * 500 + (7 - slotIndex) * 10000
				local spawnScore
				if attackers == 0 and not farm then
					spawnScore = 200000000 + powerScore
				elseif farm and count < cap and attackers >= 1 then
					spawnScore = 130000000 + (cap - count) * 1000000
				elseif attackers == 1 and not farm then
					spawnScore = 70000000 + powerScore
				elseif not farm and count < cap then
					spawnScore = 15000000 + powerScore - (count * 200000) - cost * 0.001
				else
					spawnScore = 5000000 + powerScore
				end
				offer({ name = "spawn_unit", uuid = unit.uuid, cf = cf }, cost, spawnScore)
			end
		end
	end

	local hasUnmaxedHigherTier = false
	for _, unit in ipairs(mine) do
		local stats = unit:FindFirstChild("_stats") or unit._stats
		if stats then
			local unitId = val(stats, "id")
			local def = units[unitId]
			if def and not isFarmUnit(def, unitId) then
				local rTier = (def.rarity and settings.RARITY_TIERS[def.rarity]) or 1
				local curUp = val(stats, "upgrade", 0)
				local maxUp = #(def.upgrade or {})
				if rTier > 2 and curUp < maxUp then
					hasUnmaxedHigherTier = true
					break
				end
			end
		end
	end

	for _, unit in ipairs(mine) do
		local stats = unit:FindFirstChild("_stats") or unit._stats
		local unitId = val(stats, "id")
		local def, n = units[unitId], val(stats, "upgrade", 0)
		local up = def and def.upgrade and def.upgrade[n + 1]
		if up then
			local cost = up.cost * scale * val(stats, "upgrade_cost_multiplier", 1)
			local farm = isFarmUnit(def, unitId)
			local rarityTier = (def.rarity and settings.RARITY_TIERS[def.rarity]) or 1

			if not farm and rarityTier <= 2 and hasUnmaxedHigherTier then
				continue
			end

			local upgradeScore
			if farm then
				upgradeScore = 110000000 + (up.farm_amount or 100) * 10 - n * 1000
			else
				local maxTierDps = dps(def, #(def.upgrade or {}))
				local gain = dps(def, n + 1) - dps(def, n)
				local upgradePower = rarityTier * 10000000 + maxTierDps * 500 + gain * 50
				upgradeScore = 30000000 + upgradePower - cost * 0.0001
			end
			offer({ name = "upgrade_unit_ingame", unit = unit }, cost, upgradeScore)
		end
	end
	if best then
		if best.name == "spawn_unit" then
			local legitEnabled = (cfg["Legit Mode"] == true or cfg.LegitMode == true)
			local isMatchmaking = currentMatchData and (currentMatchData.id == "__DAILY_CHALLENGE" or currentMatchData._MATCHMAKING ~= nil or MatchmakingModes[currentMatchData.id] ~= nil)
			if legitEnabled and isMatchmaking and best.cf then
				runToSpot(best.cf.Position)
			end
			pcall(remote, best.name, best.uuid, best.cf)
			return (attempt + 1) % 169
		end
		pcall(remote, best.name, best.unit)
	end
	return (attempt + 1) % 169
end

local function result(id, title)
	local job = game.JobId
	if job and job ~= "" and progress.ResultJob == job and progress.LastStage == id then
		return
	end
	if title == "INFINITE" or title == "LEVEL_FARM" then
		progress.LastResult = title
		progress.ResultJob = job
		checkpoint("Result", id)
		return
	elseif title:find("VICTORY", 1, true) then
		progress.Losses[id] = nil
		progress.MustRetryStory = nil
		progress.FarmInfinite = false
		progress.FarmLevel = false
		progress.DailyChallenge = false
		if progress.FarmLeft > 0 and id == story[1] then
			progress.FarmLeft -= 1
			if progress.FarmLeft == 0 then
				table.clear(progress.Losses)
			end
		end
		progress.LastResult = "VICTORY"
	else
		progress.Losses[id] = (progress.Losses[id] or 0) + 1
		progress.MustRetryStory = nil
		progress.LastResult = "DEFEAT"
	end
	progress.LastStage = id
	progress.ResultJob = job
	progress.Level = playerLevel() or progress.Level
	checkpoint("Result", id)
	webhook(progress.LastResult)
end

local function play()
	local map = workspace:FindFirstChild("_MAP_CONFIG")
	local getter = waitFor(function()
		return map:FindFirstChild("GetLevelData")
	end, 60)
	local data = getter:InvokeServer()
	assert(type(data) == "table" and known[data.id], "Kaitun requires a valid stage match.")
	assert(
		not data.difficulty or data.difficulty == "Normal" or data.difficulty == "Hard" or data.id == "namek_infinite" or data.id == "__DAILY_CHALLENGE",
		"Kaitun requires valid difficulty."
	)
	loot.start(data)
	status("Playing: " .. data.id)
	checkpoint("Match", data.id)
	currentMatchData = data
	table.clear(spots)

	local isDailyChallenge = data.id == "__DAILY_CHALLENGE"
	local isInfinite = data.id == "namek_infinite" or data.infinite == true
	local curLv = playerLevel() or progress.Level or 1
	local targetLevel = tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40
	local sessionData = inv and inv.session and inv.session.profile_data and inv.session.profile_data.level_data
	local doneTable = (sessionData and sessionData.completed_story_levels) or {}
	local uncompletedAct = nextNamekAct(doneTable)
	local isStoryLevelFarm = (not isInfinite) and (not isDailyChallenge) and (not uncompletedAct) and (curLv < targetLevel)
	local isMacroMode = not isDailyChallenge and (isInfinite or isStoryLevelFarm or progress.FarmInfinite or progress.FarmLevel)

	if isDailyChallenge then
		setActivity("Daily Challenge")
	elseif isInfinite or progress.FarmInfinite then
		setActivity("Farm Gems")
	elseif isStoryLevelFarm or progress.FarmLevel then
		setActivity("Farm Level")
	else
		setActivity("Story Mode")
	end

	local point
	if not isMacroMode then
		progress.MustRetryStory = nil
		local lane = waitFor(function()
			local obj = workspace:FindFirstChild("_BASES")
			obj = obj and obj:FindFirstChild("pve")
			obj = obj and obj:FindFirstChild("LANES")
			return obj and obj:FindFirstChild("1")
		end, 60)
		point = pathAt(lane)
	end

	if
		alive()
		and lobby() == false
		and not val(workspace:FindFirstChild("_DATA"), "GameFinished", false)
	then
		remote("toggle_setting", "autoskip_waves", true)
	end

	local attempt, voteAt = 0, -math.huge
	local macroStep = 1
	local macroRetries = 0
	local wave6Surrendered = false

	while alive() and lobby() == false do
		loot.sample()
		local waveNum = val(workspace, "_wave_num", 0)

		curLv = playerLevel() or progress.Level or 1
		targetLevel = tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40
		sessionData = inv and inv.session and inv.session.profile_data and inv.session.profile_data.level_data
		doneTable = (sessionData and sessionData.completed_story_levels) or {}
		uncompletedAct = nextNamekAct(doneTable)
		isStoryLevelFarm = (not isInfinite) and (not isDailyChallenge) and (not uncompletedAct) and (curLv < targetLevel)
		isMacroMode = not isDailyChallenge and (isInfinite or isStoryLevelFarm or progress.FarmInfinite or progress.FarmLevel)

		if isMacroMode and waveNum >= 6 and not wave6Surrendered then
			wave6Surrendered = true
			status(isInfinite and "Wave 6 reached in Infinite Mode! Voting lose game to end match..."
				or string.format("Wave 6 reached in Farm Level (Lv %d/%d)! Voting lose game to level up fast...", curLv, targetLevel))
			checkpoint(isInfinite and "InfiniteWave6" or "FarmLevelWave6", data.id)
			pcall(remote, "vote_lose_game")
		end

		local done = val(workspace:FindFirstChild("_DATA"), "GameFinished", false)
		if done then
			local waves = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("Waves")
			local hpText = waves and waves:FindFirstChild("HealthBar") and waves.HealthBar:FindFirstChild("HPDisplay") and waves.HealthBar.HPDisplay.Text
			local curHp = hpText and tonumber(hpText:match("^(%d+)")) or 0
			local waveNum = val(workspace, "_wave_num", 0)

			local titleText = nil
			local startWait = os.clock()
			repeat
				task.wait(0.3)
				if not alive() then
					return
				end
				local gui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
				if gui and gui.Enabled then
					local holder = gui:FindFirstChild("Holder")
					local btn = holder and holder:FindFirstChild("Buttons") and holder.Buttons:FindFirstChild("Next")
					if btn and btn.Visible and firesignal then
						pcall(firesignal, btn.MouseButton1Click)
					end
					local label = holder and holder:FindFirstChild("Title")
					local text = label and label.Text and label.Text:upper()
					if text and (text:find("VICTORY") or text:find("DEFEAT")) then
						titleText = text
						break
					end
				end
			until os.clock() - startWait >= 15

			local run, at = loot.run, os.clock()
			run.ended = at
			repeat
				task.wait(0.5)
				if not alive() then
					return
				end
				loot.sample()
			until (os.clock() - at >= 3 and os.clock() - (run.changed or at) >= 2)
				or os.clock() - at >= 10

			local outcome
			if isInfinite then
				outcome = "INFINITE"
			elseif isStoryLevelFarm or isMacroMode or wave6Surrendered then
				outcome = "LEVEL_FARM"
			elseif curHp <= 0 then
				outcome = "DEFEAT"
			elseif titleText and titleText:find("DEFEAT", 1, true) then
				outcome = "DEFEAT"
			elseif titleText and titleText:find("VICTORY", 1, true) then
				outcome = "VICTORY"
			else
				outcome = (curHp > 0) and "VICTORY" or "DEFEAT"
			end
			result(data.id, outcome)

			if isInfinite then
				local dailyEnabled = (cfg["Daily Challenge"] == true or cfg.DailyChallenge == true)
				local dailyReq = 25
				local curLv = tonumber(LP:FindFirstChild("_stats") and LP._stats:FindFirstChild("player_level") and LP._stats.player_level.Value) or (progress.Level or 1)
				local curCycleDay = math.floor((os.time() - 3600) / 86400)
				local challNeedsRun = dailyEnabled and curLv >= dailyReq and (progress.DailyChallengeDay ~= curCycleDay or not progress.DailyChallengeCleared)
				if challNeedsRun then
					if progress.DailyChallengeDay ~= curCycleDay then
						progress.DailyChallengeDay = curCycleDay
						progress.DailyChallengeCleared = false
						saveSession()
					end
					status("Daily Challenge reset while farming! Returning to lobby to do Daily Challenge...")
					checkpoint("DailyChallResetReturnLobby", data.id)
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					local resUI = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
					local retBtn = resUI and resUI:FindFirstChild("Finished") and resUI.Finished:FindFirstChild("Next")
					if retBtn and firesignal then
						pcall(firesignal, retBtn.MouseButton1Click)
					end
					task.wait(2)
					if alive() and not lobby() then
						pcall(function()
							TP:Teleport(settings.LOBBY_PLACE_ID, LP)
						end)
					end
					local waitEnd = os.clock() + 30
					repeat
						task.wait(0.5)
						if not alive() or lobby() == true then
							break
						end
						pcall(remote, "set_game_finished_vote", "lobby")
						pcall(remote, "teleport_back_to_lobby")
						if retBtn and firesignal then
							pcall(firesignal, retBtn.MouseButton1Click)
						end
					until os.clock() >= waitEnd
					return
				end

				local currentGems = val(LP:FindFirstChild("_stats"), "gem_amount", 0)
				if type(currentGems) ~= "number" then
					currentGems = 0
				end

				status(string.format("Infinite farm: Gems = %d. Replaying in same room...", currentGems))
				checkpoint("InfiniteReplay", data.id)
				progress.ResultJob = nil
				pcall(remote, "set_game_finished_vote", "replay")
				local gui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
				local retryBtn = gui and gui:FindFirstChild("Finished") and gui.Finished:FindFirstChild("NextRetry")
				if retryBtn and firesignal then
					pcall(firesignal, retryBtn.MouseButton1Click)
				end
				local reset = false
				local waitEnd = os.clock() + 30
				repeat
					task.wait(0.5)
					if not alive() or lobby() == true or not val(workspace:FindFirstChild("_DATA"), "GameFinished", false) then
						reset = true
						break
					end
				until os.clock() >= waitEnd
				if not reset and alive() and not lobby() then
					status("Replay vote timed out; returning to lobby as fallback")
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					pcall(function()
						TP:Teleport(settings.LOBBY_PLACE_ID, LP)
					end)
				end
				return
			end

			if isDailyChallenge then
				status(string.format("Daily Challenge finished (%s)! Returning to lobby to verify status...", outcome))
				checkpoint("DailyChallengeReturnLobby", data.id)
				pcall(remote, "set_game_finished_vote", "lobby")
				pcall(remote, "teleport_back_to_lobby")
				local resUI = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
				local retBtn = resUI and resUI:FindFirstChild("Finished") and resUI.Finished:FindFirstChild("Next")
				if retBtn and firesignal then
					pcall(firesignal, retBtn.MouseButton1Click)
				end
				task.wait(2)
				if alive() and not lobby() then
					pcall(function()
						TP:Teleport(settings.LOBBY_PLACE_ID, LP)
					end)
				end
				local waitEnd = os.clock() + 30
				repeat
					task.wait(0.5)
					if not alive() or lobby() == true then
						break
					end
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					if retBtn and firesignal then
						pcall(firesignal, retBtn.MouseButton1Click)
					end
				until os.clock() >= waitEnd
				return
			end

			if outcome == "LEVEL_FARM" then
				curLv = playerLevel() or progress.Level or 1
				targetLevel = tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40

				if curLv >= targetLevel then
					status(string.format("Level %d >= %d reached! Returning to lobby for Infinite farm gems...", curLv, targetLevel))
					checkpoint("LevelTargetReachedLobby", data.id)
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					local resUI = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
					local retBtn = resUI and resUI:FindFirstChild("Finished") and resUI.Finished:FindFirstChild("Next")
					if retBtn and firesignal then
						pcall(firesignal, retBtn.MouseButton1Click)
					end
					task.wait(2)
					if alive() and not lobby() then
						pcall(function()
							TP:Teleport(settings.LOBBY_PLACE_ID, LP)
						end)
					end
					local waitEnd = os.clock() + 30
					repeat
						task.wait(0.5)
						if not alive() or lobby() == true then
							break
						end
						pcall(remote, "set_game_finished_vote", "lobby")
						pcall(remote, "teleport_back_to_lobby")
						if retBtn and firesignal then
							pcall(firesignal, retBtn.MouseButton1Click)
						end
					until os.clock() >= waitEnd
					return
				end

				status(string.format("Level %d/%d: Replaying namek_level_1 (Hard) in room to farm level...", curLv, targetLevel))
				progress.ResultJob = nil
				pcall(remote, "set_game_finished_vote", "replay")
				local gui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
				local retryBtn = gui and gui:FindFirstChild("Finished") and gui.Finished:FindFirstChild("NextRetry")
				if retryBtn and firesignal then
					pcall(firesignal, retryBtn.MouseButton1Click)
				end
				local reset = false
				local waitEnd = os.clock() + 30
				repeat
					task.wait(0.5)
					if not alive() or lobby() == true or not val(workspace:FindFirstChild("_DATA"), "GameFinished", false) then
						reset = true
						break
					end
				until os.clock() >= waitEnd
				if not reset and alive() and not lobby() then
					status("Replay vote timed out; returning to lobby as fallback")
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					pcall(function()
						TP:Teleport(settings.LOBBY_PLACE_ID, LP)
					end)
				end
				return
			end

			if outcome == "VICTORY" then
				local curLv = playerLevel() or progress.Level or 1
				local targetLevel = tonumber(cfg["Target Level"] or cfg.TargetLevel) or 40
				local sessionData = inv and inv.session and inv.session.profile_data and inv.session.profile_data.level_data
				local doneTable = (sessionData and sessionData.completed_story_levels) or {}
				doneTable[data.id] = true
				local uncompletedAct = nextNamekAct(doneTable)

				if not uncompletedAct then
					status(string.format("Namek Cleared! Level %d/%d. Returning to lobby...", curLv, targetLevel))
					checkpoint("NamekClearedReturnLobby", data.id)
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					local resUI = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
					local retBtn = resUI and resUI:FindFirstChild("Finished") and resUI.Finished:FindFirstChild("Next")
					if retBtn and firesignal then
						pcall(firesignal, retBtn.MouseButton1Click)
					end
					task.wait(2)
					if alive() and not lobby() then
						pcall(function()
							TP:Teleport(settings.LOBBY_PLACE_ID, LP)
						end)
					end
					local waitEnd = os.clock() + 30
					repeat
						task.wait(0.5)
						if not alive() or lobby() == true then
							break
						end
						pcall(remote, "set_game_finished_vote", "lobby")
						pcall(remote, "teleport_back_to_lobby")
						if retBtn and firesignal then
							pcall(firesignal, retBtn.MouseButton1Click)
						end
					until os.clock() >= waitEnd
					return
				end

				roomFor(1, curLv)
				local nextAct = nextNamekAct(doneTable)
				if not nextAct then
					status("Namek story arc fully completed! Returning to lobby...")
					checkpoint("StoryCompleted")
					local retBtn = resultsUI and resultsUI:FindFirstChild("Finished") and resultsUI.Finished:FindFirstChild("Retry")
					if not retBtn then
						for _, desc in ipairs(resultsUI and resultsUI:GetDescendants() or {}) do
							if desc:IsA("TextButton") and desc.Name == "Retry" then
								retBtn = desc
								break
							end
						end
					end
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					if retBtn and firesignal then
						pcall(firesignal, retBtn.MouseButton1Click)
					end
					task.wait(2)
					pcall(remote, "leave_game")
					return
				end
				checkpoint(nextAct and "Next" or "Replay", nextAct or data.id)
				status(nextAct and ("Continuing: " .. nextAct) or "Replaying act")
				pcall(remote, "set_game_finished_vote", nextAct and "next_story" or "replay")
				local gui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
				local nextBtn = gui and gui:FindFirstChild("Finished") and (nextAct and gui.Finished:FindFirstChild("NextLevel") or gui.Finished:FindFirstChild("NextRetry"))
				if nextBtn and firesignal then
					pcall(firesignal, nextBtn.MouseButton1Click)
				end
				local reset = false
				local waitEnd = os.clock() + 60
				repeat
					task.wait(0.5)
					if not alive() or lobby() == true or not val(workspace:FindFirstChild("_DATA"), "GameFinished", false) then
						reset = true
						break
					end
				until os.clock() >= waitEnd
				if not reset and alive() and not lobby() then
					pcall(remote, "set_game_finished_vote", "lobby")
					pcall(remote, "teleport_back_to_lobby")
					pcall(function()
						TP:Teleport(settings.LOBBY_PLACE_ID, LP)
					end)
				end
				return
			end

			status("Story defeated. Returning to lobby...")
			checkpoint("DefeatReturnLobby", data.id)
			pcall(remote, "set_game_finished_vote", "lobby")
			pcall(remote, "teleport_back_to_lobby")
			local resUI = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("ResultsUI")
			local retBtn = resUI and resUI:FindFirstChild("Finished") and resUI.Finished:FindFirstChild("Next")
			if retBtn and firesignal then
				pcall(firesignal, retBtn.MouseButton1Click)
			end
			task.wait(2)
			if alive() and not lobby() then
				pcall(function()
					TP:Teleport(settings.LOBBY_PLACE_ID, LP)
				end)
			end
			local waitEnd = os.clock() + 30
			repeat
				task.wait(0.5)
				if not alive() or lobby() == true then
					break
				end
				pcall(remote, "set_game_finished_vote", "lobby")
				pcall(remote, "teleport_back_to_lobby")
				if retBtn and firesignal then
					pcall(firesignal, retBtn.MouseButton1Click)
				end
			until os.clock() >= waitEnd
			return
		end
		if waveNum == 0 and os.clock() >= voteAt then
			pcall(remote, "vote_start")
			voteAt = os.clock() + 5
		end
		if isMacroMode then
			if macroStep <= #INFINITE_NAMEK_STRAT then
				local stepData = INFINITE_NAMEK_STRAT[macroStep]
				local money = val(LP:FindFirstChild("_stats"), "resource", 0)
				if money >= stepData.money then
					local targetUuid
					local eq = equipped()
					for uuid in pairs(eq) do
						local u = owned()[uuid]
						if u and u.unit_id == stepData.unit then
							targetUuid = uuid
							break
						end
					end
					if not targetUuid then
						for _, u in pairs(owned()) do
							if u.unit_id == stepData.unit and u.equipped_slot ~= nil and type(u.uuid) == "string" then
								targetUuid = u.uuid
								break
							end
						end
					end
					if not targetUuid then
						for _, u in pairs(owned()) do
							if u.unit_id == stepData.unit and type(u.uuid) == "string" then
								targetUuid = u.uuid
								break
							end
						end
					end
					if targetUuid and stepData.cf then
						local legitEnabled = (cfg["Legit Mode"] == true or cfg.LegitMode == true)
						local isMatchmaking = currentMatchData and (currentMatchData.id == "__DAILY_CHALLENGE" or currentMatchData._MATCHMAKING ~= nil or MatchmakingModes[currentMatchData.id] ~= nil)
						if legitEnabled and isMatchmaking and stepData.cf then
							runToSpot(stepData.cf.Position)
						end
						local ok = pcall(remote, "spawn_unit", targetUuid, stepData.cf)
						if ok then
							status(
								"Macro ["
									.. macroStep
									.. "/"
									.. #INFINITE_NAMEK_STRAT
									.. "]: Spawned "
									.. stepData.unit
							)
							macroStep += 1
							macroRetries = 0
						else
							macroRetries += 1
							if macroRetries >= 5 then
								status(
									"Macro ["
										.. macroStep
										.. "/"
										.. #INFINITE_NAMEK_STRAT
										.. "]: Placement failed 5 times, skipping step"
								)
								macroStep += 1
								macroRetries = 0
							end
						end
					else
						macroStep += 1
						macroRetries = 0
					end
				end
			else
				local folder = workspace:FindFirstChild("_UNITS")
				local money = val(LP:FindFirstChild("_stats"), "resource", 0)
				local dataObj = workspace:FindFirstChild("_DATA")
				local scale = val(dataObj and dataObj:FindFirstChild("LevelModifiers"), "player_cost_scale", 1)
				if folder then
					local hasUnmaxedHigherTier = false
					for _, unit in ipairs(folder:GetChildren()) do
						local stats = unit:FindFirstChild("_stats")
						if stats and val(stats, "player") == LP then
							local unitId = val(stats, "id")
							local def = units[unitId]
							if def and not isFarmUnit(def, unitId) then
								local rTier = (def.rarity and settings.RARITY_TIERS[def.rarity]) or 1
								local curUp = val(stats, "upgrade", 0)
								local maxUp = #(def.upgrade or {})
								if rTier > 2 and curUp < maxUp then
									hasUnmaxedHigherTier = true
									break
								end
							end
						end
					end

					local bestUp, bestScore = nil, -math.huge
					for _, unit in ipairs(folder:GetChildren()) do
						local stats = unit:FindFirstChild("_stats")
						if stats and val(stats, "player") == LP then
							local unitId = val(stats, "id")
							local def, n = units[unitId], val(stats, "upgrade", 0)
							local up = def and def.upgrade and def.upgrade[n + 1]
							if up then
								local cost = up.cost * scale * val(stats, "upgrade_cost_multiplier", 1)
								local farm = isFarmUnit(def, unitId)
								local rarityTier = (def.rarity and settings.RARITY_TIERS[def.rarity]) or 1

								if not farm and rarityTier <= 2 and hasUnmaxedHigherTier then
									continue
								end

								if money >= cost then
									local score
									if farm then
										score = 110000000 + (up.farm_amount or 100) * 10 - n * 1000
									else
										local maxTierDps = dps(def, #(def.upgrade or {}))
										local gain = dps(def, n + 1) - dps(def, n)
										local upgradePower = rarityTier * 10000000 + maxTierDps * 500 + gain * 50
										score = 30000000 + upgradePower - cost * 0.0001
									end
									if score > bestScore then
										bestScore = score
										bestUp = unit
									end
								end
							end
						end
					end
					if bestUp then
						pcall(remote, "upgrade_unit_ingame", bestUp)
					end
				end
			end
		else
			attempt = combat(point, attempt)
		end
		task.wait(0.5)
	end
	currentMatchData = nil
	table.clear(spots)
end

local function getDisplayLevel()
	local pgui = LP and LP:FindFirstChild("PlayerGui")
	local obj = pgui
	for _, name in ipairs({ "spawn_units", "Lives", "Main", "Desc", "Level" }) do
		obj = obj and obj:FindFirstChild(name)
	end
	local lv = obj and tonumber(obj.Text:match("%d+"))
	if lv and lv > 0 then
		return lv
	end
	local pLevel = playerLevel()
	if pLevel and pLevel > 0 then
		return pLevel
	end
	return 1
end

local function getDisplayExp()
	local pgui = LP and LP:FindFirstChild("PlayerGui")
	local obj = pgui
	for _, name in ipairs({ "spawn_units", "Lives", "Main", "Desc", "Level" }) do
		obj = obj and obj:FindFirstChild(name)
	end
	if obj and obj.Text then
		local expPart = obj.Text:match("%[(.-)%]")
		if expPart then
			return expPart
		end
	end
	local stats = LP and LP:FindFirstChild("_stats")
	local pxp = stats and stats:FindFirstChild("player_xp")
	if pxp and tonumber(pxp.Value) then
		return string.format("%d XP", math.floor(tonumber(pxp.Value)))
	end
	return "0/0"
end

local function getDisplayGems()
	local stats = LP and LP:FindFirstChild("_stats")
	local gems = stats and stats:FindFirstChild("gem_amount")
	if gems and tonumber(gems.Value) then
		return math.floor(tonumber(gems.Value))
	end
	return 0
end

local function setupBlackScreen()
	if not (cfg["Black Screen"] == true or cfg.BlackScreen == true) then
		return
	end
	if blackScreenUI then
		return
	end
	pcall(function()
		game:GetService("RunService"):Set3dRenderingEnabled(false)
	end)
	pcall(function()
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
	end)
	pcall(function()
		game:GetService("StarterGui"):SetCore("TopbarEnabled", false)
	end)
	local CoreGui = game:GetService("CoreGui")
	for _, oldName in ipairs({ "Shouko.dev", "Bocchi Reworked" }) do
		local old = CoreGui:FindFirstChild(oldName)
		if old then
			pcall(function()
				old:Destroy()
			end)
		end
		if CoreGui:FindFirstChild("RobloxGui") then
			local oldRbx = CoreGui.RobloxGui:FindFirstChild(oldName)
			if oldRbx then
				pcall(function()
					oldRbx:Destroy()
				end)
			end
		end
	end
	local okLib, UiLib = pcall(function()
		local raw = game:HttpGet("https://raw.githubusercontent.com/Ngducok/doing-some-shit/refs/heads/main/UiLib.lua")
		return loadstring(raw)()
	end)
	if not okLib or type(UiLib) ~= "table" then
		return
	end
	local lp = LP or game:GetService("Players").LocalPlayer
	local okUi, ui = pcall(function()
		return UiLib.new({
			name = "Bocchi Reworked",
			padding = 8,
			autoSize = true,
			displayOrder = 2147483647,
			header = {
				text = "Bocchi Reworked [ " .. lp.Name .. " ]",
				color = Color3.fromRGB(69, 129, 203),
				textSize = 50,
				strokeColor = Color3.fromRGB(0, 0, 0),
				strokeThickness = 1,
				height = 80,
			},
			defaults = {
				font = Enum.Font.FredokaOne,
				textColor = Color3.fromRGB(255, 255, 255),
				strokeColor = Color3.fromRGB(0, 0, 0),
				strokeThickness = 1,
				textSize = 20,
				height = 30,
			},
			items = {
				{ name = "Level", prefix = "Level: ", value = getDisplayLevel() },
				{ name = "Exp", prefix = "Exp: ", value = getDisplayExp() },
				{
					name = "Gems",
					prefix = "Gems: ",
					value = getDisplayGems(),
					opts = {
						formatter = function(v)
							local s = tostring(v)
							return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
						end,
					},
				},
				{ name = "Status", prefix = "Status: ", value = k.Activity or "Idle" },
				{ name = "Step", prefix = "Step: ", value = k.State or "Starting..." },
			},
		})
	end)
	if not okUi or not ui then
		return
	end
	blackScreenUI = ui
	if ui._gui then
		pcall(function()
			ui._gui.Parent = CoreGui
		end)
		ui._gui.IgnoreGuiInset = true
		if pcall(function()
			return Enum.ScreenInsets.None
		end) then
			pcall(function()
				ui._gui.ScreenInsets = Enum.ScreenInsets.None
			end)
		end
		ui._gui.DisplayOrder = 2147483647
		local bg = Instance.new("Frame")
		bg.Name = "BlackBackground"
		bg.Size = UDim2.new(2, 0, 2, 0)
		bg.Position = UDim2.new(-0.5, 0, -0.5, 0)
		bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BorderSizePixel = 0
		bg.ZIndex = 0
		bg.Parent = ui._gui
		if ui._frame then
			ui._frame.ZIndex = 10
			for _, child in ipairs(ui._frame:GetDescendants()) do
				if child:IsA("GuiObject") then
					child.ZIndex = 11
				end
			end
		end
	end
	ui:bind("Level", getDisplayLevel, 1)
	ui:bind("Exp", getDisplayExp, 1)
	ui:bind("Gems", getDisplayGems, 1)
	ui:bind("Status", function()
		return k.Activity or "Idle"
	end, 0.5)
	ui:bind("Step", function()
		return k.State or "Idle"
	end, 0.5)
	status("Black Screen UI enabled")
end

local function run()
	while not LP do
		LP = game:GetService("Players").LocalPlayer
		task.wait(0.1)
	end
	if cfg.AntiAFK and not idle then
		idle = LP.Idled:Connect(function()
			if not alive() or not cfg.AntiAFK then
				return
			end
			local ok, err = pcall(function()
				local vu = game:GetService("VirtualUser")
				vu:CaptureController()
				vu:ClickButton2(Vector2.new(0, 0))
			end)
			if not ok then
				print("[Bocchi Kaitun] Anti AFK failed: " .. tostring(err))
			end
		end)
		status("Anti AFK enabled")
	end
	if cfg.FPSBoost then
		boost.set(true)
		status("FPS Boost enabled")
	end
	setupBlackScreen()
	status("Waiting for game client")
	local src = waitFor(function()
		if not game:IsLoaded() then
			return nil, "game loading"
		end
		local src = RS:FindFirstChild("src")
		if not src or not src:FindFirstChild("Loader") then
			return nil, "game assets not ready"
		end
		return src
	end, 120, "game client")
	local loader = require(src.Loader)
	inv = loader.load_client_service(script, "ItemInventoryServiceClient")
	assert(type(inv) == "table", "ItemInventoryServiceClient unavailable")
	waitFor(function()
		local session = inv.session
		local collection = session
			and session.collection
			and session.collection.collection_profile_data
		local items = session and session.inventory and session.inventory.inventory_profile_data
		if not collection or type(collection.owned_units) ~= "table" or not items then
			return nil, "inventory session not ready"
		end
		if lobby() == nil then
			return nil, "map config not ready"
		end
		if lobby() then
			local profile = session.profile_data
			local data = profile and profile.level_data
			if not playerLevel() or not data or type(data.completed_story_levels) ~= "table" then
				return nil, "player level or Story progress not ready"
			end
		end
		return true
	end, 60, "inventory session")
	status("Loaded inventory service and owned units")
	LevelServiceCore = loader.load_core_service(script, "LevelServiceCore")
	LevelUtilCore = loader.load_core_service(script, "LevelUtilCore")
	UnitServiceCore = loader.load_core_service(script, "UnitServiceCore")
	units = require(src.Data.Units)
	order = require(src.Data.WorldLevelOrder)
	settings = require(src.Data.GameplaySettings)
	banners = require(src.Data.Banners)
	levels = require(src.Data.Levels)
	local obj = src.Data:FindFirstChild("Items")
	if obj then
		local ok, data = pcall(require, obj)
		if ok and type(data) == "table" then
			loot.defs = data
		end
	end
	rem = RS.endpoints.client_to_server
	for _, id in ipairs(order.LEVEL_ORDER) do
		if id:match("_level_%d+$") then
			assert(levels[id], "Missing Story definition: " .. id)
			table.insert(story, id)
			known[id] = true
		end
	end
	if levels["namek_infinite"] then
		known["namek_infinite"] = true
	end
	known["__DAILY_CHALLENGE"] = true
	assert(#story > 0, "Story order unavailable.")
	loadSession()
	local notified = false
	while alive() do
		local isLobby = lobby()
		assert(isLobby ~= nil, "IsLobby missing")
		if isLobby then
			setActivity("Lobby")
			local lv = assert(playerLevel(), "Player level unavailable")
			progress.Level = lv
			claimLevelMilestones()
			if progress.LastStage == "__DAILY_CHALLENGE" then
				if isDailyChallengeCleared() then
					progress.DailyChallengeCleared = true
					saveSession()
					status("Daily Challenge verified: CLEARED!")
				else
					progress.DailyChallengeCleared = false
					saveSession()
					status("Daily Challenge verified: NOT CLEARED (will retry)")
				end
			end
			local done = inv.session.profile_data.level_data.completed_story_levels
			assert(type(done) == "table", "completed_story_levels missing")
			local plannedStage = plan(done, lv)
			if not plannedStage then
				status("No stage planned; waiting")
				task.wait(2)
				continue
			end
			if plannedStage == "__DAILY_CHALLENGE" then
				setActivity("Daily Challenge")
			elseif plannedStage == "namek_infinite" then
				setActivity("Farm Gems")
			elseif plannedStage == "namek_level_1" and (cfg.FarmLevel == true or cfg["Farm Level"] == true) then
				setActivity("Farm Level")
			else
				setActivity("Story Mode")
			end
			progress.Complete = false
			if not notified then
				webhook("Lobby overview")
				notified = true
			end
			if not progress.SummonPending then
				checkpoint("Lobby")
				claim()
				feedMacroUnits()
			end
			roomFor(1, lv)
			local isMacroStage = plannedStage == "namek_infinite" or (plannedStage == "namek_level_1" and (progress.FarmLevel or cfg.FarmLevel == true or cfg["Farm Level"] == true))
			local canJoin = true
			if isMacroStage and not hasMacroUnits() then
				canJoin = false
				local bCost = 50
				local balance = val(LP:FindFirstChild("_stats"), "gem_amount", 0)
				if type(balance) == "number" and balance >= bCost then
					setActivity("Summoning")
					status("Macro stage requires ichigo & naruto; summoning...")
					summon(lv)
					feedMacroUnits()
				else
					setActivity("Lobby")
					status("Macro stage requires ichigo & naruto; waiting for gems...")
				end
			elseif plannedStage ~= "__DAILY_CHALLENGE" and not progress.DailyChallenge and not isMacroStage then
				canJoin = summon(lv)
			end
			if canJoin and equip(team(lv, plannedStage)) then
				join(plannedStage)
			end
		else
			notified = false
			play()
		end
		task.wait(2)
	end
end

task.spawn(function()
	if not checkAccess() then
		return
	end
	task.spawn(watchAccess)
	if not alive() then
		return
	end
	local ok, err = pcall(run)
	if not ok and alive() then
		k.Error = tostring(err)
		progress.Error = k.Error
		setActivity("Stopped")
		status("Stopped: " .. k.Error)
		webhook("Stopped: " .. k.Error)
		k.Stop()
	end
end)

return k
