import { defineConfig } from "vite";
import path from "path";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import { powerApps } from "@microsoft/power-apps-vite";
import { existsSync } from "node:fs";

const powerAppsConfigPath = path.resolve(__dirname, "./power.config.json");
const powerAppsPlugins = existsSync(powerAppsConfigPath) ? [powerApps()] : [];

// https://vite.dev/config/
export default defineConfig({
  base: "/",
  plugins: [react(), tailwindcss(), ...powerAppsPlugins],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
