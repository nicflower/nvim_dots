local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
ActiveLsp = {
    condition = conditions.lsp_attached,
    update = {'LspAttach', 'LspDetach'},

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
        end
        return "[  " .. table.concat(names, " ") .. " ]"
    end,
    hl = { fg = "lsp" },
}

return {ActiveLsp}
