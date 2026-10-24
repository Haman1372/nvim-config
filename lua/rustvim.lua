-- Rust configuration for rustaceanvim.

vim.g.rustaceanvim = {
    server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-space>", function()
                vim.cmd.RustLsp({ "hover", "actions" })
            end, {
                buffer = bufnr,
                silent = true,
                desc = "Rust hover actions",
            })

            vim.keymap.set("n", "<Leader>a", function()
                vim.cmd.RustLsp("codeAction")
            end, {
                buffer = bufnr,
                silent = true,
                desc = "Rust code actions",
            })
        end,
    },
    dap = {
        adapter = {
            type = "executable",
            command = "/usr/bin/lldb-dap",
            name = "lldb",
        },
    },
}

-- Use LLDB-DAP's internal console for Rust launch configurations.
local dap = require("dap")

dap.listeners.on_config["rust_internal_console"] = function(config)
    if vim.bo.filetype == "rust" and config.request == "launch" then
        config.console = "internalConsole"
        config.runInTerminal = nil
        vim.notify(
            "Rust DAP: internalConsole applied",
            vim.log.levels.INFO
        )
    end

    return config
end
