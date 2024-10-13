-- plugins/java.lua
return {
  {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-jdtls", -- Plugin Java (jdtls) pour LSP
    config = function()
      -- Configuration Java ici
      local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
      local config_dir = jdtls_dir .. "/config_linux"
      local plugins_dir = jdtls_dir .. "/plugins/"
      local path_to_jar = plugins_dir .. "org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
      local path_to_lombok = vim.fn.stdpath("data") .. "/mason/packages/lombok-nightly/lombok.jar"

      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == "" then
        return
      end

      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/java/workspace/" .. project_name

      local config = {
        cmd = {
          "/usr/bin/java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-javaagent:",
          path_to_lombok,
          "-Xms1g",
          "--add-modules",
          "ALL_SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          path_to_jar,
          "-configuration",
          config_dir,
          "-data",
          workspace_dir,
        },

        root_dir = root_dir,

        settings = {
          java = {
            home = vim.fn.stdpath("data") .. "/mason/packages/openjdk-17/",
            eclipse = { downloadSources = true },
            configuration = {
              updatesBuildConfiguration = "interactive",
              runtimes = {
                {
                  name = "openjdk-17",
                  path = "/usr/lib/jvm/java-17-openjdk/",
                },
              },
            },
          },

          maven = { downloadSources = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          refrences = { enabled = true },
          format = {
            enabled = true,
            settings = {
              url = vim.fn.stdpath("config") .. "/lang-server/intellij-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
        },

        flags = {
          allow_incremental_sync = true,
        },

        init_options = {
          bundles = {},
        },
      }

      -- Configuration des attaches supplémentaires
      config["on_attach"] = function(client, bufnr)
        require("keymaps").map_java_keys(bufnr)
        require("lsp_signature").on_attach({
          bind = true,
          floating_window_above_cur_line = false,
          handler_opts = { border = "rounded" },
        }, bufnr)
      end

      -- Lancer ou attacher jdtls
      require("jdtls").start_or_attach(config)
    end,
  },
}
