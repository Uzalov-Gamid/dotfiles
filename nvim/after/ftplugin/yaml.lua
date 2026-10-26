-- YAML (docker-compose, Kubernetes, Ansible, GitHub Actions, Prometheus…):
-- 2 spaces, never tabs. A column highlight helps keep keys aligned.
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.cursorcolumn = true
-- typing "#" or ":" must not re-indent the line
vim.opt_local.indentkeys:remove({ "0#", "<:>" })
