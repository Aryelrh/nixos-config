-- lua/plugins/liveserver.lua
-- Live Server vía npx: no requiere instalación extra, usa nodejs ya instalado.
-- Atajos:
--   <leader>lu  → inicia live-server y copia el link al clipboard
--   <leader>ll  → muestra/copia el link del archivo actual (sin reiniciar)
--   <leader>lx  → detiene el servidor

local port = 5500
local job_id = nil

local function get_url()
  local relative = vim.fn.expand("%:.")
  return "http://localhost:" .. port .. "/" .. relative
end

local function notify_url()
  local url = get_url()
  vim.fn.setreg("+", url)
  vim.notify(url, vim.log.levels.INFO, { title = "Live Server" })
end

local function start()
  if job_id then
    vim.notify("Live Server is running", vim.log.levels.WARN, { title = "Live Server" })
    notify_url()
    return
  end
  local cwd = vim.fn.getcwd()
  job_id = vim.fn.jobstart(
    { "npx", "live-server", "--port=" .. tostring(port), "--no-browser" },
    { cwd = cwd, detach = false }
  )
  vim.notify("Live Server starting...", vim.log.levels.INFO, { title = "Live Server" })
  vim.defer_fn(notify_url, 1500)
end

local function stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
    vim.notify("Live Server stop", vim.log.levels.INFO, { title = "Live Server" })
  else
    vim.notify("Live Server is not running", vim.log.levels.WARN, { title = "Live Server" })
  end
end

return {
  {
    "nvim-lua/plenary.nvim",
    ft = { "html", "css", "javascript" },
    keys = {
      { "<leader>lu", start,      desc = "Live Server: start and show link" },
      { "<leader>ll", notify_url, desc = "Live Server: show link" },
      { "<leader>lx", stop,       desc = "Live Server: stop" },
    },
  },
}
