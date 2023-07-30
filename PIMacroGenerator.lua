--[[
    Created by Slothpala for good boy Flex
--]]
local function PIMGPrint(txt,color)
    local color = color or "FFFFFF"
    print("\124cffFFD700PIMG: \124r\124cff"..color..txt.."\124r")
end

SLASH_PIMacroGenerator1, SLASH_PIMacroGenerator2  = "/pimacro", "/pim"
SlashCmdList["PIMacroGenerator"] = function(msg) 
    if InCombatLockdown() then
        PIMGPrint("Macros can only be created out of combat.","F82C00")
        return
    end
    if MacroFrame and MacroFrame:IsShown() then
        PIMGPrint("Cant update Macro with open Macro Frame. Please close the Macro Frame and repeat.","F82C00")
        return
    end
    local numGlobalMacros = GetNumMacros()
    local alreadyHasMacro 
    if GetMacroIndexByName("PIMG") == 0 then
        alreadyHasMacro = false
    else
        alreadyHasMacro = true
    end
    if(numGlobalMacros>119) and not alreadyHasMacro then
        PIMGPrint("You can't have any more macros! Please delete one and repeat.","F82C00")
        return
    end
    local userAdded = PIMacroGeneratorDB or ""
    if msg ~= "" then
        if msg:match("add ") then
            userAdded = ""
            userAdded = string.sub(msg, 5)
            userAdded = string.gsub(userAdded,"/","\n/")
            PIMGPrint(userAdded,"A5AAD9")
            print("added to the macro.")
        end
        if msg:match("reset") then
            userAdded = ""
            PIMGPrint("user added values removed.")
        end
        PIMacroGeneratorDB = userAdded
    end
    local name = UnitName("target") 
    if not name then 
        PIMGPrint("No PI target.","F82C00")
        name = ""
    end
    local localizedSpellName = GetSpellInfo(10060)
    local macroText = "#showtooltip\n/cast [@"..name..",help,nodead][] "..localizedSpellName.. "\n/cast [@player] "..localizedSpellName
    local body = macroText .. userAdded
    if not alreadyHasMacro then 
        CreateMacro("PIMG", 135939, body)
        PIMGPrint("A Macro in your General Macros tab has been generated.","61EE96")
    else 
        EditMacro("PIMG", "PIMG", 135939, body)
        if name ~= "" then
            local targetClassColor =  C_ClassColor.GetClassColor(select(2,UnitClass("target")))
            PIMGPrint("New PI target: "..targetClassColor:GenerateHexColorMarkup()..name.."\124r","90ee90")
        end
    end  
end