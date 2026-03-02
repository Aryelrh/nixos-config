-- lua/plugins/liveserver.lua
-- Live Server: previsualización en tiempo real del HTML en el navegador
-- Uso:
--   :LiveServerStart   → inicia el servidor
--   :LiveServerStop    → detiene el servidor
--   <leader>lu         → inicia el servidor y muestra el link del archivo actual
--   <leader>ll         → muestra el link del archivo actual (sin reiniciar)
return {
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    ft = { "html", "css", "javascript" },
    keys = {
      {
        "<leader>lu",
        function()
          vim.cmd("LiveServerStart")
          local relative = vim.fn.expand("%:.")
          local url = "http://localhost:5500/" .. relative
          vim.notify(url, vim.log.levels.INFO, { title = "Live Server" })
          vim.fn.setreg("+", url) -- copia al clipboard
        end,
        desc = "Live Server: iniciar y mostrar link",
      },
      {
        "<leader>ll",
        function()
          local relative = vim.fn.expand("%:.")
          local url = "http://localhost:5500/" .. relative
          vim.notify(url, vim.log.levels.INFO, { title = "Live Server" })
          vim.fn.setreg("+", url) -- copia al clipboard
        end,
        desc = "Live Server: mostrar link del archivo actual",
      },
    },
    config = function()
      require("live-server").setup({
        args = { "--port=5500", "--no-browser" },
      })
    end,
  },
}
