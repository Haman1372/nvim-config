-- LSP configuration for Neovim 0.11 and newer.

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local diagnostic_opts = {
    noremap = true,
    silent = true,
}

vim.keymap.set('n', '<Space>e', vim.diagnostic.open_float, diagnostic_opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, diagnostic_opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, diagnostic_opts)
vim.keymap.set('n', '<Space>q', vim.diagnostic.setloclist, diagnostic_opts)

local function on_attach(_, bufnr)
    local function map(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = desc,
        })
    end

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    map('gD', vim.lsp.buf.declaration, 'LSP Declaration')
    map('gd', vim.lsp.buf.definition, 'LSP Definition')
    map('K', vim.lsp.buf.hover, 'LSP Hover')
    map('gi', vim.lsp.buf.implementation, 'LSP Implementation')
    map('<C-k>', vim.lsp.buf.signature_help, 'LSP Signature Help')
    map('<Space>wa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
    map('<Space>wr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')

    map('<Space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'List Workspace Folders')

    map('<Space>D', vim.lsp.buf.type_definition, 'LSP Type Definition')
    map('<Space>rn', vim.lsp.buf.rename, 'LSP Rename')
    map('<Space>ca', vim.lsp.buf.code_action, 'LSP Code Action')
    map('gr', vim.lsp.buf.references, 'LSP References')

    map('<Space>f', function()
        vim.lsp.buf.format({ async = true })
    end, 'LSP Format')
end

vim.lsp.config('pyright', {
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config('clangd', {
    cmd = { 'clangd', '--query-driver=/usr/bin/gcc' },
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'c', 'cpp', 'h', 'hpp' },
})

vim.lsp.enable({ 'pyright', 'clangd' })
