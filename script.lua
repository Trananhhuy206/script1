--[[ 
    SOLARA PRO FPS HUB v7.1 - PRIVATE EDITION
    DEVELOPED SOLELY BY: HuyMods
    LOGIC: COMBAT, VISUALS, HITBOX, BYPASS
    STATUS: PROTECTED & ENCRYPTED
]]--

local AUTHOR = "HuyMods"
local VERSION = "v7.1"

local _0xO1 = {
    "\108\111\111\107\115\116\114\105\110\103", -- loadstring
    "\104\116\116\112\115\58\47\47\115\105\114\105\117\115\46\109\101\110\117\47\114\97\121\102\105\101\108\100",
    "\80\108\97\121\101\114\115", "\82\117\110\83\101\114\118\105\99\101", 
    "\85\115\101\114\73\110\112\117\116\83\101\114\118\105\99\101",
    "\72\101\97\100", "\104\101\97\100", "\84\111\114\115\111", 
    "\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116"
}

local _0xL, _0xG = loadstring, game;
local _0xS = _0xG.GetService;
local _0xP, _0xR, _0xU = _0xS(_0xG, _0xO1[3]), _0xS(_0xG, _0xO1[4]), _0xS(_0xG, _0xO1[5]);
local _0xC, _0xLP = workspace.CurrentCamera, _0xP.LocalPlayer;
local _0xCA = {};

local _0xST = {
    _A=false, _TP=_0xO1[6], _SM=0.4, _F=150, _SF=true, _W=true, _TC=true,
    _HE=false, _HBP=false, _HS=12, _HT=0.7,
    _EE=false, _EB=false, _EN=false, _EH=false, _ET=false, _EC=Color3.fromRGB(255,0,0)
}

-- [WATERMARK]
local WM = Drawing.new("Text")
WM.Text = AUTHOR .. " - Solara " .. VERSION .. " | Running"
WM.Size = 18; WM.Outline = true; WM.Center = false; WM.Visible = true;
WM.Color = Color3.fromRGB(255, 255, 255); WM.Position = Vector2.new(30, 30);

local _0xFC = Drawing.new("\67\105\114\99\108\101");
_0xFC.Thickness=1; _0xFC.NumSides=60; _0xFC.Color=Color3.fromRGB(255,255,255); _0xFC.Visible=false;

local _0xRF = _0xL(_0xG.HttpGet(_0xG, _0xO1[2]))();
local _0xWN = _0xRF:CreateWindow({
    Name = "Solara Hub | " .. AUTHOR, 
    LoadingTitle = "Auth: " .. AUTHOR .. " Private Logic...", 
    ConfigurationSaving = {Enabled = false}
})

-- [HELPER MODULES]
local function _0xGTP(_0xCH)
    if _0xST._TP == "\72\101\97\100" then return _0xCH:FindFirstChild(_0xO1[6])
    elseif _0xST._TP == "\84\111\114\115\111" then return _0xCH:FindFirstChild(_0xO1[9]) or _0xCH:FindFirstChild("\85\112\112\101\114\84\111\114\115\111")
    else local p={"\72\101\97\100","\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116"} return _0xCH:FindFirstChild(p[math.random(1,2)]) end
end

local function _0xVIS(_0xPT)
    if not _0xST._W then return true end
    local _0xRP = RaycastParams.new(); _0xRP.FilterType=Enum.RaycastFilterType.Exclude; _0xRP.FilterDescendantsInstances={_0xLP.Character, _0xPT.Parent, _0xC}
    return workspace:Raycast(_0xC.CFrame.Position, _0xPT.Position-_0xC.CFrame.Position, _0xRP)==nil
end

local function _0xMESP(_0xPL)
    if _0xPL==_0xLP then return end
    local function _0xINI()
        if _0xCA[_0xPL] then return end
        _0xCA[_0xPL]={B=Drawing.new("\83\113\117\97\114\101"), N=Drawing.new("\84\101\120\116"), HO=Drawing.new("\76\105\110\101"), HB=Drawing.new("\76\105\110\101"), T=Drawing.new("\76\105\110\101")}
        local d=_0xCA[_0xPL]; d.B.Thickness=1; d.B.Filled=false; d.N.Size=14; d.N.Center=true; d.N.Outline=true; d.HO.Thickness=3; d.HO.Color=Color3.fromRGB(0,0,0); d.HB.Thickness=1; d.T.Thickness=1
    end
    _0xPL.CharacterAdded:Connect(_0xINI); if _0xPL.Character then _0xINI() end
end

-- [UI TABS]
local _0xT1 = _0xWN:CreateTab("Aim Assist")
_0xT1:CreateToggle({Name="Enable Auto-Lock", CurrentValue=false, Callback=function(v)_0xST._A=v end})
_0xT1:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v)_0xST._TC=v end})
_0xT1:CreateSlider({Name="Smoothing", Range={0.01,1}, Increment=0.05, CurrentValue=0.4, Callback=function(v)_0xST._SM=v end})
_0xT1:CreateSlider({Name="FOV Radius", Range={30,800}, Increment=10, CurrentValue=150, Callback=function(v)_0xST._F=v end})
_0xT1:CreateDropdown({Name="Target Part", Options={"Head","Torso","Random"}, CurrentOption="Head", Callback=function(v)_0xST._TP=v end})
_0xT1:CreateToggle({Name="Display FOV", CurrentValue=true, Callback=function(v)_0xST._SF=v end})

local _0xT2 = _0xWN:CreateTab("Sensory ESP")
_0xT2:CreateToggle({Name="Master Switch", CurrentValue=false, Callback=function(v)_0xST._EE=v end})
_0xT2:CreateToggle({Name="Bounding Box", CurrentValue=false, Callback=function(v)_0xST._EB=v end})
_0xT2:CreateToggle({Name="Identity Tags", CurrentValue=false, Callback=function(v)_0xST._EN=v end})
_0xT2:CreateToggle({Name="Vitals Monitor", CurrentValue=false, Callback=function(v)_0xST._EH=v end})
_0xT2:CreateToggle({Name="Distance Tracers", CurrentValue=false, Callback=function(v)_0xST._ET=v end})

local _0xT3 = _0xWN:CreateTab("Modifications")
_0xT3:CreateToggle({Name="Hitbox Expander", CurrentValue=false, Callback=function(v)_0xST._HE=v end})
_0xT3:CreateSlider({Name="Extender Size", Range={2,30}, Increment=1, CurrentValue=12, Callback=function(v)_0xST._HS=v end})

-- [MAIN RUNNER]
_0xR.RenderStepped:Connect(function()
    local _0xMP = _0xU:GetMouseLocation()
    _0xFC.Visible = _0xST._A and _0xST._SF; _0xFC.Radius = _0xST._F; _0xFC.Position = _0xMP
    local _0xCT, _0xSD = nil, _0xST._F

    for _, _0xPL in pairs(_0xP:GetPlayers()) do
        if _0xPL ~= _0xLP then
            local _0xIT = _0xST._TC and _0xPL.Team == _0xLP.Team
            local _0xCH = _0xPL.Character; local _0xH = _0xCH and _0xCH:FindFirstChild(_0xO1[9]); local _0xHM = _0xCH and _0xCH:FindFirstChild("\72\117\109\97\110\111\105\100")
            local d = _0xCA[_0xPL]

            if _0xH and _0xHM and _0xHM.Health > 0 then
                local _0xVP, _0xOS = _0xC:WorldToViewportPoint(_0xH.Position)

                -- Hitbox Logic
                if _0xST._HE and not _0xIT then
                    _0xH.Size = Vector3.new(_0xST._HS, _0xST._HS, _0xST._HS); _0xH.Transparency = _0xST._HT; _0xH.CanCollide = false
                elseif _0xH then _0xH.Size = Vector3.new(2,2,1); _0xH.Transparency = 1 end

                -- ESP Logic
                if d then
                    local _0xVIS_ESP = _0xST._EE and _0xOS and not _0xIT
                    d.B.Visible=_0xVIS_ESP and _0xST._EB; d.N.Visible=_0xVIS_ESP and _0xST._EN; d.T.Visible=_0xVIS_ESP and _0xST._ET
                    if _0xVIS_ESP then
                        local sx, sy = 2000/_0xVP.Z, 3000/_0xVP.Z
                        d.B.Size=Vector2.new(sx,sy); d.B.Position=Vector2.new(_0xVP.X-sx/2, _0xVP.Y-sy/2); d.B.Color=_0xST._EC
                        d.N.Text=string.format("%s • [%dM]", _0xPL.Name, math.floor(_0xVP.Z))
                        d.N.Position=Vector2.new(_0xVP.X, _0xVP.Y+sy/2+5)
                        if _0xST._EH then
                            local h = _0xHM.Health/_0xHM.MaxHealth
                            d.HO.Visible=true; d.HO.From=Vector2.new(_0xVP.X-sx/2-5, _0xVP.Y+sy/2); d.HO.To=Vector2.new(_0xVP.X-sx/2-5, _0xVP.Y-sy/2)
                            d.HB.Visible=true; d.HB.From=d.HO.From; d.HB.To=Vector2.new(_0xVP.X-sx/2-5, (_0xVP.Y+sy/2)-(sy*h)); d.HB.Color=Color3.fromHSV(h*0.3,1,1)
                        else d.HO.Visible=false; d.HB.Visible=false end
                        d.T.From=Vector2.new(_0xC.ViewportSize.X/2, _0xC.ViewportSize.Y); d.T.To=Vector2.new(_0xVP.X, _0xVP.Y); d.T.Color=_0xST._EC
                    else d.B.Visible=false; d.N.Visible=false; d.HO.Visible=false; d.HB.Visible=false; d.T.Visible=false end
                end

                -- Target Selection
                if _0xOS and not _0xIT then
                    local _0xDI = (Vector2.new(_0xVP.X, _0xVP.Y)-_0xMP).Magnitude
                    if _0xDI < _0xSD then
                        local _0xTPART = _0xGTP(_0xCH)
                        if _0xTPART and _0xVIS(_0xTPART) then _0xSD=_0xDI; _0xCT=_0xTPART end
                    end
                end
            elseif d then d.B.Visible=false; d.N.Visible=false; d.HO.Visible=false; d.HB.Visible=false; d.T.Visible=false end
        end
    end

    if _0xCT and _0xST._A and (_0xU:IsMouseButtonPressed(0) or _0xU:IsMouseButtonPressed(1)) then
        _0xC.CFrame = _0xC.CFrame:Lerp(CFrame.new(_0xC.CFrame.Position, _0xCT.Position), _0xST._SM)
    end
end)

for _, p in pairs(_0xP:GetPlayers()) do _0xMESP(p) end
_0xP.PlayerAdded:Connect(_0xMESP);

_0xRF:Notify({
    Title = AUTHOR .. " HUB ACTIVATED", 
    Content = "All logic modules secured. Dev: " .. AUTHOR,
    Duration = 5
});
