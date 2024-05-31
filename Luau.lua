local toolbar = plugin:CreateToolbar("Mesh ID Sender")
local button = toolbar:CreateButton("Send Mesh IDs", "just sending meshes ok?", "icon.png")

local HttpService = game:GetService("HttpService")

local function sendId(meshIds)
    local url = "http://0.0.0.0:5000/uumeshids"
    local body = HttpService:JSONEncode(meshIds)
    HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
end

local function collectMeshIds()
    local found = {}
    local function Descendants(parent)
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("MeshPart") or obj:IsA("SpecialMesh") then
                if not found[obj.MeshId] then
                    found[obj.MeshId] = true
                end
            end
        end
    end

    for _, service in ipairs(game:GetChildren()) do
        Descendants(service)
    end
    return found
end

button.Click:Connect(function()
    local meshIds = collectMeshIds()
    local count = 0
    for _ in pairs(meshIds) do count = count + 1 end
    if count > 0 then
        sendId(meshIds)
        print(">>>>>>> MESH IDS COLLECTED AND SENT TO SERVER: " .. count .. " FOUND ")
    else
        print(">>>>>>> NO MESHES")
    end
end)
