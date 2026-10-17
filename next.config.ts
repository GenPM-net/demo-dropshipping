import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // @core/kit-cms reads the database per request (no cacheComponents) and puts metadata in <head> for every client.
  cacheComponents: false,
  htmlLimitedBots: /.*/,
  turbopack: {
    rules: {
      "*.css": {
        loaders: ["@tailwindcss/turbopack"],
        as: "*.css",
      },
    },
  },
};

export default nextConfig;
