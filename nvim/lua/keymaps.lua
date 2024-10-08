local KeyMap = {}

function KeyMap.config()
    print("configuring keymaps")
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })

    local function telescope_live_grep_open_files()
        require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end
    vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
    vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>ex', ':Explore<cr>', { desc = '[EX]plorer' })
    KeyMap.lsp()
    KeyMap.harpoon()
    vim.keymap.set(
        'n',
        '<leader>a',
        '<cmd>lua require("fastaction").code_action()<CR>',
        { buffer = bufnr }
    )
    vim.keymap.set(
        'v',
        '<leader>a',
        "<esc><cmd>lua require('fastaction').range_code_action()<CR>",
        { buffer = bufnr }
    )
end

function KeyMap.lsp()
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'LSP: [G]oto [R]eferences' })
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: [R]e[n]ame' })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: [C]ode [A]ction' })
            vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'LSP: [G]oto [D]efinition' })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: [G]oto [D]eclaration' })
            vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
                { desc = 'LSP: [G]oto [I]mplementation' })
            vim.keymap.set('n', '<leader>D', require('telescope.builtin').lsp_type_definitions,
                { desc = 'LSP: Type [D]efinition' })
            vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols,
                { desc = 'LSP: [D]ocument [S]ymbols' })
            vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                { desc = 'LSP: [W]orkspace [S]ymbols' })
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' })
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Documentation' })

            --nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            --nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            --nmap('<leader>wl', function()
            --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            --end, '[W]orkspace [L]ist Folders')
            vim.api.nvim_buf_create_user_command(0, 'Format', function(_)
                vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
        end
    })
end

function KeyMap.harpoon()
    --local hooks_setup = harpoon.hooks_setup --this should be true before running the following, at the moment this is ensured by lazy.nvim
    local harpoon = require('harpoon')
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        require('telescope.pickers').new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    end
    vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)

    vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end,
        { desc = 'Open harpoon window' })
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)


    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end

return KeyMap
